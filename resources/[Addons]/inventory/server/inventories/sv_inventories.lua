local Module <const> = {}
---@type { [string]: BaseInventory | PlayerInventory }
Module.Inventories = {}

ScriptServer.Managers.Inventory = Module

function Module:SaveInventories()
    for k, v in pairs(self.Inventories) do
        v:save()
    end
end

--- Returns an inventory with the specified uniqueID or source.
---@param data { uniqueID?: string; source?:number; }
---@return PlayerInventory | BaseInventory | StashInventory | GloveboxInventory | TrunkInventory | nil
function Module:GetInventory(data)
    if type(data.uniqueID) == "string" then
        return type(self.Inventories[data.uniqueID]) == "table" and self.Inventories[data.uniqueID] or nil
    end

    if type(data.source) == "number" then
        local player <const> = ESX.GetPlayerFromId(data.source)
        if not player then return end

        local identifier <const> = player:getIdentifier()
        return type(self.Inventories[identifier]) == "table" and self.Inventories[identifier] or nil
    end
end
