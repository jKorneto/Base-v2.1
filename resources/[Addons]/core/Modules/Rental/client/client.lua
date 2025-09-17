local main_menu = RageUI.AddMenu("", "Location")
local action_menu = RageUI.AddSubMenu(main_menu, "", "Temps de location")

CreateThread(function()
    local carRental = Config["Rental"]["Vehicles"]["car"]
    local boatRental = Config["Rental"]["Vehicles"]["boat"]

    if (carRental) then
        for i = 1, #carRental do
            local rental = carRental[i]

            Game.Blip("RentalZone-car#"..i,
                {
                    coords = rental.position,
                    label = carRental.blipName,
                    sprite = carRental.blipSprite,
                    color = carRental.blipColor,
                }
            )

            Game.Peds:Spawn(rental.pedModel, rental.position, rental.pedHeading, true, true)

            local carZone = Game.Zone("RentalCar#"..i)

            carZone:Start(function()
                carZone:SetTimer(1000)
                carZone:SetCoords(rental.position)
    
                carZone:IsPlayerInRadius(5.0, function()

                    carZone:SetTimer(0)
                    carZone:IsPlayerInRadius(2.0, function()
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler à Hervé")

                        carZone:KeyPressed("E", function()
                            main_menu:SetData("type", {type = "car", index = i})
                            main_menu:Toggle()
                        end)
                    end, false, false)
                end, false, false)
    
                carZone:RadiusEvents(5.0, nil, function()
                    main_menu:Close()
                end)
            end)
        end
    end

    if (boatRental) then
        for i = 1, #boatRental do
            local rental = boatRental[i]

            Game.Blip("RentalZone-boat#"..i,
                {
                    coords = rental.position,
                    label = boatRental.blipName,
                    sprite = boatRental.blipSprite,
                    color = boatRental.blipColor,
                }
            )

            Game.Peds:Spawn(rental.pedModel, rental.position, rental.pedHeading, true, true)

            local boatZone = Game.Zone("RentalBoat#"..i)

            boatZone:Start(function()
                boatZone:SetTimer(1000)
                boatZone:SetCoords(rental.position)
    
                boatZone:IsPlayerInRadius(5.0, function()

                    boatZone:SetTimer(0)
                    boatZone:IsPlayerInRadius(2.0, function()
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler à Babakam")

                        boatZone:KeyPressed("E", function()
                            main_menu:SetData("type", {type = "boat", index = i})
                            main_menu:Toggle()
                        end)
                    end, false, false)
                end, false, false)
    
                boatZone:RadiusEvents(5.0, nil, function()
                    main_menu:Close()
                end)
            end)
        end
    end
end)

main_menu:IsVisible(function(Items)
    local selectedRental = main_menu:GetData("type")

    if (selectedRental) then
        local rental = Config["Rental"]["Vehicles"][selectedRental.type][selectedRental.index]

        if (rental) then
            for model, value in pairs(rental.model) do
                Items:Button(value, nil, {}, true, {
                    onSelected = function()
                        action_menu:SetData("vehicle", {type = selectedRental.type, index = selectedRental.index, model = model, spawn = rental.spawn})
                    end
                }, action_menu)
            end
        end
    else
        Items:Separator()
        Items:Separator(Shared.Lang:Translate("loading_menu"))
        Items:Separator()
    end
end)

action_menu:IsVisible(function(Items)
    local selectedVehicle = action_menu:GetData("vehicle")

    if (selectedVehicle) then
        local rentalTime = Config["Rental"]["Times"]

        for i = 1, #rentalTime do
            local timeData = rentalTime[i]

            Items:Button(timeData.label, nil, {RightLabel = timeData.price.. " ~g~$~s~"}, true, {
                onSelected = function()
                    TriggerServerEvent("core:rental:rentVehicle", selectedVehicle.type, selectedVehicle.index, selectedVehicle.model, i)
                    main_menu:Close()
                end
            })
        end
    else
        Items:Separator()
        Items:Separator(Shared.Lang:Translate("loading_menu"))
        Items:Separator()
    end
end, nil, function()
    main_menu:SetData("type", nil)
    action_menu:SetData("vehicle", nil)
end)

RegisterNetEvent("core:rental:leaveVehicle", function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local ped = Client.Player:GetPed()

    if DoesEntityExist(vehicle) then
        SetVehicleEngineHealth(vehicle, 0)
        SetVehicleUndriveable(vehicle, true)
        if (IsPedInVehicle(ped, vehicle, true)) then
            TaskLeaveVehicle(Client.Player:GetPed(), vehicle, 0)
            ESX.ShowNotification("Fin de votre location")
        end
    end
end)