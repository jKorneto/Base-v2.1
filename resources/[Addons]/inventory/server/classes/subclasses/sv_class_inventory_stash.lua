---@class StashInventory:BaseInventory
---@field isPublic? boolean
---@field ownerLicense? string
---@field groups? { [string]: number }
---@field isPermanent? boolean
local Module <const> = setmetatable({}, { __index = ScriptServer.Classes.BaseInventory })

ScriptServer.Classes.StashInventory = Module

---@class StashInventoryClassCreateInterface:BaseInventoryClassCreateInterface
---@field isPublic? boolean
---@field ownerLicense? string
---@field groups? { [string]: number }
---@field isPermanent? boolean

---@param data StashInventoryClassCreateInterface
Module.new = function(data)
    data.type = "stash"

    local self = setmetatable(
        ScriptServer.Classes.BaseInventory.new(data),
        { __index = Module }
    )

    self.isPublic = data.isPublic
    self.ownerLicense = data.ownerLicense
    self.groups = data.groups
    self.isPermanent = data.isPermanent

    return self --[[@as StashInventory]]
end

function Module:hasPermission(source, job)
    if self.isPublic then return true end

    local player <const> = ESX.GetPlayerFromId(source)
    local job = job or "job"
    if not player then return end

    if type(self.ownerLicense) == "string" then
        return player:getIdentifier() == self.ownerLicense
    end

    if type(self.groups) == "table" then
        local playerFaction = player[job].name
        local playerFactionGrade = player[job].grade

        for k, v in pairs(self.groups) do
            if (k == "all" and v == "all") then
                return true
            end

            if playerFaction == k and playerFactionGrade >= v then
                return true
            end
        end
    end

    return false
end

function Module:open(source, job)
    if self:hasObserver(source) then return end
    if not self:hasPermission(source, job) then return end

    self:addObserver(source)

    TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", source, {
        event = "ADD_OPENED_INVENTORY",
        uniqueID = self.uniqueID,
        items = self.items,
        maxWeight = self.maxWeight,
        inventoryName = self.inventoryName,
        slotsAmount = self.slotsAmount
    }, true)
end

function Module:close(source)
    if not self:hasObserver(source) then return end

    self:removeObserver(source)

    TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", source, {
        event = "REMOVE_OPENED_INVENTORY",
        uniqueID = self.uniqueID
    })
end

function Module:save()
    if not self.isPermanent then return end

    return self.__index.save(self)
end