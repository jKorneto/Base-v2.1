RegisterNetEvent('OneLife:Inventory:UpdateWeaponsInsideSlot')
AddEventHandler('OneLife:Inventory:UpdateWeaponsInsideSlot', function(FromData, ToData, weight, maxWeight)
    MOD_inventory.class:updateWeaponsInsideSlot(FromData, ToData, weight, maxWeight)
end)