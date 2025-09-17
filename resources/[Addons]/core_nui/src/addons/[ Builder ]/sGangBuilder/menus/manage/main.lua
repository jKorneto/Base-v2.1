MOD_GangBuilder.Menus.Manage = RageUI.CreateMenu("", "Gestion Factions")

local GangManageGrade = require 'src.addons.[ Builder ].sGangBuilder.menus.manage.submenus.ManageGrades.index'
GangManageGrade:LoadMenu(MOD_GangBuilder.Menus.Manage)

local GangManageMembres = require 'src.addons.[ Builder ].sGangBuilder.menus.manage.submenus.ManageMembres.index'
GangManageMembres:LoadMenu(MOD_GangBuilder.Menus.Manage)

MOD_GangBuilder.Menus.Manage:IsVisible(function(Items)
    Items:Button("Factions: " .. MOD_GangBuilder.data.infos.label, nil, {}, true, {})
    Items:Line()

    Items:Button("Gestion des grades", nil, { }, true, {
        onSelected = function()
            TriggerServerEvent('OneLife:GangBuilder:RequestGrades', MOD_GangBuilder.data.infos.id)
        end
    }, GangManageGrade.Menu);
    Items:Button("Gestion des membres", nil, { }, true, {
        onSelected = function()
            TriggerServerEvent('OneLife:GangBuilder:RequestGrades', MOD_GangBuilder.data.infos.id)
            TriggerServerEvent('OneLife:GangBuilder:RequestMembres', MOD_GangBuilder.data.infos.id)
        end
    }, GangManageMembres.Menu);

end, nil, function()
    MOD_GangBuilder.data.infos = {}
end)


RegisterNetEvent('OneLife:GangBuilder:OpenGangManage')
AddEventHandler('OneLife:GangBuilder:OpenGangManage', function(gangInfos)
    MOD_GangBuilder.Menus.Manage:Toggle()

    MOD_GangBuilder.data.infos = gangInfos
end)