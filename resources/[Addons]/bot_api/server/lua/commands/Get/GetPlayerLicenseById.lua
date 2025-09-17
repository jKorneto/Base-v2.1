function _bot_api:GetPlayerLicenseById(id, cb)
    local xPlayer = ESX.GetPlayerFromId(id)
    local identifier = xPlayer.identifier

    if xPlayer ~= nil then
        cb("La license du joueur avec l'id "..xPlayer.source.." est : "..identifier)
    else
        cb("Le joueur n'est pas connecter !")
    end
end