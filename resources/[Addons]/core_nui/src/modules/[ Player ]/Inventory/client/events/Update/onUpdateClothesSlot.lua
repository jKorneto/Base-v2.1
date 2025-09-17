RegisterNetEvent('OneLife:Inventory:UpdateClothesSlot')
AddEventHandler('OneLife:Inventory:UpdateClothesSlot', function(InvData, ClothesData, weight, maxWeight)
    MOD_inventory.class:updateClothesSlot(InvData, ClothesData, weight, maxWeight)
end)