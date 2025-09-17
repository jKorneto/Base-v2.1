RegisterServerEvent("iZeyy:ShopIllegal:Buy", function(item, label, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    local correctItem = false
    for k, v in pairs(Config["ShopIllegal"]["Items"]) do
        if item == v.name and label == v.label and price == v.price then
            correctItem = true
            break
        end
    end

    if (not correctItem) then
        return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
    end

    local player = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(player)
    local shopIllegalPos = Config["ShopIllegal"]["PedPos"]
    local distance = #(playerCoords - shopIllegalPos)

    if (distance < 15) then

        if (correctItem) then

            local playerMoney = xPlayer.getAccount("dirtycash").money
            if (playerMoney < price) then
                return xPlayer.showNotification("Vous n'avez pas assez d'argent sale sur vous")
            end

            if (playerMoney >= price) then
                xPlayer.removeAccountMoney("dirtycash", price)
                xPlayer.addInventoryItem(item, 1)
                xPlayer.showNotification(("Vous avez reçu %s"):format(label))
            end
        end

    end
end)