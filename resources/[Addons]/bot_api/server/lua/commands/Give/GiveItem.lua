function _bot_api:GiveItem(id, item, count, cb)
    local xPlayer = ESX.GetPlayerFromId(id)
    local identifier = xPlayer.identifier

    if xPlayer ~= nil then
        xPlayer.addInventoryItem(item, tonumber(count), nil, true)

        xPlayer.showNotification("Vous avez reçu "..item.." x"..count.." !")

        cb("Le joueur "..xPlayer.name.." a bien reçu "..item.." x"..count.." !")
    else
        cb("Le joueur n'est pas connecter !")
    end
end