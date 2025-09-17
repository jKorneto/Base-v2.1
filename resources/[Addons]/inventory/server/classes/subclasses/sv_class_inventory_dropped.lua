---@class DroppedInventory:BaseInventory
---@field originX number
---@field originY number
---@field originZ number
---@field objects table<string, number> Stored with itemHash -> ObjectHandle
---@field expires number
local Module <const> = setmetatable({}, { __index = ScriptServer.Classes.BaseInventory })

ScriptServer.Classes.DroppedInventory = Module

---@class DroppedInventoryClassCreateInterface:BaseInventoryClassCreateInterface
---@field originX number
---@field originY number
---@field originZ number
---@field expires number

---@param data DroppedInventoryClassCreateInterface
Module.new = function(data)
    data.type = "dropped_grid"

    local self = setmetatable(
        ScriptServer.Classes.BaseInventory.new(data),
        { __index = Module }
    ) --[[@as DroppedInventory]]

    self.originX = data.originX
    self.originY = data.originY
    self.originZ = data.originZ
    self.objects = {}
    self.expires = data.expires

    local isExpired = self:checkExpired()
    if isExpired then return end

    for i = 1, #self.items do
        local v = self.items[i]
        self:createObjectIfNotExist(v)
    end

    ScriptServer.Managers.Dropped.Grids[self.uniqueID] = self

    return self
end

function Module:checkExpired()
    if os.time() > self.expires then
        self:destroyGrid()
        return true
    end
end

function Module:destroyGrid()
    exports["oxmysql"]:query_async("DELETE FROM inventory_4_items WHERE uniqueID = ?", {
        self.uniqueID
    })

    self:triggerObservers(function(source)
        self:close(source)
    end)

    ScriptServer.Managers.Dropped.Grids[self.uniqueID] = nil
end

function Module:open(source)
    if self:hasObserver(source) then return end

    self:addObserver(source)

    TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", source, {
        event = "ADD_OPENED_INVENTORY",
        uniqueID = self.uniqueID,
        items = self.items,
        maxWeight = self.maxWeight,
        inventoryName = self.inventoryName,
        slotsAmount = self.slotsAmount
    })
end

function Module:close(source)
    if not self:hasObserver(source) then return end

    self:removeObserver(source)

    TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", source, {
        event = "REMOVE_OPENED_INVENTORY",
        uniqueID = self.uniqueID
    })
end

---@param item InventoryItem
function Module:OnItemAdded(item)
    self.__index.OnItemAdded(self, item)

    self:createObjectIfNotExist(item)
end

---@param item InventoryItem
function Module:OnItemUpdated(item)
    self.__index.OnItemUpdated(self, item)

    self:createObjectIfNotExist(item)
end

---@param item InventoryItem
function Module:OnItemRemoved(item)
    self.__index.OnItemRemoved(self, item)

    self:removeObjectIfExist(item)

    if #self.items < 1 then
        self:destroyGrid()
    end
end

---@class AddDropInterface:AddItemInterface
---@field coordX number
---@field coordY number
---@field coordZ number

---@param data AddDropInterface
function Module:addItem(data)
    local addedResult = self.__index.addItem(self, data)

    if addedResult.success then
        addedResult.item.coordX = data.coordX
        addedResult.item.coordY = data.coordY
        addedResult.item.coordZ = data.coordZ
        self:OnItemUpdated(addedResult.item)
    end

    return addedResult
end

---@param item InventoryItem
function Module:createObjectIfNotExist(item)
    -- Create object if not exist.
    if not self.objects[item.itemHash] then
        if type(item.coordX) == "number" and type(item.coordY) == "number" and type(item.coordZ) == "number" then
            local iData = ScriptShared.Items:Get(item.name)

            local dropModel = CONFIG.DROPPED_ITEMS.DEFAULT_DROPPED_MODEL
            if type(iData.droppedModel) == "number" then
                dropModel = iData.droppedModel
            end

            local obj = CreateObjectNoOffset(
                dropModel,
                item.coordX,
                item.coordY,
                item.coordZ,
                true,
                true,
                true
            )
            while not DoesEntityExist(obj) do
                Wait(10)
            end

            Entity(obj).state.dropped_item = true

            self.objects[item.itemHash] = obj
        end
    end
end

---@param item InventoryItem
function Module:removeObjectIfExist(item)
    if self.objects[item.itemHash] and DoesEntityExist(self.objects[item.itemHash]) then
        DeleteEntity(self.objects[item.itemHash])
        self.objects[item.itemHash] = nil
    end
end

---@async
function Module:save()
    if #self.items < 1 then return end

    ---@type InventoryItem[]
    local format = {}
    for i = 1, #self.items, 1 do
        local v = self.items[i]
        format[#format + 1] = {
            name = v.name,
            quantity = v.quantity,
            slot = v.slot,
            meta = v.meta,
            itemHash = v.itemHash,
            coordX = v.coordX,
            coordY = v.coordY,
            coordZ = v.coordZ
        }
    end

    exports.oxmysql:query_async([[
        INSERT INTO inventory_4_items (uniqueID, type, originX, originY, originZ, expires, items)
        VALUES (@uniqueID, @type, @originX, @originY, @originZ, @expires, @items)
        ON DUPLICATE KEY UPDATE
        uniqueID = @uniqueID,
        type = @type,
        originX = @originX,
        originY = @originY,
        originZ = @originZ,
        expires = @expires,
        items = @items
    ]], {
        ["@uniqueID"] = self.uniqueID,
        ["@type"] = self.type,
        ["@originX"] = self.originX,
        ["@originY"] = self.originY,
        ["@originZ"] = self.originZ,
        ["@expires"] = self.expires,
        ["@items"] = json.encode(format)
    })
end
