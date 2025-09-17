RegisterNetEvent('OneLife:Player:onRevive')
AddEventHandler('OneLife:Player:onRevive', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    TriggerEvent("OneLife:Player:playerRevived", xPlayer.source)
end)