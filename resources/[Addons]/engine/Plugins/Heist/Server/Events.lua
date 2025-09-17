Shared.Events:OnProtectedNet(Engine["Enums"].Heist.Events.startHouseHeist, function(xPlayer)
    if (type(xPlayer) == "table") then
        local hasPhone = xPlayer.getInventoryItem("phone")
        
        if (hasPhone) then
            local timer = Engine.Heist:getPlayerTimer(xPlayer.identifier)
            local house = Engine.Heist:getRandomHouse()
            local hasSleepingPed = false
            local inRobbery = Engine.Heist:isPlayerInRobbery(xPlayer.identifier)
            local isPolice = xPlayer.job.name == "police"
            local hasFaction = (xPlayer.job2.name ~= "unemployed" or xPlayer.job2.name ~= "unemployed2")

            if (inRobbery) then
                return Server:showNotification(xPlayer.source, "Tu es déjà dans un braquage !", false)
            end

            if (timer) then
                if (not timer:HasPassed()) then
                    return Server:showNotification(xPlayer.source, "Tu dois encore attendre " .. timer:ShowRemaining() .. " minutes avant de pouvoir commencer un nouveau braquage !", false)
                end
            end

            if (isPolice) then
                return Server:showNotification(xPlayer.source, "Dégage je parle pas avec les policiers", false)
            end

            if (not hasFaction) then
                return Server:showNotification(xPlayer.source, "Tes inconnue dans le monde du crime, revient quand tu seras dans un groupe", false)
            end
            
            if (house) then
                local housePosition = vector2(house.position.x, house.position.y)
                local houseImage = house.image
                local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(xPlayer.source)

                local result = exports["lb-phone"]:SendMessage("Lester", phoneNumber,
                    "Check cette photo c’est l’entrée de la maison, les coordonnées arrivent bouge-toi !",
                    {houseImage}
                )

                if (result) then
                    exports["lb-phone"]:SendCoords("lester", tostring(phoneNumber), housePosition)
                    Engine.Heist:addPlayerInRobbery(xPlayer, house.category, house.position, house.hasSleepingPed)
                    Engine.Heist:startPlayerTimer(xPlayer.identifier)
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Heist.Events.startHouseZone, house.category, vector3(house.position.x, house.position.y, house.position.z), house.hasSleepingPed)
                end
            end
        else
            Server:showNotification(xPlayer.source, "Tu n'as pas de téléphone tes serieux ?", false)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Heist.Events.takeHouseItem, function(xPlayer, index, count)
    if (type(xPlayer) == "table") then
        if (Engine.Heist:isPlayerInRobbery(xPlayer.identifier)) then
            local robbery = Engine.Heist:getPlayerInRobbery(xPlayer.identifier)
            local houseItems = Engine["Config"]["Heist"]["HouseReward"][robbery.category]

            if (houseItems) then
                local item = houseItems[index]

                if (item) then
                    local itemName = item.item
                    local itemLabel = item.label

                    if (xPlayer.canCarryItem(itemName, 1)) then
                        xPlayer.addInventoryItem(itemName, 1)

                        if ((count - 1) == 0) then
                            Server:showNotification(xPlayer.source, "Il ne reste plus d'objet à récupérer, sort de la maison !", false)
                        end

                        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Heist.Events.receiveItem, index)
                    else
                        Server:showNotification(xPlayer.source, "Vous n'avez plus de place sur vous", false)
                    end
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Heist.Events.failedHouseHeist, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (Engine.Heist:isPlayerInRobbery(xPlayer.identifier)) then
            local robbery = Engine.Heist:getPlayerInRobbery(xPlayer.identifier)
            local playerItems = xPlayer.getInventory()
            local houseItems = Engine["Config"]["Heist"]["HouseReward"][robbery.category]
        
            if (playerItems) then
                for k, v in pairs(playerItems) do
                    for j, b in pairs(houseItems) do
                        if (v.name == b.item) then
                            xPlayer.removeInventoryItem(v.name, v.quantity)
                        end
                    end
                end
            end

            Engine.Heist:removePlayerInRobbery(xPlayer.identifier)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Heist.Events.callPolice, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (Engine.Heist:isPlayerInRobbery(xPlayer.identifier)) then
            local robbery = Engine.Heist:getPlayerInRobbery(xPlayer.identifier)

            if (robbery.hasSleepingPed) then
                local housePosition = vector3(robbery.position.x, robbery.position.y, robbery.position.z)
                local policeInService = Engine.Heist:getPoliceInService()

                if (policeInService) then
                    for k, v in pairs(policeInService) do
                        local player = ESX.GetPlayerFromId(v)

                        if (player) then
                            if (player.job.name == "police") then
                                Server:showNotification(player.source, "Un braquage de maison à été signalé, une position a été ajoutée sur votre GPS", false)
                                Shared.Events:ToClient(player.source, Engine["Enums"].Heist.Events.sendHousePosition, housePosition)
                            end
                        end
                    end
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Heist.Events.sellItem, function(xPlayer, category)
    if (type(xPlayer) == "table") then
        if (Engine.Heist:isPlayerInRobbery(xPlayer.identifier)) then
            local playerItems = xPlayer.getInventory()
            local houseItems = Engine["Config"]["Heist"]["HouseReward"][category]
            local price = 0
        
            if (playerItems) then
                for k, v in pairs(playerItems) do
                    for j, b in pairs(houseItems) do
                        if (v.name == b.item) then
                            xPlayer.removeInventoryItem(v.name, 1)
                            xPlayer.addAccountMoney("dirtycash", b.price)
                            price = price + b.price
                        end
                    end
                end
            end

            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Heist.Events.successHouseHeist)
            Engine.Heist:removePlayerInRobbery(xPlayer.identifier)
            Server:showNotification(xPlayer.source, "Tu as vendu tes objets pour %s ~g~$~s~", false, Shared.Math:GroupDigits(price))
        end
    end
end)

Server:OnPlayerDropped(function(xPlayer)
    if (type(xPlayer) == "table") then
        if (Engine.Heist:isPlayerInRobbery(xPlayer.identifier)) then
            local robbery = Engine.Heist:getPlayerInRobbery(xPlayer.identifier)

            if (robbery.position) then
                local lastPosition = vector3(robbery.position.x, robbery.position.y, robbery.position.z)
                xPlayer.setLastPosition(lastPosition)
                Engine.Heist:removePlayerInRobbery(xPlayer.identifier)
            end
        end
    end
end)