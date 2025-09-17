local main_menu = RageUI.AddMenu("", "Faites vos actions")

CreateThread(function()

    for k, v in pairs(Config["Helipad"]["List"]) do

        Game.Peds:Spawn(GetHashKey(v.pedModel), v.pedPos, v.pedHeading, true, true, function(ped)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
        end)

        -- Spawn
        local HelipadSpawn = Game.Zone("HelipadSpawn#"..k, {
            job = k
        })

        HelipadSpawn:Start(function()
            HelipadSpawn:SetTimer(1000)
            HelipadSpawn:SetCoords(v.pedPos)

            HelipadSpawn:IsPlayerInRadius(3.0, function()
                HelipadSpawn:SetTimer(0)
                HelipadSpawn:Marker()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                HelipadSpawn:IsPlayerInRadius(5.0, function()

                    HelipadSpawn:KeyPressed("E", function()
                        main_menu:Toggle()
                    end)

                end, false, false)
            end, false, false)

            HelipadSpawn:RadiusEvents(5.0, nil, function()
                main_menu:Close()
            end)
        end)

        -- Store
        local HelipadStore = Game.Zone("HelipadStore#"..k, {
            job = k
        })

        HelipadStore:Start(function()
            HelipadStore:SetTimer(1000)
            HelipadStore:SetCoords(v.spawnPos)

            HelipadStore:IsPlayerInRadius(5.0, function()
                HelipadStore:SetTimer(0)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger l'helicoptere")

                HelipadStore:IsPlayerInRadius(5.0, function()

                    HelipadStore:KeyPressed("E", function()
                        local ped = Client.Player:GetPed()
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local vehicleClass = GetVehicleClass(vehicle)

                        if (vehicleClass == 15) then
                            TaskLeaveVehicle(ped, vehicle, 0)
                            SetTimeout(3000, function()
                                DeleteEntity(vehicle)
                            end)
                        else
                            ESX.ShowNotification("Ce garage n'est pas adapté a ce style de Véhicule (Hélicoptère)")
                        end
                    end)

                end, false, true)
            end, false, true)

        end)


    end

    main_menu:IsVisible(function(Items)
        local job = Client.Player:GetJob().name

        for k, v in pairs(Config["Helipad"]["List"][job].helicopterList) do
            Items:Button(v.label, nil, { RightLabel = "Sortir →"}, true, {
                onSelected = function()
                    Shared.Events:ToServer(Enums.Helipad.Spawn, v.name)
                end
            })
        end
    end)

end)