---@class BaseInventory:BaseInventoryClassCreateInterface
local Module <const> = {}
---@type table<number, boolean>
Module.observers = {}
---@type InventoryItem[]
Module.items = {}
---@type string
Module.inventoryName = ""
---@type InventoryTypes
Module.type = "base"
Module.__index = Module

ScriptServer.Classes.BaseInventory = Module

---@class BaseInventoryClassCreateInterface
---@field slotsAmount number
---@field maxWeight number
---@field uniqueID string
---@field inventoryName string
---@field type InventoryTypes

---@param data BaseInventoryClassCreateInterface
Module.new = function(data)
    local self = setmetatable({}, Module)

    local inv_sql <const> = exports.oxmysql:single_async(
        "SELECT * FROM inventory_4_items WHERE uniqueID = ? AND type = ?",
        {
            data.uniqueID,
            data.type
        }
    ) --[[@as DB_Inventory]]

    ---@type InventoryItem[]
    local format_items <const> = {}

    local sql_items = {}
    if inv_sql and type(inv_sql.items) == "string" then
        sql_items = json.decode(inv_sql.items)
    end

    for i = 1, #sql_items do
        local v <const> = sql_items[i]
        local iData <const> = ScriptShared.Items:Get(v.name)
        if iData then
            format_items[#format_items+1] = {
                name = v.name,
                quantity = v.quantity,
                slot = v.slot,
                itemHash = v.itemHash,
                meta = type(v.meta) == "table" and v.meta or type(iData.defaultMeta) == "table" and iData.defaultMeta or {},
                data = iData,
                coordX = v.coordX,
                coordY = v.coordY,
                coordZ = v.coordZ
            }
        end
    end

    self.uniqueID = data.uniqueID
    self.maxWeight = data.maxWeight
    self.slotsAmount = data.slotsAmount
    self.inventoryName = data.inventoryName
    self.type = data.type
    self.items = format_items
    self.observers = {}

    ScriptServer.Managers.Inventory.Inventories[self.uniqueID] = self

    return self
end

function Module:addObserver(source)
    if self.observers[source] then return end

    self.observers[source] = true

    TriggerEvent("inventory:onObserverAdded", self.uniqueID, source)
end

function Module:removeObserver(source)
    if not self.observers[source] then return end

    self.observers[source] = nil

    TriggerEvent("inventory:onObserverRemoved", self.uniqueID, source)
end

function Module:hasObserver(source)
    return type(self.observers[source]) == "boolean" and self.observers[source] or false
end

---@param cb fun(source: number)
function Module:triggerObservers(cb)
    if type(cb) ~= "function" then return end

    for observerSource in pairs(self.observers) do
        cb(observerSource)
    end
end

---@param item InventoryItem
---@param findBy findByOptions
---@private
function Module:findByChecker(item, findBy)
    local check_name <const> = findBy.name == nil or type(findBy.name) == "string" and findBy.name == item.name
    local check_quantity <const> = findBy.quantity == nil or type(findBy.quantity) == "number" and findBy.quantity == item.quantity
    local check_slot <const> = findBy.slot == nil or type(findBy.slot) == "number" and findBy.slot == item.slot
    local check_itemHash <const> = findBy.itemHash == nil or type(findBy.itemHash) == "string" and findBy.itemHash == item.itemHash

    -- By metadata.
    local check_meta = true
    if type(findBy.meta) == "table" and type(item.meta) == "table" then
        for k,v in pairs(findBy.meta) do
            if item.meta[k] ~= v then
                check_meta = false
                break
            end
        end
    end

    return (
        check_name and
        check_meta and
        check_quantity and
        check_slot and
        check_itemHash
    )
end

--- Only returns a single item. (found by the match)
---@param findBy findByOptions
function Module:getItemBy(findBy)
    for i = 1, #self.items, 1 do
        local v = self.items[i]
        if self:findByChecker(v, findBy) then
            return v
        end
    end
end

