function _bot_api:PlayerHeal(id, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
		TriggerClientEvent('ambulance:heal', xPlayer.source, 'big')
		TriggerClientEvent('fowlmas:status:add', xPlayer.source, 'thirst', 1000000)
		TriggerClientEvent('fowlmas:status:add', xPlayer.source, 'hunger', 1000000)
        xPlayer.showNotification('Vous avez été heal !')

        cb("Le joueur " ..xPlayer.name.. " a bien été heal !")
    else
        cb("Le joueurs n'est pas connecté !")
    end
end