RegisterNetEvent('OneLife:Inventory:InvMoveClothesToMain')
AddEventHandler('OneLife:Inventory:InvMoveClothesToMain', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (data.inventoryType == 'main') then
        MOD_inventory.InventoryCache.player[xPlayer.identifier]:moveClothesToInv(data.index, data.droppedTo, data.count)
    elseif (data.inventoryType == 'second') then

    end
end)