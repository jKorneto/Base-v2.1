local menu = {}

function menu:SetData(data)
    menu.DataMenu = data
end

local GangModifMembre = require 'src.addons.[ Builder ].sGangBuilder.menus.manage.submenus.ManageMembres.ModifMembre'

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Gestion des membres")
    GangModifMembre:LoadMenu(menu.Menu)
    
    menu.Menu:IsVisible(function(Items)

        if (not MOD_GangBuilder.data.membres) then
            Items:Separator("Chargement des membres...")
        else
            Items:Button("Recruter un membre", nil, {}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~s~Aucun joueur proche.');
                    else
                        TriggerServerEvent('OneLife:GangBuilder:RecruitPlayer', GetPlayerServerId(closestPlayer), MOD_GangBuilder.data.infos.id)
                    end
                end
            });

            Items:Line()
            for license, membre in pairs(MOD_GangBuilder.data.membres) do
                if (membre.isOwner) then
                    Items:Button(membre.firstname.." "..membre.lastname, nil, { RightLabel = "Owner" }, false, {});
                end
            end
            for license, membre in pairs(MOD_GangBuilder.data.membres) do
                if (not membre.isOwner) then
                    Items:Button(membre.firstname.." "..membre.lastname, nil, { RightLabel = membre.grade }, true, {
                        onSelected = function()
                            GangModifMembre:SetData({
                                license = license,
                                name = membre.firstname.." "..membre.lastname
                            })
                        end
                    }, GangModifMembre.Menu);
                end
            end
        end

    end, function()
    end)
end

return menu