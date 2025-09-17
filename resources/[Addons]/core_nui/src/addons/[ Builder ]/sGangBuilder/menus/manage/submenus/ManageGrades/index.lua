local menu = {}

function menu:SetData(data)
    menu.DataMenu = data
end

local GangModifGrade = require 'src.addons.[ Builder ].sGangBuilder.menus.manage.submenus.ManageGrades.ModifGrade'

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Gestion des grades")
    GangModifGrade:LoadMenu(menu.Menu)
    
    menu.Menu:IsVisible(function(Items)
        if (not MOD_GangBuilder.data.grades) then
            Items:Separator("Chargement des grades...")
        else
            Items:Button("Crée un Grade", nil, {}, true, {
                onSelected = function()
                    -- Utilisation de lib.inputDialog pour demander le nom du grade
                    local input = lib.inputDialog("Créer un Grade", {
                        {type = "input", label = "Nom du grade"}
                    })
            
                    -- Vérification si l'utilisateur a annulé la boîte de dialogue
                    if input == nil or #input == 0 then
                        ESX.ShowNotification("~s~Saisie annulée")
                        return
                    end
            
                    local gradeName = input[1] -- Récupérer le nom du grade saisi
            
                    if (gradeName and gradeName ~= "") then
                        TriggerServerEvent('OneLife:GangBuilder:AddNewGrade', gradeName, MOD_GangBuilder.data.infos.id)
                    else
                        ESX.ShowNotification("~s~Nom de grade invalide.")
                    end
                end
            });
            
            Items:Line()
            for name, grade in pairs(MOD_GangBuilder.data.grades) do
                Items:Button("Grade : "..grade.label, nil, {}, true, {
                    onSelected = function()
                        GangModifGrade:SetData({
                            name = name,
                            label = grade.label,
                            grade = grade
                        })
                    end
                }, GangModifGrade.Menu);
            end
        end

    end, function()
    end)
end

return menu