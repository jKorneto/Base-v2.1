local main_menu = RageUI.AddMenu("", "Permis de port d'arme")

RegisterNetEvent("izeyy:weapon:use", function()
    if (not main_menu:IsOpen()) then
        main_menu:Toggle()
    else
        ESX.ShowNotification("Vous avez déjà le menu de permis de port d'arme d'ouvert")
    end
end)

main_menu:IsVisible(function(Items)
    Items:Button("Voir votre permis de port d'arme", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
        end
    })
    Items:Button("Montrer votre permis de port d'arme", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            local closestPlayer, closestDistance = Game.Players:GetClosestPlayer()
            if (closestPlayer and closestDistance < 5) then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
            else
                ESX.ShowNotification("Aucun joueur autour de vous")
            end
        end
    })
end)

