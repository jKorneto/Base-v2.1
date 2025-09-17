function _bot_api:PlayerRevive(id, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
        --TriggerClientEvent("fowlmas:player:consoleRevive", xPlayer.source)
        --TriggerClientEvent("fowlmas:player:DeadMenu", xPlayer.source, false)
        xPlayer.showNotification('Vous avez été revive !')

        cb("Le joueur " ..xPlayer.name.. " a bien été revive !")
    else
        cb("Le joueurs n'est pas connecté !")
    end
end