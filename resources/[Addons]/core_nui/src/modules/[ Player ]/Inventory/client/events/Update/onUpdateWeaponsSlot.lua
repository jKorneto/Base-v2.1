RegisterNetEvent('OneLife:Inventory:UpdateWeaponsSlot')
AddEventHandler('OneLife:Inventory:UpdateWeaponsSlot', function(InvData, WeaponsData, weight, maxWeight)
    MOD_inventory.class:updateWeaponsSlot(InvData, WeaponsData, weight, maxWeight)
end)