local main_menu = RageUI.AddMenu("", "Vespucci Beach Club")

CreateThread(function()
    local BeachClubZone = Game.Zone("BeachClubZone")

    BeachClubZone:Start(function()
        BeachClubZone:SetTimer(1000)
        BeachClubZone:SetCoords(Config["BeachClub"]["BarPos"])

        BeachClubZone:IsPlayerInRadius(8.0, function()
            BeachClubZone:SetTimer(0)
            BeachClubZone:Marker()
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

            BeachClubZone:IsPlayerInRadius(8.0, function()

                BeachClubZone:KeyPressed("E", function()
                    if not IsPedInAnyVehicle(PlayerPedId(), false) then 
                        main_menu:Toggle()
                    else
                        ESX.ShowNotification("Vous ne pouvez pas faire cette action dans un véhicule")
                    end
                end)

            end, false, false)

        end, false, false)

        BeachClubZone:RadiusEvents(5.0, nil, function()
            main_menu:Close()
        end)
    end)

    main_menu:IsVisible(function(Items)
        
        for k, v in pairs(Config["BeachClub"]["Items"]) do
            Items:Button(v.label, nil, {RightLabel = v.price .. "$"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:BeachClub:BuyItems", v.label, v.name, v.price)
                end
            })
        end

    end)

end)