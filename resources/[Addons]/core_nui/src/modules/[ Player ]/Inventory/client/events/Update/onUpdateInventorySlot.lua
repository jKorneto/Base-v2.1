RegisterNetEvent('OneLife:Inventory:UpdatePlayerSlot')
AddEventHandler('OneLife:Inventory:UpdatePlayerSlot', function(fromData, toData, weight, maxWeight)
    MOD_inventory.class:updateInventorySlot(fromData, toData, weight, maxWeight)
end)