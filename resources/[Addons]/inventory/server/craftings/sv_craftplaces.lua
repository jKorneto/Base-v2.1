local Module <const> = {}
---@type { [string]: CraftingPlaceClass }
Module.CraftPlaces = {}

ScriptServer.Managers.CraftPlaces = Module

function Module:GetCraftingPlace(craftingPlaceId)
    return self.CraftPlaces[craftingPlaceId] or nil
end
