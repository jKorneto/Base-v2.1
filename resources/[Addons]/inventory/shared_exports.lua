--- Export function to register an item data from another resource.
---@param name string Example: 'gold'
---@param d RegisteredItemData
exports("registerItem", function(name, d)
    ScriptShared.Items:Add(name, d)
end)

--- Export function to create a shop from another resource.
---@param id string Example: 'General'
---@param shopData ShopStaticData
exports("createShop", function(id, shopData)
    ScriptShared.Shops[id] = shopData

    -- If its server create the shop.
    if IsDuplicityVersion() then
        ScriptServer.Classes.Shop.new(id, shopData)
    end
end)

--- Export function to create a crafting place location from another resource.
---@param craftPlaceData CraftingPlaceStaticData
exports("createCraftPlace", function(craftPlaceData)
    ScriptShared.CraftPlaces[#ScriptShared.CraftPlaces + 1] = craftPlaceData

    if IsDuplicityVersion() then
        ScriptServer.Classes.CraftingPlace.new(#ScriptShared.CraftPlaces, craftPlaceData)
    end
end)
