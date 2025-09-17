Shared.Events:OnNet(Enums.Vda.Craft1, function(xPlayer, weapon, label, price)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name == "police") then
            return
        end

        local player = GetPlayerPed(xPlayer.source)
        local playerPos = GetEntityCoords(player)
        local craftPos = Config["Vda"]["CraftPos"] 

        local dist = #(playerPos - craftPos)
        if (dist < 15) then
            local playerType = vdaGetPlayerType(xPlayer.identifier)

            if (playerType == "vda1") then

                local correctWeapon = false
                for k, v in pairs(Config["Vda"]["1"]) do
                    if name == v.weapon and label == v.label and price == v.price then
                        correctWeapon = true
                        break
                    end
                end
        
                if (correctWeapon) then
                    local price = tonumber(price)
                    if xPlayer.getAccount("dirtycash").money >= price then
                        if (xPlayer.canCarryItem(string.lower(weapon), 1)) then
                            xPlayer.removeAccountMoney("dirtycash", price)
                            xPlayer.showNotification(("Vous avez etait debité de (%s$)"):format(price))
                            Shared.Events:ToClient(xPlayer.source, Enums.Vda.CraftingWeapon)
                            SetTimeout(30000, function()
                                xPlayer.addWeapon(weapon, 1)
                                xPlayer.showNotification(("Vous avez reçu (%s)"):format(label))
                                CoreSendLogs(
                                    "Vente d'armes Illégal",
                                    "OneLife | VDA",
                                    ("Le joueur **%s** (***%s***) a crée une armes (***%s***) pour **%s$** d'argent sale"):format(
                                        xPlayer.getName(),
                                        xPlayer.getIdentifier(),
                                        weapon,
                                        price
                                    ),
                                    Config["Log"]["Other"]["Vda"]
                                )
                            end)
                        else
                            xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                        end
                    else
                        xPlayer.showNotification("Vous n'avez pas assez d'argent sale")
                    end
                else
                    xPlayer.showNotification("Cette armes n'est pas dans votre VDA")
                end
            else
                return xPlayer.showNotification("Vous ne possedez pas cette vda")
            end
            
        end
    end    
end)

Shared.Events:OnNet(Enums.Vda.Craft2, function(xPlayer, weapon, label, price)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name == "police") then
            return
        end

        local player = GetPlayerPed(xPlayer.source)
        local playerPos = GetEntityCoords(player)
        local craftPos = Config["Vda"]["CraftPos"] 

        local dist = #(playerPos - craftPos)
        if (dist < 15) then
            local playerType = vdaGetPlayerType(xPlayer.identifier)

            if (playerType == "vda2") then

                local correctWeapon = false
                for k, v in pairs(Config["Vda"]["2"]) do
                    if name == v.weapon and label == v.label and price == v.price then
                        correctWeapon = true
                        break
                    end
                end
        
                if (correctWeapon) then
                    local price = tonumber(price)
                    if xPlayer.getAccount("dirtycash").money >= price then
                        if (xPlayer.canCarryItem(string.lower(weapon), 1)) then
                            xPlayer.removeAccountMoney("dirtycash", price)
                            xPlayer.showNotification(("Vous avez etait debité de (%s$)"):format(price))
                            Shared.Events:ToClient(xPlayer.source, Enums.Vda.CraftingWeapon)
                            SetTimeout(30000, function()
                                xPlayer.addWeapon(weapon, 1)
                                xPlayer.showNotification(("Vous avez reçu (%s)"):format(label))
                                CoreSendLogs(
                                    "Vente d'armes Illégal",
                                    "OneLife | VDA",
                                    ("Le joueur **%s** (***%s***) a crée une armes (***%s***) pour **%s$** d'argent sale"):format(
                                        xPlayer.getName(),
                                        xPlayer.getIdentifier(),
                                        weapon,
                                        price
                                    ),
                                    Config["Log"]["Other"]["Vda"]
                                )
                            end)
                        else
                            xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                        end
                    else
                        xPlayer.showNotification("Vous n'avez pas assez d'argent sale")
                    end
                else
                    xPlayer.showNotification("Cette armes n'est pas dans votre VDA")
                end
            else
                return xPlayer.showNotification("Vous ne possez cette vda")
            end
            
        end
    end    
end)