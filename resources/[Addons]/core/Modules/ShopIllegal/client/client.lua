local main_menu = RageUI.AddMenu("", "Vente illégale")

CreateThread(function()

    Game.Peds:Spawn(GetHashKey(Config["ShopIllegal"]["PedModel"]), Config["ShopIllegal"]["PedPos"], Config["ShopIllegal"]["PedHeading"], true, true, function(ped)
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_SEAT_CHAIR", 0, true)
    end)


    local ShopIllegal = Game.Zone("ShopIllegal")

    local ShopIllegalZone = Game.Zone("ShopIllegalZone")

    ShopIllegalZone:Start(function()
        ShopIllegalZone:SetTimer(1000)
        ShopIllegalZone:SetCoords(Config["ShopIllegal"]["PedPos"])

        ShopIllegalZone:IsPlayerInRadius(8.0, function()
            ShopIllegalZone:SetTimer(0)

            ShopIllegalZone:IsPlayerInRadius(3.0, function()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler à Hervé")
                ShopIllegalZone:KeyPressed("E", function()
                    main_menu:Toggle()
                end)

            end, false, false)

        end, false, false)

        ShopIllegalZone:RadiusEvents(3.0, nil, function()
            main_menu:Close()
        end)
    end)

    main_menu:IsVisible(function(Items)
        for k, v in pairs(Config["ShopIllegal"]["Items"]) do
            Items:Button(v.label, v.description, { RightLabel = v.price .. "~r~$~s~" }, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:ShopIllegal:Buy", v.name, v.label, v.price)
                end
            })
        end
    end)

end)