MOD_Society.Menus.MainSociety = RageUI.CreateMenu("", "Societé")

local SocietyManageAccounts = require 'src.addons.[ Gameplay ].Society.menus.society.submenus.accounts.index'
SocietyManageAccounts:LoadMenu(MOD_Society.Menus.MainSociety)

local SocietyManageEmployees = require 'src.addons.[ Gameplay ].Society.menus.society.submenus.employees.index'
SocietyManageEmployees:LoadMenu(MOD_Society.Menus.MainSociety)

local SocietyManageSalary = require 'src.addons.[ Gameplay ].Society.menus.society.submenus.salary.index'
SocietyManageSalary:LoadMenu(MOD_Society.Menus.MainSociety)

MOD_Society.Menus.MainSociety:IsVisible(function(Items)

    Items:Button("Gestion des comptes", nil, { }, true, {
        onSelected = function()
            TriggerServerEvent('OneLife:Society:RequestMoney', MOD_Society.data.name)
            TriggerServerEvent('OneLife:Society:RequestDirtyMoney', MOD_Society.data.name)
        end
    }, SocietyManageAccounts.Menu);

    Items:Button("Gestion des employés", nil, { }, true, {
        onSelected = function()
            TriggerServerEvent('OneLife:Society:RequestEmployees', MOD_Society.data.name)
        end
    }, SocietyManageEmployees.Menu);

    Items:Button("Gestion des salaires", nil, { }, true, {
        onSelected = function()
            TriggerServerEvent('OneLife:Society:RequestGrades', MOD_Society.data.name)
        end
    }, SocietyManageSalary.Menu);

end, nil, function()
    MOD_Society.data = {}
end)


RegisterNetEvent('OneLife:Society:OpenMenuBoss')
AddEventHandler('OneLife:Society:OpenMenuBoss', function(societyData)
    MOD_Society.Menus.MainSociety:Toggle()

    MOD_Society.data = societyData
end)

OneLife:OnJobChange(function(typeJob, job)
    if (typeJob == "job") then
        MOD_Society.Menus.MainSociety:Close()
    end
end)