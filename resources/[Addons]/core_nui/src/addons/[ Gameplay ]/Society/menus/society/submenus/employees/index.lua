local menu = {}

local SocietyEmployeesPlayer = require 'src.addons.[ Gameplay ].Society.menus.society.submenus.employees.player'

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Societé")

    SocietyEmployeesPlayer:LoadMenu(menu.Menu)

    menu.Menu:IsVisible(function(Items)
        local employees = MOD_Society.data.employees

        if (employees) then
            Items:Button("Recruter la personne en face de vous", nil, {}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 4.0 then
                        TriggerServerEvent('OneLife:Society:SetGrade', MOD_Society.data.name, nil, "recruit", GetPlayerServerId(closestPlayer))
                    else
                        ESX.ShowNotification("Aucun joueur à proximité")
                    end
                end
            })
            Items:Line()
            for _, employee in pairs(employees) do
                Items:Button(string.format("%s %s", employee.firstname, employee.lastname), nil, {
                    RightLabel = employee.grade
                }, true, {
                    onSelected = function()

                        SocietyEmployeesPlayer:SetData(employee);

                    end
                }, SocietyEmployeesPlayer.Menu);
            end
        else
            Items:Separator("Chargement de la liste des employés...");
        end
        
    end)
end

return menu