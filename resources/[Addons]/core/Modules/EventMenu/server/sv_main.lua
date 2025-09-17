local event_data = {}
local event_launched = false

local function notifyAllPlayers(message)
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if (xPlayer) then
            xPlayer.showNotification(message)
        end
    end
end

RegisterNetEvent("iZeyy_EventMenu:LaunchEvent", function(carName, carPos, radiusPos, eventDuration, rewardAmount)
    if not (event_launched) then
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            event_launched = true
            event_data = {
                model = carName,
                position = carPos,
                radius = radiusPos,
                duration = eventDuration,
                reward = rewardAmount
            }

            notifyAllPlayers(("Debut de l'événement dans 60 secondes trouvé le vehicule %s pour gagner %s $"):format(event_data.model, event_data.reward))
            print("Le Staff: ^3license:"..xPlayer.identifier.."^7 a lancé un event avec le véhicule ^3"..event_data.model.."^7 avec comme recompense ^3"..event_data.reward.."$^7 pour une durée de ^3"..event_data.duration.."^7 minutes")
            SetTimeout(1000, function()
                notifyAllPlayers(("L'événement a commencé bonne chance trouvé le véhicule %s en %s minutes pour gagner %s $"):format(event_data.model, event_data.duration, event_data.reward))
                TriggerClientEvent("iZeyy_EventMenu:CreateEvent", -1, event_data.radius, event_data.duration, event_data.model, event_data.position, event_data.reward)
                CoreSendLogs(
                    "Événement lancé",
                    "OneLife | Event",
                    ("Le Staff **%s** (***%s***) a lancé un événement avec le véhicule **%s** pour une récompense de **%s$** et une durée de **%s minutes**"):format(
                        xPlayer.getName(),
                        xPlayer.identifier,
                        carName,
                        rewardAmount,
                        eventDuration
                    ),
                    Config["Log"]["Other"]["StartEvent"]
                )
            end)
        end
    end
end)

RegisterNetEvent("iZeyy_EventMenu:EndEvent", function(rewardAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = tonumber(rewardAmount)

    if (xPlayer) then
        if (event_launched) then
            if (next(event_data)) then
                if (event_data.reward == tonumber(rewardAmount)) then
                    xPlayer.addAccountMoney('bank', event_data.reward)
                    xPlayer.showNotification(("Event terminé pour avoir gagné vous avez reçu %s $ en banque"):format(event_data.reward))
                    print("Event terminé le joueurs ^3license:"..xPlayer.identifier.."^7 a gagné un montant de ^3"..event_data.reward.."$^7")
                    CoreSendLogs(
                        "Event terminé",
                        "OneLife | Event",
                        ("Le joueur **%s** (***%s***) a gagné **%s$** en récompense de l'événement"):format(xPlayer.getName(), xPlayer.identifier, event_data.reward),
                        Config["Log"]["Other"]["EventEnd"]
                    )
                    event_launched = falsez
                    event_data = {}
                    notifyAllPlayers("Event terminé le véhicule a etait trouvé")
                end
            end
        end
    end
end)

ESX.AddGroupCommand("eventmenu", "responsable", function(src)

    local xPlayer = ESX.GetPlayerFromId(src);
    TriggerClientEvent("iZeyy_EventMenu:OpenMenu", src)

end, { help = "Ouvrir le menu event" });