RegisterCommand("addvip", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if ((xPlayer.source == 0) or (xPlayer.getGroup() == "fondateur")) then
            local time = tonumber(args[2])
            local message = nil
            local targetMessage = nil

            if (type(time) == "number" and time > 0) then
                local identifier = xTarget.getIdentifier()
                local fivemID = xTarget.getFivemID()

                if ((fivemID and fivemID ~= 0) and identifier) then
                    local player = ESX.GetPlayerFromFivemID(fivemID)
                    local vip = Engine.Vip:addVip(fivemID, player and player.identifier or nil, time)

                    if (vip == true) then
                        message = string.format("Vous avez donner un VIP pour %s jour(s) à %s", time, xTarget.name)
                        targetMessage = string.format("Votre VIP a été activé pour %d jour(s)", time)
                        Engine.Discord:SendMessage("Vip",
                            string.format("Le joueur %s (***%s***) vient d'activé le VIP pendant **%s** jour(s) pour le joueur %s (***%s***)",
                                xPlayer.name,
                                xPlayer.identifier,
                                time,
                                xTarget.name,
                                xTarget.identifier
                            )
                        )
                    elseif (vip == "added_day") then
                        message = string.format("Vous avez rajouter %s jour(s) au VIP de %s", time, xTarget.name)
                        targetMessage = string.format("Votre VIP a été prolongé de %d jour(s)", time)
                        Engine.Discord:SendMessage("Vip",
                            string.format("Le joueur %s (***%s***) vient d'ajouter **%s** jour(s) au VIP du joueur %s (***%s***)",
                                xPlayer.name,
                                xPlayer.identifier,
                                time,
                                xTarget.name,
                                xTarget.identifier
                            )
                        )
                    end

                    Engine.Vip:updateClientVipData(xTarget)

                    if (message) then
                        if (xPlayer.source ~= 0) then
                            Server:showNotification(xPlayer.source, message, false)
                        end
                    end

                    if (targetMessage) then
                        Server:showNotification(xTarget.source, targetMessage, false)
                    end
                else
                    if (xPlayer.source ~= 0) then
                        Server:showNotification(xPlayer.source, "Le joueur n'a pas lier son compte FiveM", true)
                    else
                        Shared.Log:Error(string.format("Player %s has not linked their FiveM account", args[1]))
                    end
                end
            end
        end
    else
        if (source ~= 0) then
            Server:showNotification(source, "Le joueur n'est pas connecté", true)
        else
            Shared.Log:Error(string.format("Player ^4%s^0 are not connected", args[1]))
        end
    end
end)

RegisterCommand("tebex_addvip", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        if (xPlayer.source == 0) then
            local fivemID = tostring(args[1])
            local time = tonumber(args[2])

            if (type(fivemID) == "string" and type(time) == "number" and fivemID ~= "0" and time > 0) then
                local player = ESX.GetPlayerFromFivemID(fivemID)
                local vip = Engine.Vip:addVip(fivemID, player and player.identifier or nil, time)

                if (vip == true) then
                    Engine.Discord:SendMessage("Vip",
                        string.format("Tebex vient d'activé le VIP pour **%s** jour(s) au joueur avec l'identifiant **%s**",
                            time,
                            fivemID
                        )
                    )
                elseif (vip == "added_day") then
                    Engine.Discord:SendMessage("Vip",
                        string.format("Tebex vient d'ajouter  **%s** jour(s) au VIP pour le joueur avec l'identifiant **%s**",
                            time,
                            fivemID
                        )
                    )
                end

                if (player) then
                    Engine.Vip:updateClientVipData(player)
                end
            end
        end
    end
end)

RegisterCommand("removevip", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if ((xPlayer.source == 0) or (xPlayer.getGroup() == "fondateur")) then
            local message = nil
            local targetMessage = nil
            local vip = Engine.Vip:removeVip(xTarget.identifier)

            if (vip == true) then
                message = string.format("Vous avez retiré le VIP de %s", xTarget.name)
                targetMessage = "Votre VIP a été retiré"
                Engine.Discord:SendMessage("VipRemove",
                    string.format("Le joueur %s (***%s***) vient de retiré le VIP du joueur %s (***%s***)",
                        xPlayer.name,
                        xPlayer.identifier,
                        xTarget.name,
                        xTarget.identifier
                    )
                )

                Engine.Vip:updateClientVipData(xTarget)
            elseif (vip == "not_vip") then
                message = string.format("Le joueur %s n'a pas de VIP", xTarget.name)
            end

            if (message) then
                if (xPlayer.source ~= 0) then
                    Server:showNotification(xPlayer.source, message, false)
                end
            end

            if (targetMessage) then
                Server:showNotification(xTarget.source, targetMessage, false)
            end
        end
    else
        if (source ~= 0) then
            Server:showNotification(source, "Le joueur n'est pas connecté", true)
        else
            Shared.Log:Error(string.format("Player ^4%s^0 are not connected", args[1]))
        end
    end
end)

exports("isPlayerVip", function(fivemID, identifier)
    return Engine.Vip:isPlayerVip(fivemID, identifier)
end)

Shared.Events:OnNet(Engine["Enums"].Player.Events.PlayerLoaded, function(xPlayer)
    if (type(xPlayer) == "table") then
        local fivemID = xPlayer.getFivemID()
        local identifier = xPlayer.identifier
        local isVip = Engine.Vip:isPlayerVip(fivemID, identifier)

        if (isVip) then
            if (Engine.Vip:isMissingIdentifier(fivemID)) then
                Engine.Vip:addIdentifier(fivemID, identifier)
            end
            
            Engine.Vip:updateClientVipData(xPlayer)
        end
    end
end)
