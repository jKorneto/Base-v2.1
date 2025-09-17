local main_menu = RageUI.AddMenu("", "Carte d'identité")

RegisterNetEvent("izeyy:idcard:use", function()
    if (not main_menu:IsOpen()) then
        main_menu:Toggle()
    else
        ESX.ShowNotification("Vous avez déjà le menu d'identité ouvert")
    end
end)

main_menu:IsVisible(function(Items)
    Items:Button("Voir votre carte d'identité", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
        end
    })
    Items:Button("Montrer votre carte d'identité", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            local closestPlayer, closestDistance = Game.Players:GetClosestPlayer()
            if (closestPlayer and closestDistance < 5) then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification("Aucun joueur autour de vous")
            end
        end
    })
end)