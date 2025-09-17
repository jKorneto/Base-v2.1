exports("GetWeight", function()
    return ScriptClient.Player.Inventory:GetWeight()
end)
exports("GetMaxWeight", function()
    return CONFIG.PLAYER_INVENTORY_DEFAULTS.MAX_WEIGHT
end)
exports("GetItemBy", function(findBy)
    return ScriptClient.Player.Inventory:GetItemBy(findBy)
end)
exports("GetItemsBy", function(findBy)
    return ScriptClient.Player.Inventory:GetItemsBy(findBy)
end)
exports("GetInventoryItems", function()
    return ScriptClient.Player.Inventory.Items
end)
exports("GetItemQuantityBy", function(findBy)
    return ScriptClient.Player.Inventory:GetItemQuantityBy(findBy)
end)
exports("OpenStash", function(uniqueID)
    TriggerServerEvent("inventory:OPEN_STASH", uniqueID)
end)
exports("GetRegisteredItems", function()
    return ScriptShared.Items.Registered
end)
exports("GetRegisteredItem", function(itemName)
    return ScriptShared.Items:Get(itemName)
end)
exports("openInventory", function()
    SEND_NUI_MESSAGE({
        event = "SET_INTERFACE_OPEN",
        state = true
    })
end)
exports("closeInventory", function()
    SEND_NUI_MESSAGE({
        event = "SET_INTERFACE_OPEN",
        state = false
    })
end)
