RegisterNetEvent('OneLife:Inventory:setSecondInventory')
AddEventHandler('OneLife:Inventory:setSecondInventory', function(inventoryItems, invName, weight, maxWeight)
    MOD_inventory.class:setSecondInventory(inventoryItems, invName, weight, maxWeight)
end)