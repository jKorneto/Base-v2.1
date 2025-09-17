---@class ChestInventory:BaseInventory
---@field safeCoords vector3
---@field safeHandle API_Server_ObjectBase | nil
local Module <const> = setmetatable({}, { __index = ScriptServer.Classes.BaseInventory })

ScriptServer.Classes.ChestInventory = Module

---@class ChestInventoryClassCreateInterface:BaseInventoryClassCreateInterface
---@field safeCoords vector3

---@param data ChestInventoryClassCreateInterface
Module.new = function(data)
    data.type = "chest"

    local self = setmetatable(
        ScriptServer.Classes.BaseInventory.new(data),
        { __index = Module }
    )

    self.safeCoords = data.safeCoords

    return self
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
