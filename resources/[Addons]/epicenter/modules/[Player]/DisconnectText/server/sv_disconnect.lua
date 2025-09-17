AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local pCoords = GetEntityCoords(GetPlayerPed(source))
    
    TriggerClientEvent("utils:playerDisconnect", -1, source, {res = reason, date = xPlayer.name, coords = pCoords})
end)
