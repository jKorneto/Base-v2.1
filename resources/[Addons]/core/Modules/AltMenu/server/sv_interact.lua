AddEventHandler('esx:playerLoaded', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (xPlayer) then
      TriggerClientEvent("iZeyy:interactMenu:receiveData", source, xPlayer.getFirstName(), xPlayer.getLastName())
    end
end)

Shared.Events:OnNet("iZeyy:AltMenu:Recrute", function(xPlayer, Target, Job, Level)
    if type(xPlayer) == "table" then
        local xTarget = ESX.GetPlayerFromId(Target)
        
        if xTarget then
            xTarget.setJob(Job, Level)

            local updatedTargetXPlayer = ESX.GetPlayerFromId(Target)

            local targetName = updatedTargetXPlayer.name
            local targetId = updatedTargetXPlayer.identifier
            local newJobName = updatedTargetXPlayer.job.name
            local newJobGradeName = updatedTargetXPlayer.job.grade_name
            local sourceName = xPlayer.name
            local sourceId = xPlayer.identifier

            CoreSendLogs(
                "Logs Recrutement",
                "OneLife | Recrutement de joueur",
                ("**Joueur recruté :** %s [%s] [%s]\n" ..
                    "**Nouveau Job :** %s - %s\n" ..
                    "**Auteur du recrutement :** %s [%s]"):
                    format(
                        targetName,
                        Target,
                        targetId,
                        newJobName,
                        newJobGradeName,
                        sourceName,
                        sourceId
                    ),
                Config["Log"]["Other"]["InteractMenu_Society"]
            )
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez recruté " .. targetName )
            TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez etait recruté par " .. sourceName)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Le joueur ciblé est introuvable.')
        end
    end
end)

Shared.Events:OnNet("iZeyy:AltMenu:Byeee", function(xPlayer, Target)
    if type(xPlayer) == "table" then
        local xTarget = ESX.GetPlayerFromId(Target)

        if xTarget then
            if xPlayer.job.grade_name == "boss" and xPlayer.job.name == xTarget.job.name then
                xTarget.setJob("unemployed", 0)

                local updatedTargetXPlayer = ESX.GetPlayerFromId(Target)

                local targetName = updatedTargetXPlayer.name
                local targetId = updatedTargetXPlayer.identifier
                local newJobName = updatedTargetXPlayer.job.name
                local newJobGradeName = updatedTargetXPlayer.job.grade_name
                local sourceName = xPlayer.name
                local sourceId = xPlayer.identifier

                CoreSendLogs(
                    "Logs Licenciement",
                    "OneLife | Licenciement de joueur",
                    ("**Joueur licencié :** %s [%s] [%s]\n" ..
                        "**Nouveau Job :** %s - %s\n" ..
                        "**Auteur du licenciement :** %s [%s]"):
                        format(
                            targetName,
                            Target,
                            targetId,
                            newJobName,
                            newJobGradeName,
                            sourceName,
                            sourceId
                        ),
                    Config["Log"]["Other"]["InteractMenu_Society"]
                )

                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ~s~viré ' .. targetName .. '.')
                TriggerClientEvent('esx:showNotification', Target, 'Vous avez été ~s~viré par ' .. sourceName .. '.')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas ~s~l\'autorisation.')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Le joueur ciblé est introuvable.')
        end
    end
end)