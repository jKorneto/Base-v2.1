local menu = {}

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Factions")

    menu.Menu:IsVisible(function(Items)
        Items:Separator(string.format("Argent disponible: %s~s~$~s~", MOD_Society.data?.dirty_money));

        Items:Button("Déposer de l'argent sale", nil, {
            RightBadge = RageUI.BadgeStyle.Tick,
        }, true, {
            onSelected = function()
                local amount = API_Player:showKeyboard("Combien voulez vous déposer", "", 10);
        
                if (API_Player:InputIsValid(amount, "number") and tonumber(amount) > 0) then
                    local newAmount = tonumber(amount);
        
                    if (newAmount > 0) then
                        TriggerServerEvent('OneLife:Society:AddMoney', MOD_Society.data.name, newAmount, "dirty_money")
                    else
                        ESX.ShowNotification("~s~Entré invalide.")
                    end
                else
                    ESX.ShowNotification("~s~Entré invalide.")
                end
            end
        });
        
        Items:Button("Retirer de l'argent sale", nil, {
            RightBadge = RageUI.BadgeStyle.Alert,
        }, true, {
            onSelected = function()
                local amount = API_Player:showKeyboard("Combien voulez vous retirer", "", 10);
        
                if (API_Player:InputIsValid(amount, "number") and tonumber(amount) > 0) then
                    local newAmount = tonumber(amount);
        
                    if (newAmount > 0) then
                        TriggerServerEvent('OneLife:Society:RemoveMoney', MOD_Society.data.name, newAmount, "dirty_money")
                    else
                        ESX.ShowNotification("~s~Entré invalide.")
                    end
        
                else
                    ESX.ShowNotification("~s~Entré invalide.")
                end
            end
        });
        
    end)
end

return menu