ScriptClient.Player.Inventory = {}
---@type InventoryItem[]
ScriptClient.Player.Inventory.Items = {}

function ScriptClient.Player.Inventory:GetWeight()
    local weight = 0.0

    for i = 1, #self.Items, 1 do
        local v = self.Items[i]
        weight = weight + (v.data.stackable and (v.data.weight * v.quantity) or v.data.weight)
    end

    return math.floor(weight * 10 ^ 2 + 0.5) / 10 ^ 2
end

function ScriptClient.Player.Inventory:GetMaxWeight()
    return self.MaxWeight
end

function showNotification(msg, flash, saveToBrief, hudColorIndex, title, subject, icon)
    if title == nil then title = "OneLife" end
    if subject == nil then subject = "Notification" end
    if icon == nil then icon = "message" end

    exports.notify:MontreToiBasique(msg, nil, nil, true, nil, title, subject, icon);
end 

---@param item InventoryItem
---@param findBy findByOptions
local function FindByChecker(item, findBy)
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
function ScriptClient.Player.Inventory:GetItemBy(findBy)
    for i = 1, #self.Items, 1 do
        local v = self.Items[i]
        if FindByChecker(v, findBy) then
            return v
        end
    end
end

--- Returns more items. (found by the match)
---@param findBy findByOptions
function ScriptClient.Player.Inventory:GetItemsBy(findBy)
    ---@type InventoryItem[]
    local items <const> = {}
    local found = 0

    for i = 1, #self.Items, 1 do
        local v = self.Items[i]
        if FindByChecker(v, findBy) then
            items[#items+1] = v
            found = found + 1
        end
    end

    return items, found
end

--- Returns all of the quantity if the arguments are met.
---@param findBy findByOptions
function ScriptClient.Player.Inventory:GetItemQuantityBy(findBy)
    local quantity = 0

    for i = 1, #self.Items, 1 do
        local v = self.Items[i]
        if FindByChecker(v, findBy) then
            quantity = quantity + v.quantity
        end
    end

    return quantity
end

---@param items InventoryItem[]
RegisterNetEvent("inventory:setPlayerInventoryItems", function(items)
    ScriptClient.Player.Inventory.Items = items
end)
---@param item InventoryItem
RegisterNetEvent("inventory:onPlayerItemUpdated", function(item)
    local found = false
    for i = 1, #ScriptClient.Player.Inventory.Items do
        local v = ScriptClient.Player.Inventory.Items[i]
        if v.itemHash == item.itemHash then
            ScriptClient.Player.Inventory.Items[i] = item
            found = true
            break
        end
    end

    if not found then
        ScriptClient.Player.Inventory.Items[#ScriptClient.Player.Inventory.Items+1] = item
    end
end)
---@param item InventoryItem
RegisterNetEvent("inventory:onPlayerItemAdded", function(item)
    ScriptClient.Player.Inventory.Items[#ScriptClient.Player.Inventory.Items+1] = item
end)
---@param item InventoryItem
RegisterNetEvent("inventory:onPlayerItemRemoved", function(item)
    for i = 1, #ScriptClient.Player.Inventory.Items do
        local v = ScriptClient.Player.Inventory.Items[i]
        if v.itemHash == item.itemHash then
            table.remove(ScriptClient.Player.Inventory.Items, i)
            break
        end
    end
end)