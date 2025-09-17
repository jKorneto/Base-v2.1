RegisterNetEvent('OneLife:Inventory:ClosePlayerInventory')
AddEventHandler('OneLife:Inventory:ClosePlayerInventory', function()
    MOD_inventory.class:closeInventory()
end)

exports("CloseInventory", function()
    MOD_inventory.class:closeInventory()
end)