ESX.RegisterUsableItem('radio', function(source)
    TriggerClientEvent('OpenFuckingRadio', source)
end)

RegisterNetEvent('iZeyy:PlayerHaveRadio')
AddEventHandler('iZeyy:PlayerHaveRadio', function()

    local xPlayer = ESX.GetPlayerFromId(source)
    local Items = xPlayer.getInventoryItem('radio')

    if Items then
        TriggerClientEvent("RadioReadyGo", source, true)
    else
       TriggerClientEvent("RadioReadyGo", source, false)
    end

end)

RegisterNetEvent("iZeyy:radio:requestOpen", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local hasItem = xPlayer.getInventoryItem("radio")
        local job = xPlayer.getJob().name

        if (hasItem or job == "police" or job == "ambulance") then
            TriggerClientEvent('iZeyy:radio:receiveOpen', xPlayer.source)
        else
            xPlayer.showNotification("Vous n'avez pas de radio sur vous")
        end
    end
end)