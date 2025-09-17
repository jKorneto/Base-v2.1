local secuCode = Config["AntiCheat"]["SecuCode"]

RegisterNetEvent("Core:AntiCheat:Ban", function(reason, securityCode)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (securityCode == secuCode) then
            xPlayer.ban(0, "Tentative de Cheat ("..reason..")")
            TriggerClientEvent("Core:AntiCheat:TakeScreen", xPlayer.source, Config["Log"]["Anticheat"]["Ban"])
            CoreSendLogs(
                "AntiCheat - Core",
                "OneLife | AntiCheat - Core",
                ("Le Joueur %s (***%s***) a etait ban pour la raison (***%s***)"):format(
                    xPlayer.getName(),
                    xPlayer.identifier,
                    reason
                ),
                Config["Log"]["Anticheat"]["Ban"]
            )
        else
            xPlayer.ban(0, "Tentative de Cheat (SecurityCode)")
            CoreSendLogs(
                "AntiCheat - Core",
                "OneLife | AntiCheat - Core",
                ("Le Joueur %s (***%s***) a etait ban pour la raison (***SecurityCode***)"):format(
                    xPlayer.getName(),
                    xPlayer.identifier
                ),
                Config["Log"]["Anticheat"]["Ban"]
            )
            TriggerClientEvent("Core:AntiCheat:TakeScreen", xPlayer.source, Config["Log"]["Anticheat"]["Ban"])
        end
    end
end)

RegisterNetEvent("core:explosion:sendLogs", function(securityCode, damageType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        TriggerClientEvent("Core:AntiCheat:TakeScreen", xPlayer.source, Config["Log"]["Anticheat"]["Ban"])
        CoreSendLogs(
            "AntiCheat - Core",
            "OneLife | AntiCheat - Core",
            ("Le Joueur %s (***%s***) viens d'exploser un véhicule, explosion de type (***%s***)"):format(
                xPlayer.getName(),
                xPlayer.identifier,
                damageType
            ),
            Config["Log"]["Anticheat"]["Ban"]
        )
    end

end)