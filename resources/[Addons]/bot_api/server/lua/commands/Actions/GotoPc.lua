function _bot_api:GotoPc(id, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
        TriggerClientEvent('Console:Tppc', xPlayer.source)
        xPlayer.showNotification('Vous avez été téléporter au PC !')

        cb("Le joueur "..xPlayer.name.." a bien été téléporté au PC !")
    else
        cb("Le joueur n'est pas connecté !")
    end
end