function _bot_api:PlayerSkin(id, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
		TriggerClientEvent('esx_skin:openSaveableMenu', id)

        cb("Le joueur " ..xPlayer.name.. " a bien été skin !")
    else
        cb("Le joueurs n'est pas connecté !")
    end
end