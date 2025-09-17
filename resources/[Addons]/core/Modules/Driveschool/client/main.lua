local main_menu = RageUI.AddMenu("", "Faites vos actions")
local InMenuTimeOut = false
local InMenuTimeOut2 = false

CreateThread(function()

    local Blip = AddBlipForCoord(Config["DriveSchool"]["Pos"].x, Config["DriveSchool"]["Pos"].y, Config["DriveSchool"]["Pos"].z)
    SetBlipSprite(Blip, 498)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 0)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Auto École")
    EndTextCommandSetBlipName(Blip)

    local DriveSchoolZone = Game.Zone("DriveSchoolZone")

    DriveSchoolZone:Start(function()
        DriveSchoolZone:SetTimer(1000)
        DriveSchoolZone:SetCoords(Config["DriveSchool"]["Pos"])
        DriveSchoolZone:IsPlayerInRadius(8.0, function()
            DriveSchoolZone:SetTimer(0)
            DriveSchoolZone:Marker()

            DriveSchoolZone:IsPlayerInRadius(3, function()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                DriveSchoolZone:KeyPressed("E", function()
                    main_menu:Toggle()
                end)
            end, false, false)
    
            DriveSchoolZone:RadiusEvents(3, nil, function()
                if main_menu:IsOpen() then
                    main_menu:Close()
                end
            end)
        end, false, false)
    end)
    
end)

main_menu:IsVisible(function(Items)
    Items:Line()
    Items:Button("Passez votre Code", nil, { RightLabel = Config["DriveSchool"]["PriceCode"].."$" }, true, {
        onSelected = function()
            TriggerServerEvent("iZeyy:DrivingSchool:HasMoney", "code")
            main_menu:Close()
        end
    })
    Items:Button("Passez votre Permis", nil, { RightLabel = Config["DriveSchool"]["PriceLicenseDrive"].."$"}, true, {
        onSelected = function()
            TriggerServerEvent("iZeyy:DrivingSchool:HasMoney", "permis")
            main_menu:Close()
        end
    })
end)

RegisterNetEvent("iZeyy:DrivingSchool:OpenMenu", function()
    main_menu:Close()
    iZeyy:OpenCodeMenu()
end)

RegisterNetEvent("iZeyy:DrivingSchool:GoDrive", function()
    main_menu:Close()
    iZeyy:StartExam()
end)