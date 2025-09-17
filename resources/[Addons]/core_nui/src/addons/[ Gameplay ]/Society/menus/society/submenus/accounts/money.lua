local menu = {}

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Societé")

    menu.Menu:IsVisible(function(Items)
        Items:Button("Argent disponible:", nil, { RightLabel = MOD_Society.data?.money.."$" }, true, {})
        Items:Line()

        Items:Button("Déposer de l'argent", nil, {
            RightBadge = RageUI.BadgeStyle.Tick,
        }, true, {
            onSelected = function()
                -- Utilisation de lib.inputDialog pour demander le montant à déposer
                local input = lib.inputDialog("Déposer de l'argent", {
                    {type = "number", label = "Montant à déposer"}
                })
        
                -- Vérification si l'utilisateur a annulé la boîte de dialogue
                if input == nil or #input == 0 then
                    ESX.ShowNotification("~s~Saisie annulée")
                    return
                end
        
                local amount = tonumber(input[1]) -- Récupérer le montant saisi
        
                if (amount and amount > 0) then
                    TriggerServerEvent('OneLife:Society:AddMoney', MOD_Society.data.name, amount, "cash")
                else
                    ESX.ShowNotification("~s~Entrée invalide.")
                end
            end
        });
        
        Items:Button("Retirer de l'argent", nil, {
            RightBadge = RageUI.BadgeStyle.Alert,
        }, true, {
            onSelected = function()
                -- Utilisation de lib.inputDialog pour demander le montant à retirer
                local input = lib.inputDialog("Retirer de l'argent", {
                    {type = "number", label = "Montant à retirer"}
                })
        
                -- Vérification si l'utilisateur a annulé la boîte de dialogue
                if input == nil or #input == 0 then
                    ESX.ShowNotification("~s~Saisie annulée")
                    return
                end
        
                local amount = tonumber(input[1]) -- Récupérer le montant saisi
        
                if (amount and amount > 0) then
                    TriggerServerEvent('OneLife:Society:RemoveMoney', MOD_Society.data.name, amount, "cash")
                else
                    ESX.ShowNotification("~s~Entrée invalide.")
                end
            end
        });
        
        
    end)
end

return menu