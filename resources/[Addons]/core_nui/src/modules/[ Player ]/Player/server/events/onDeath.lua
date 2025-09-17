RegisterNetEvent("OneLife:Player:onDeath")
AddEventHandler("OneLife:Player:onDeath", function(deathData)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer)) then
        TriggerEvent("OneLife:Player:playerDied", xPlayer.source)
    end
end)