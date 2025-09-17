local menu = {}

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Garage")

    menu.Menu:IsVisible(function(Items)
        local grades = MOD_Society.data.grades

        if (grades) then

            for _, grade in pairs(grades) do

                Items:Button(grade.label, nil, {
                    RightLabel = ("%s~s~$"):format(grade.salary)
                }, true, {
                    onSelected = function()
                        -- Utilisation de lib.inputDialog pour définir le nouveau salaire
                        local input = lib.inputDialog("Définir le nouveau salaire", {
                            {type = "number", label = "Nouveau salaire"}
                        })
                
                        -- Vérification si l'utilisateur a annulé la boîte de dialogue
                        if input == nil or #input == 0 then
                            ESX.ShowNotification("~s~Saisie annulée")
                            return
                        end
                
                        local newSalary = tonumber(input[1]) -- Récupérer le nouveau salaire saisi
                
                        -- Validation de la saisie du salaire
                        if newSalary and (newSalary > 0 and newSalary <= 1500)  then
                            TriggerServerEvent('OneLife:Society:SetSalary', MOD_Society.data.name, grade.grade, newSalary)
                        else
                            ESX.ShowNotification("~s~Entrée invalide.")
                        end
                    end
                })
                

            end
        end
    end)
end

return menu