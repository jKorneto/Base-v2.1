function _bot_api:SendCoins(id, montant, cb)
    local xPlayer = ESX.GetPlayerFromId(id)
    local identifier = xPlayer.identifier

    if xPlayer ~= nil then
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            
            MySQL.Sync.execute("UPDATE users SET coins = coins + @montant WHERE identifier = @identifier", {
                ["@montant"] = montant,
                ["@identifier"] = after
            })

            xPlayer.showNotification('Vous avez reçu ~r~'..montant..' OneLifeCoins')

            cb('Montant donné : '..montant..' Coins\nJoueur : '..xPlayer.name)
        else
            cb("Le joueur n'a pas de compte FiveM lié")
        end
    else
        cb("Le joueur n'est pas connecté !")
    end
end
