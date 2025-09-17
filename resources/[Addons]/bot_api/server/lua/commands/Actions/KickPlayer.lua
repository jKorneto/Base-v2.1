function _bot_api:KickPlayer(id, reason, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
        DropPlayer(id, "Vous avez été kick.\nRaison : "..reason)

        cb("Le joueur "..xPlayer.name.." a bien été kick du server pour `"..reason.."` .")
    else
        cb("Le joueur n'est pas connecté !")
    end
end