local main_menu = RageUI.AddMenu("", "Faites vos actions")

CreateThread(function()
    for k, v in pairs(Config["Carwash"]["Pos"]) do
        local Blips = AddBlipForCoord(v)
        SetBlipSprite(Blips, 100)
        SetBlipColour(Blips, 3)
        SetBlipScale(Blips, 0.6)
        SetBlipAsShortRange(Blips, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Station de Lavage")
        EndTextCommandSetBlipName(Blips)

        local CarWashZone = Game.Zone("CarWashZone")

        CarWashZone:Start(function()
            CarWashZone:SetTimer(1000)
            CarWashZone:SetCoords(v)
    
            CarWashZone:IsPlayerInRadius(60.0, function()
                CarWashZone:SetTimer(0)
                CarWashZone:Marker(nil, nil, 3.0)

                CarWashZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour laver votre véhicule")
                    
                    CarWashZone:KeyPressed("E", function()
                        TriggerServerEvent("iZeyy:Carwash:CheckMoney")
                    end)
                end, false, true)
            end, false, true)
        end)

    end
end)

RegisterNetEvent("iZeyy:Carwash:Task", function()
    local PlayerPed = PlayerPedId()
    local PlayerInVeh = GetVehiclePedIsIn(PlayerPed)
    local Vehicle = GetVehiclePedIsUsing(PlayerPed)
    TaskLeaveVehicle(PlayerPed, Vehicle, 0)
    FreezeEntityPosition(Vehicle, true)
    SetTimeout(2000, function()
        HUDProgressBar("Lavage en cours...", 10, function()
            WashDecalsFromVehicle(Vehicle, 1.0)
            SetVehicleDirtLevel(Vehicle, 0.0)
            FreezeEntityPosition(Vehicle, false)  
        end)
    end)
end)