--- Returns more items. (found by the match)
---@param findBy findByOptions
function Module:getItemsBy(findBy)
    ---@type InventoryItem[]
    local items <const> = {}
    local found = 0

    for i = 1, #self.items, 1 do
        local v = self.items[i]
        if self:findByChecker(v, findBy) then
            items[#items+1] = v
            found += 1
        end
    end

    return items, found
end

--- Returns all of the quantity if the arguments are met.
---@param findBy findByOptions
function Module:getItemQuantityBy(findBy)
    local quantity = 0

    for i = 1, #self.items, 1 do
        local v = self.items[i]
        if self:findByChecker(v, findBy) then
            quantity += v.quantity
        end
    end

    return quantity
end

--- Get the weight of the inventory (current items)
function Module:getWeight()
    local weight = 0.0

    for i = 1, #self.items, 1 do
        local v = self.items[i]
        weight += v.data.stackable and (v.data.weight * v.quantity) or v.data.weight
    end

    return math.floor(weight * 10 ^ 2 + 0.5) / 10 ^ 2
end

function Module:getEmptySlot()
    for i = 1, self.slotsAmount do
        if not self:getItemBy({ slot = i }) then
            return i
        end
    end
end

function Module:generateUniqueItemHash()
    return os.time() .. "-" .. math.random(1, 1000000)
end

-- Generates a serial number for weapon(s).
function Module:generateSerialNumber()
    local serial = ""
    for i = 1, 8 do
        -- Generate a random character from A-Z or 0-9
        local randomChar = string.char(math.random(48, 57), math.random(65, 90))
        serial = serial .. randomChar
    end
    return serial
end

---@param name string
---@param quantity number
function Module:setItemQuantity(name, quantity)
    local items = self:getItemsBy({ name = name })
    if #items < 1 then
        self:addItem({
            name = name,
            quantity = quantity
        })
    elseif #items == 1 then
        if tonumber(quantity) <= 0 then
            self:removeItemBy(items[1].quantity, { name = items[1].name })
            return
        end
        local item = items[1]
        item.quantity = quantity
        self:OnItemUpdated(item)
    else
        for i = 1, #items, 1 do
            self:removeItemBy(items[i].quantity, { name = items[i].name }) 
        end

        self:addItem({
            name = name,
            quantity = quantity
        })
    end
end

function isRegisteredItem(name)
    local iData <const> = ScriptShared.Items:Get(name)
    
    if (iData) then
        return iData
    end

end

---@class AddItemInterface
---@field name string
---@field quantity? number
---@field meta? InventoryItemMetaData
---@field toSlot? number

---@param data AddItemInterface
---@param ignoreWeight? boolean
function Module:addItem(data, ignoreWeight)
    local iData <const> = ScriptShared.Items:Get(data.name)
    if not iData then
        return ScriptShared:createRet({ success = false, response = "item_not_registered" })
    end

    if (data.quantity <= 0) then return end

    if type(data.quantity) ~= "number" or data.quantity < 1 then data.quantity = 1 end

    if not data.meta then
        data.meta = {}
    end

    if iData.defaultMeta then
        for k, v in pairs(iData.defaultMeta) do
            if data.meta[k] == nil then
                data.meta[k] = v
            end
        end
    end

    if not ignoreWeight and not self:canCarryWeight(data.name, data.quantity) then
        return ScriptShared:createRet({ success = false, response = "weight_exceed" })
    end

    -- If its a weapon then generate a serial number.
    if iData.generateSerial and type(data.meta.serial) ~= "string" then
        data.meta.serial = self:generateSerialNumber()
    end

    if type(data.toSlot) == "number" then
        if iData.stackable then
            local onSlotItem <const> = self:getItemBy({ slot = data.toSlot })
            if onSlotItem then
                if onSlotItem.name ~= data.name then
                    return ScriptShared:createRet({ success = false, response = "item_can_not_stack"  })
                end

                onSlotItem.quantity += data.quantity
                self:OnItemUpdated(onSlotItem)
                return ScriptShared:createRet({ success = true, response = "added_item_on_stack", item = onSlotItem })
            else
                self.items[#self.items+1] = {
                    name = data.name,
                    quantity = data.quantity,
                    meta = data.meta,
                    slot = data.toSlot,
                    data = iData,
                    itemHash = self:generateUniqueItemHash()
                }
                self:OnItemAdded(self.items[#self.items])
                return ScriptShared:createRet({ success = true, response = "item_added_on_new_slot", item = self.items[#self.items] })
            end
        else
            local onSlotItem <const> = self:getItemBy({ slot = data.toSlot })
            if onSlotItem then
                return ScriptShared:createRet({ success = false, response = "item_can_not_stack"  })
            end

            self.items[#self.items+1] = {
                name = data.name,
                quantity = data.quantity,
                meta = data.meta,
                slot = data.toSlot,
                data = iData,
                itemHash = self:generateUniqueItemHash()
            }
            self:OnItemAdded(self.items[#self.items])
            return ScriptShared:createRet({ success = true, response = "item_added_on_new_slot", item = self.items[#self.items] })            
        end
    else
        if iData.stackable then
            local existItem <const> = self:getItemBy({ name = data.name })
            if existItem then
                existItem.quantity += data.quantity

                self:OnItemUpdated(existItem)
                return ScriptShared:createRet({ success = true, response = "added_item_on_stack", item = existItem })
            else
                local newEmptySlot = self:getEmptySlot()
                if type(newEmptySlot) ~= "number" then
                    return ScriptShared:createRet({ success = false, response = "no_empty_slot_found" })
                end

                self.items[#self.items+1] = {
                    name = data.name,
                    quantity = data.quantity,
                    meta = data.meta,
                    slot = newEmptySlot,
                    data = iData,
                    itemHash = self:generateUniqueItemHash()
                }

                self:OnItemAdded(self.items[#self.items])
                return ScriptShared:createRet({ success = true, response = "item_added_on_new_slot", item = self.items[#self.items] })
            end
        else
            for i = 1, data.quantity do
                local newEmptySlot = self:getEmptySlot()
                if type(newEmptySlot) ~= "number" then
                    return ScriptShared:createRet({ success = false, response = "no_empty_slot_found" })
                end
                self.items[#self.items+1] = {
                    name = data.name,
                    quantity = 1,
                    meta = data.meta,
                    slot = newEmptySlot,
                    data = iData,
                    itemHash = self:generateUniqueItemHash()
                }
                self:OnItemAdded(self.items[#self.items])
            end
            return ScriptShared:createRet({ success = true, response = "item_added_on_new_slot", item = self.items[#self.items] })
        end
    end
end

--- Remove item(s) with the findBy options.
---@param quantity number | nil
---@param findBy findByOptions
function Module:removeItemBy(quantity, findBy)
    if type(quantity) ~= "number" then quantity = 1 end

    local ret = ScriptShared:createRet({ success = false, response = "failed_to_remove" })

    for i = 1, #self.items, 1 do
        local v = self.items[i]
        local checker <const> = self:findByChecker(v, findBy)
        if checker then
            local no_ref <const> = json.decode(json.encode(v))

            if v.data.stackable then
                if v.quantity >= quantity then
                    v.quantity -= quantity

                    if v.quantity < 1 then
                        table.remove(self.items, i)
                        ret.success = true
                        ret.response = "removed"

                        self:OnItemRemoved(no_ref)

                        break
                    else
                        ret.success = true
                        ret.response = "updated_quantity"

                        self:OnItemUpdated(v)

                        break
                    end
               end
            else
                table.remove(self.items, i)

                ret.success = true
                ret.response = "removed"

                self:OnItemRemoved(no_ref)

                break
            end
        end
    end

    return ScriptShared:createRet(ret)
end

---@param item InventoryItem
function Module:OnItemRemoved(item)
    for observerSource in pairs(self.observers) do
        TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", observerSource, {
            event = "REMOVE_INVENTORY_ITEM",
            uniqueID = self.uniqueID,
            itemHash = item.itemHash
        })
    end
    TriggerEvent("inventory:onItemRemoved", self.uniqueID, item)
end

---@param item InventoryItem
function Module:OnItemUpdated(item)
    for observerSource in pairs(self.observers) do
        TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", observerSource, {
            event = "UPDATE_INVENTORY_ITEM",
            uniqueID = self.uniqueID,
            itemHash = item.itemHash,
            item = item
        })
    end
end

---@param item InventoryItem
function Module:OnItemAdded(item)
    for observerSource in pairs(self.observers) do
        TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", observerSource, {
            event = "UPDATE_INVENTORY_ITEM",
            uniqueID = self.uniqueID,
            itemHash = item.itemHash,
            item = item
        })
    end
    TriggerEvent("inventory:onItemAdded", self.uniqueID, item)
end

--- Only checks the inventory weight is okey to add the item or not.
---@param name string
---@param quantity number
function Module:canCarryWeight(name, quantity)
    local iData <const> = ScriptShared.Items:Get(name)
    if not iData then return end

    if self:getWeight() + (iData.weight * quantity) > self.maxWeight then return end

    return true
end

function Module:canCarryItem(name, quantity)
    if not self:canCarryWeight(name, quantity) then return false end
    
    local slot = self:getEmptySlot()
    if type(slot) == "number" then
        return true
    end

    return false
end


function isWeapon(name)
    local iData <const> = ScriptShared.Items:Get(name)

    if (iData) then
        local itemName = name
        if itemName:sub(1, 7) == "weapon_" then
            return true
        end
        return false
    end

    return false
end

function Module:hasWeapon(name)
    local iData <const> = ScriptShared.Items:Get(name)
    local locateWeapon = false

    if (iData) then
        for i = #self.items, 1, -1 do
            local v <const> = self.items[i]

            if (v) then
                local itemName = v.name
                if (itemName:sub(1, 7) == "weapon_") then
                    if (itemName == name) then
                        locateWeapon = true
                    end
                end
            end
        end
        return locateWeapon
    end
    return locateWeapon
end

---@param anotherInventory BaseInventory
function Module:isSame(anotherInventory)
    return self.uniqueID == anotherInventory.uniqueID
end

-- Deletes all items from the inventory, even the non deletable items.
function Module:clear()
    for i = #self.items, 1, -1 do
        local v <const> = self.items[i]
        if v then
            local itemName = v.name
            if itemName:sub(1, 4) ~= "cash" and itemName:sub(1, 9) ~= "dirtycash" then
                self:removeItemBy(v.quantity, { itemHash = v.itemHash })
            end
        end
    end
    return true
end

function Module:clearWeapons(perma)
    for i = #self.items, 1, -1 do
        local v <const> = self.items[i]
        if v then
            local itemName = v.name
            if itemName:sub(1, 7) == "weapon_" then
                if (not perma and ESX.IsWeaponPermanent(itemName)) then
                    print(perma, ESX.IsWeaponPermanent(itemName))
                    return
                end

                self:removeItemBy(v.quantity, { itemHash = v.itemHash })
            end
        end
    end
    return true
end

function Module:clearItems()
    for i = #self.items, 1, -1 do
        local v <const> = self.items[i]
        if v then
            local itemName = v.name
            if itemName:sub(1, 7) ~= "weapon_" and itemName:sub(1, 4) ~= "cash" and itemName:sub(1, 9) ~= "dirtycash" then
                self:removeItemBy(v.quantity, { itemHash = v.itemHash })
            end
        end
    end
    return true
end

-- Deletes the inventory from the server cache.
function Module:destroy()
    if ScriptServer.Managers.Inventory.Inventories[self.uniqueID] then
        ScriptServer.Managers.Inventory.Inventories[self.uniqueID] = nil
    end
end

function Module:delete()
    if ScriptServer.Managers.Inventory.Inventories[self.uniqueID] then
        ScriptServer.Managers.Inventory.Inventories[self.uniqueID] = nil
    end

    exports["oxmysql"]:query_async("DELETE FROM inventory_4_items WHERE uniqueID = ?", {
        self.uniqueID
    })
end

---@async
function Module:save()
    ---@type InventoryItem[]
    local format = {}
    for i = 1, #self.items, 1 do
        local v = self.items[i]
        format[#format+1] = {
            name = v.name,
            quantity = v.quantity,
            slot = v.slot,
            meta = v.meta,
            itemHash = v.itemHash
        }
    end

    exports.oxmysql:query_async([[
        INSERT INTO inventory_4_items (uniqueID, type, items)
        VALUES (@uniqueID, @type, @items)
        ON DUPLICATE KEY UPDATE
        uniqueID = @uniqueID,
        type = @type,
        items = @items
    ]], {
        ["@uniqueID"] = self.uniqueID,
        ["@type"] = self.type,
        ["@items"] = json.encode(format)
    })
end