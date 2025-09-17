function GiveItemToAllPlayers(itemName, quantity)
    local players = ESX.GetPlayers()
    for _, playerId in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            xPlayer.addInventoryItem(itemName, quantity)
        end
    end
    Shared.Log:Success(("%d joueurs ont reçu %dx %s"):format(#players, quantity, itemName))
end

RegisterCommand("giveitemall", function(source, args, rawCommand)
    if (source == 0) then
        local itemName = args[1]
        local quantity = tonumber(args[2])

        if (itemName and quantity) then
            GiveItemToAllPlayers(itemName, quantity)
        else
            Shared.Log:Info("/giveitemall [name] [quantity]")
        end
    end
end, false)