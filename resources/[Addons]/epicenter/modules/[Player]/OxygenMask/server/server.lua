ESX.RegisterServerCallback('server:hasOxygenMask', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local oxygenMaskItem = xPlayer.getInventoryItem('oxygen_mask')

    if oxygenMaskItem and oxygenMaskItem.quantity > 0 then
        cb(true)
    else
        cb(false)
    end
end)
