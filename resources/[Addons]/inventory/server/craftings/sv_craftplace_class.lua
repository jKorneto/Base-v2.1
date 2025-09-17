---@class CraftingPlaceClass:CraftingPlaceConstructor
---@field blips API_Server_BlipBase[]
---@field actionshapes API_Server_ActionshapeBase[]
---@field peds API_Server_PedBase[]
local Module <const> = {}
Module.__index = Module

ScriptServer.Classes.CraftingPlace = Module

---@class CraftingPlaceConstructor
---@field craftPlaceId number
---@field craftPlaceName string
---@field items CraftItem[]

---@param id number
---@param allData CraftingPlaceStaticData
Module.new = function(id, allData)
    local self = setmetatable({}, Module)

    self.craftPlaceName = allData.craftPlaceName
    self.craftPlaceId = id
    self.items = {}

    for i = 1, #allData.items do
        local v = allData.items[i]
        local iData = ScriptShared.Items:Get(v.name)
        if iData then
            ---@type CraftItem
            local newCraftingItem = {
                data = iData,
                meta = type(v.meta) == "table" and v.meta or type(iData.defaultMeta) == "table" and iData.defaultMeta or
                    {},
                name = v.name,
                quantity = v.quantity,
                ingredients = {}
            }

            for j = 1, #v.ingredients do
                local ingredient = v.ingredients[j]
                local ingredientItemData = ScriptShared.Items:Get(ingredient.name)
                if ingredientItemData then
                    newCraftingItem.ingredients[#newCraftingItem.ingredients + 1] = {
                        name = ingredient.name,
                        quantity = ingredient.quantity,
                        label = ingredientItemData.label
                    }
                end
            end

            self.items[#self.items + 1] = newCraftingItem
        end
    end

    ScriptServer.Managers.CraftPlaces.CraftPlaces[self.craftPlaceId] = self

    return self
end

function Module:OpenCrafting(source)
    TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", source, {
        event = "OPEN_CRAFTING",
        items = self.items,
        craftPlaceId = self.craftPlaceId,
        craftPlaceName = self.craftPlaceName
    })
end

---@param slotIndex number
function Module:GetCraftItemOnSlot(slotIndex)
    return self.items[slotIndex] or nil
end

for k, v in pairs(ScriptShared.CraftPlaces) do
    ScriptServer.Classes.CraftingPlace.new(k, v)
end
