Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.requestHistory, function(xPlayer)
    if (type(xPlayer) == "table") then
        local history = Engine.Shop:getHistory(xPlayer.identifier)
        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveHistory, history or {})
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.requestCoins, function(xPlayer)
    if (type(xPlayer) == "table") then
        local coins = Engine.Shop:getCoins(xPlayer.identifier)
        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveCoins, coins)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.changeBucket, function(xPlayer, default)
    if (type(xPlayer) == "table") then
        exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, not default and (xPlayer.source + 1) or 0)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.setLastPosition, function(xPlayer, lastPosition)
    if (type(xPlayer) == "table" and type(lastPosition) == "vector3") then
        Engine.Shop:setLastPosition(xPlayer.identifier, lastPosition)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.deleteLastPosition, function(xPlayer)
    if (type(xPlayer) == "table") then
        Engine.Shop:deleteLastPosition(xPlayer.identifier)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.buyVehicle, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        Engine.Shop:buyVehicle(xPlayer, index)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.requestLimitedVehicles, function(xPlayer)
    if (type(xPlayer) == "table") then
        local limitedVehicles = Engine.Shop:getLimitedVehicles()
        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveLimitedVehicles, limitedVehicles or {})
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.buyLimitedVehicle, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        Engine.Shop:buyLimitedVehicle(xPlayer, index)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.addLimitedVehicle, function(xPlayer, model, label, quantity, price)
    if (type(xPlayer) == "table" and type(model) == "string" and type(label) == "string" and type(tonumber(quantity)) == "number" and type(tonumber(price)) == "number") then
        if (xPlayer.getGroup() == "fondateur") then
            Engine.Shop:addLimitedVehicle(model, label, tonumber(quantity), tonumber(price))

            Engine.Discord:SendMessage("ShopAddLimitedCar", 
                string.format("Le joueur %s (***%s***) a ajouté un véhicule limité %s (***%s***)",
                    xPlayer.name,
                    xPlayer.identifier,
                    label,
                    model
                )
            )
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.buyMysteryBox, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        Engine.Shop:buyMysteryBox(xPlayer, index)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.acceptMysteryReward, function(xPlayer, isBuy)
    if (type(xPlayer) == "table") then
        Engine.Shop:acceptMysteryReward(xPlayer, isBuy)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.refundMysteryReward, function(xPlayer)
    if (type(xPlayer) == "table") then
        Engine.Shop:refundMysteryReward(xPlayer)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.buyPackage, function(xPlayer, index, username)
    if (type(xPlayer) == "table" and type(index) == "number") then
        Engine.Shop:buyPackage(xPlayer, index, username)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.buyWeapon, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        Engine.Shop:buyWeapon(xPlayer, index)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Shop.Events.buyExWeapon, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        Engine.Shop:buyExWeapon(xPlayer, index)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Player.Events.PlayerLoaded, function(xPlayer)
    if (type(xPlayer) == "table") then
        local hasPendingCoins, amount = Engine.Shop:hasPendingCoins(xPlayer.getFivemID())

        if (Engine.Shop:createPlayerData(xPlayer)) then
            if (hasPendingCoins) then
                if (Engine.Shop:addCoins(xPlayer, tonumber(amount))) then
                    Shared.Log:Success(string.format("Tebex has added ^4%s^7 coins to player ^4%s^7 (old Pending)", tonumber(amount), xPlayer.name))
                    Engine.Shop:removePendingCoins(xPlayer.getFivemID())

                    Engine.Discord:SendMessage("ShopAddCoins",
                        string.format("Tebex a ajouté **%s** coins au joueur %s (***%s***) (**anciennement en attente**) ",
                            tonumber(amount),
                            xPlayer.name,
                            xPlayer.getFivemID()
                        )
                    )
                end
            end
        end
    end
end)

Server:OnPlayerDropped(function(xPlayer)
    if (type(xPlayer) == "table") then
        local lastPosition = Engine.Shop:getLastPosition(xPlayer.identifier)

        if (lastPosition ~= nil) then
            xPlayer.setLastPosition(vector3(lastPosition.x, lastPosition.y, lastPosition.z));
            Engine.Shop:deleteLastPosition(xPlayer.identifier)
        end

        Engine.Shop:deletePlayerData(xPlayer.identifier)
    end
end)


RegisterCommand("addLimitedVehicle", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer.source ~= 0 and xPlayer.getGroup() == "fondateur") then
        Shared.Events:ToClient(source, Engine["Enums"].Shop.Events.receiveLimitedCommand)
    end
end)

