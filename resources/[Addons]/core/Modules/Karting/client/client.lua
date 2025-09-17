local main_menu = RageUI.AddMenu("", "Los Santos Karting")
local inActivity = false

CreateThread(function()
    
    local KartingZone = Game.Zone("KartingZone")

    KartingZone:Start(function()
        KartingZone:SetTimer(1000)
        KartingZone:SetCoords(Config["Karting"]["PedPos"])

        KartingZone:IsPlayerInRadius(8.0, function()
            KartingZone:SetTimer(0)
            KartingZone:Marker()
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

            KartingZone:IsPlayerInRadius(8.0, function()

                KartingZone:KeyPressed("E", function()
                    if not IsPedInAnyVehicle(PlayerPedId(), false) then 
                        main_menu:Toggle()
                    else
                        ESX.ShowNotification("Vous ne pouvez pas faire cette action dans un véhicule")
                    end
                end)

            end, false, false)

        end, false, false)

        KartingZone:RadiusEvents(5.0, nil, function()
            main_menu:Close()
        end)
    end)

    local DelKartingZone = Game.Zone("DelKartingZone")

    DelKartingZone:Start(function()
        DelKartingZone:SetTimer(1000)
        DelKartingZone:SetCoords(Config["Karting"]["SpawnPos"])

        DelKartingZone:IsPlayerInRadius(8.0, function()
            DelKartingZone:SetTimer(0)
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour rendre le véhicule")

            DelKartingZone:IsPlayerInRadius(8.0, function()

                DelKartingZone:KeyPressed("E", function()
                    local ped = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(ped, false)

                    TaskLeaveVehicle(ped, vehicle, 0)
                    SetTimeout(2000, function()
                        DeleteEntity(vehicle)
                    end)
                end)

            end, false, true)

        end, false, true)
    end)

    main_menu:IsVisible(function(Items)
        for k, v in pairs(Config["Karting"]["VehList"]) do
            Items:Button(v.label, nil, { RightLabel = v.price .. "$"}, true, {
                onSelected = function()
                    if not IsPedInAnyVehicle(PlayerPedId(), false) then 
                        TriggerServerEvent("iZeyy:Karting:Spawn", v.label, v.model, v.price)
                    else
                        ESX.ShowNotification("Vous pouvez pas faire cette action dans un véhicule")
                    end
                end
            })
        end
    end)

end)