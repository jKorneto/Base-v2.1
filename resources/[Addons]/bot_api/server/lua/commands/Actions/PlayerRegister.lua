function _bot_api:PlayerRegister(id, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
        TriggerEvent('register:skin:bot', xPlayer)

        cb("Le joueur " ..xPlayer.name.. " a bien été register !")
    else
        cb("Le joueurs n'est pas connecté !")
    end
end