RegisterCommand("addCoins", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.source == 0 or xPlayer.getGroup() == "fondateur") then
            if (Engine.Shop:addCoins(xTarget, tonumber(args[2]))) then
                if (xPlayer.source ~= 0) then
                    Server:showNotification(xPlayer.source, "Vous avez rajouter ~b~%s~s~ coins au joueur %s", false, tonumber(args[2]), xTarget.name)
                else
                    Shared.Log:Success(string.format("You have added ^4%s^7 coins to player ^4%s^7", tonumber(args[2]), xTarget.name))
                end

                Server:showNotification(xTarget.source, "Vous avez reçu ~b~%s~s~ coins de la part de %s", false, tonumber(args[2]), xPlayer.name)

                Engine.Discord:SendMessage("ShopAddCoins",
                    string.format("Le joueur %s (***%s***) a ajouté **%s** coins au joueur %s (***%s***)",
                        xPlayer.name, 
                        xPlayer.identifier,
                        tonumber(args[2]),
                        xTarget.name,
                        xTarget.identifier
                    )
                )
            end
        end
    else
        if (xPlayer.source ~= 0) then
            Server:showNotification(xPlayer.source, "Le joueur n'est pas connecté")
        else
            Shared.Log:Error("This player is not connected")
        end
    end
end)

RegisterCommand("tebex_addCoins", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromFivemID(tostring(args[1]))

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.source == 0) then
            if (Engine.Shop:addCoins(xTarget, tonumber(args[2]))) then
                Shared.Log:Success(string.format("Tebex has added ^4%s^7 coins to player ^4%s^7", tonumber(args[2]), xTarget.name))
                Server:showNotification(xTarget.source, "Vous avez reçu ~b~%s~s~ coins de la part de Tebex", false, tonumber(args[2]))

                Engine.Discord:SendMessage("ShopAddCoins",
                    string.format("Tebex a ajouté **%s** coins au joueur %s (***%s***)",
                        tonumber(args[2]),
                        xTarget.name,
                        xTarget.identifier
                    )
                )
            end
        end
    else
        if (xPlayer.source == 0) then
            if (args[1] ~= nil) then
                Engine.Shop:addPendingCoins(tostring(args[1]), tonumber(args[2]))
                Shared.Log:Success(string.format("Tebex has added ^4%s^7 coins to player ^4%s^7 (Pending)", tonumber(args[2]), tostring(args[1])))

                Engine.Discord:SendMessage("ShopAddCoins",
                    string.format("Tebex a ajouté **%s** coins au joueur (**%s**) (**attente de connexion**)",
                        tonumber(args[2]),
                        tostring(args[1])
                    )
                )
            end
        end
    end
end)

RegisterCommand("removeCoins", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.source == 0 or xPlayer.getGroup() == "fondateur") then
            if (Engine.Shop:removeCoins(xTarget, tonumber(args[2]))) then
                if (xPlayer.source ~= 0) then
                    Server:showNotification(xPlayer.source, "Vous avez retiré ~b~%s~s~ coins au joueur %s", false, tonumber(args[2]), xTarget.name)
                else
                    Shared.Log:Success(string.format("You have removed ^4%s^7 coins from player ^4%s^7", tonumber(args[2]), xTarget.name))
                end

                Server:showNotification(xTarget.source, "Vous avez perdu ~b~%s~s~ coins après la demande de %s", false, tonumber(args[2]), xPlayer.name)

                Engine.Discord:SendMessage("ShopRemoveCoins",
                    string.format("Le joueur %s (***%s***) a retiré **%s** coins au joueur %s (***%s***)",
                        xPlayer.name, 
                        xPlayer.identifier,
                        tonumber(args[2]),
                        xTarget.name,
                        xTarget.identifier
                    )
                )
            end
        end
    end
end)

RegisterNetEvent("izeyy:case:open", function(source, table)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type(xPlayer) == "table" and type(table) == "table" then
        if table.data and table.data.event and table.data.event.param_event then
            local index = table.data.event.param_event.index
            Engine.Shop:openMysteryBox(xPlayer, index)
        end
    end
end)

RegisterCommand("givemysterybox", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        if (xPlayer.source == 0 or xPlayer.getGroup() == "fondateur") then
            local itemName = args[1]
            local itemCount = tonumber(args[2]) or 1

            if not itemName then
                if xPlayer.source ~= 0 then
                    Server:showNotification(xPlayer.source, "Veuillez spécifier un item à donner.")
                else
                    Shared.Log:Error("Aucun item spécifié pour la commande givemysterybox.")
                end
                return
            end

            local players = ESX.GetPlayers()
            for _, playerId in ipairs(players) do
                local targetPlayer = ESX.GetPlayerFromId(playerId)
                if type(targetPlayer) == "table" then
                    targetPlayer.addInventoryItem(itemName, itemCount)
                    Server:showNotification(targetPlayer.source, "Vous avez reçu ~b~%s~s~ x%d.", false, itemName, itemCount)
                end
            end

            if xPlayer.source ~= 0 then
                Server:showNotification(xPlayer.source, "Vous avez donné ~b~%s~s~ x%d à tous les joueurs.", false, itemName, itemCount)
            else
                Shared.Log:Success(string.format("Vous avez donné %s x%d à tous les joueurs.", itemName, itemCount))
            end
        end
    end
end)