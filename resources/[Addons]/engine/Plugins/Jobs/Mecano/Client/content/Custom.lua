local main_menu = mecanoStorage:Get("custom_menu")
local bill = nil

main_menu:IsVisible(function(Items)
    local selectedCustom = main_menu:GetData("selected_custom")
    
    main_menu:SetClosable(false)
    
    if (selectedCustom) then
        if (selectedCustom.type == "all" or selectedCustom.type == "esthetics") then
            Items:Button("Pare-chocs", "Customisez le pare-choc avant et arrière", {}, true, {}, mecanoStorage:Get("bumper_menu"))
            Items:Button("Chassis", "Customisez l'ossature du véhicule", {}, true, {},  mecanoStorage:Get("chassis_menu"))
            Items:Button("Échappement", "Customisez le pot d'échappement", {}, true, {},  mecanoStorage:Get("exhaust_menu"))
            Items:Button("Calandre", "Améliorez le refroidissement du moteur", {}, true, {},  mecanoStorage:Get("grill_menu"))
            Items:Button("Capot", "Améliorez le système de refroidissement", {}, true, {},  mecanoStorage:Get("hood_menu"))
            Items:Button("Ailes", "Personnalisez les ailes du véhicule", {}, true, {},  mecanoStorage:Get("fender_menu"))
            Items:Button("Rétroviseurs", "Personnalisez les rétroviseurs du véhicule", {}, true, {},  mecanoStorage:Get("mirror_menu"))
            Items:Button("Klaxon", "Personnaliser l'avertisseur sonore", {}, true, {},  mecanoStorage:Get("horn_menu"))
            Items:Button("Eclairage", "Améliorez la visibilité de nuit et l'éclairage décoratif", {}, true, {},  mecanoStorage:Get("lights_menu"))
            Items:Button("Motif", "Modifiez l'apparence du véhicule avec une sélection d'autocollants pour la carrosserie", {}, true, {},  mecanoStorage:Get("pattern_menu"))
            Items:Button("Plaque", "Personnalisez la plaque d'immatriculation", {}, true, {},  mecanoStorage:Get("plate_menu"))
            Items:Button("Peinture", "Modifiez l'apparence du véhicule", {}, true, {},  mecanoStorage:Get("painting_menu"))
            Items:Button("Toit", "Abaissez le centre de gravité du véhicule avec des panneaux de toit légers", {}, true, {},  mecanoStorage:Get("roof_menu"))
            Items:Button("Bas de caisse", "Donnez au véhicule un look d'enfer avec des bas de caisse customisés", {}, true, {},  mecanoStorage:Get("underbody_menu"))
            Items:Button("Aileron", "Augmentez la force d'appui", {}, true, {},  mecanoStorage:Get("spoiler_menu"))
            Items:Button("Roues", "Jantes, pneus et couleurs customisées", {}, true, {},  mecanoStorage:Get("wheels_menu"))
            Items:Button("Vitres", "Teintez les vitres du véhicule", {}, true, {},  mecanoStorage:Get("window_menu"))
        end
        
        if (selectedCustom.type == "all" or selectedCustom.type == "performance") then
            Items:Button("Freins", "Augmenter la puissance des freins et éliminer la perte de freinage", {}, true, {},  mecanoStorage:Get("brake_menu"))
            Items:Button("Moteur", "Augmenter la puissance du moteur", {}, true, {},  mecanoStorage:Get("engine_menu"))
            Items:Button("Suspension", "Montez des suspension sportives sur le véhicule", {}, true, {},  mecanoStorage:Get("suspension_menu"))
            Items:Button("Transmission", "Améliorez l'accélération et optimisez la boîte de vitesse", {}, true, {},  mecanoStorage:Get("transmission_menu"))
            Items:Button("Turbo", "Installez un turbocompresseur performant", {}, true, {},  mecanoStorage:Get("turbo_menu"))
        end

        if (Client.Mecano:getCustomPrices() == 0) then
            Items:Button("Fermer le menu", nil, {}, true, {
                onSelected = function()
                    Client.Mecano:resetDefaultCustomisation()
                end
            })
        else
            Items:Button("Faire une facture", nil, {}, true, {
                onSelected = function()
                    Client.Mecano:requestPercentage()
                end
            }, mecanoStorage:Get("bill_menu"))
        end
    end
end)

mecanoStorage:Get("bill_menu"):IsVisible(function(Items)
    if (not bill and Client.Mecano:getPercentage() ~= nil) then
        local prices = Client.Mecano:getAllPrices()
        local defaultPrice = Client.Mecano:getCustomPrices()
        local finalPrice = defaultPrice + (defaultPrice * (Client.Mecano:getPercentage() / 100))

        for k, v in pairs(prices) do
            Items:Button(v.label, nil, {RightLabel = ("%s ~g~$~s~"):format(Shared.Math:GroupDigits(v.price))}, true, {})
        end

        Items:Button("Envoyer la facture", nil, {}, true, {
            onSelected = function()
                local player, distance = Game.Players:GetClosestPlayer()

                if (player ~= -1 and distance <= 5.0) then
                    bill = price
                    Shared.Events:ToServer(Engine["Enums"].Mecano.Events.sendBill, GetPlayerServerId(player), defaultPrice, Client.Mecano:getPlate())
                else
                    Game.Notification:showNotification("Aucun joueur à proximité", false)
                end
            end
        })

        Items:Line()
        Items:Separator(("Tarif usine : %s ~g~$~s~"):format(Shared.Math:GroupDigits(defaultPrice)).." | "..("Prix final (~bold~%s%%~bold~) : %s ~g~$~s~"):format(Client.Mecano:getPercentage(), Shared.Math:GroupDigits(finalPrice)))
    else
        Items:Separator("En attente de la facture...")
    end
end)

mecanoStorage:Get("bumper_menu"):IsVisible(function(Items)
    Items:Button("Pare-Chocs avant", nil, {}, true, {}, mecanoStorage:Get("bumper_menu_front"))
    Items:Button("Pare-Chocs arrière", nil, {}, true, {}, mecanoStorage:Get("bumper_menu_back"))
end)

mecanoStorage:Get("bumper_menu_front"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontBumper)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontBumper)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontBumper")
    local price = Client.Mecano:getPriceForCustomisation("bumperFront")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontBumper, -1, false)
                    Client.Mecano:addPriceForCustomisation("modFrontBumper", -1, price, "Pare-chocs avant")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontBumper, i)
            local modName = GetLabelText(modLabel)
            
            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            if (modName == "NULL") then
                modName = "Pare-chocs #"..i
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontBumper, i, false)
                        Client.Mecano:addPriceForCustomisation("modFrontBumper", i, price, "Pare-chocs avant")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de pare-chocs avant disponible")
    end
end)

mecanoStorage:Get("bumper_menu_back"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modRearBumper)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRearBumper)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modRearBumper")
    local price = Client.Mecano:getPriceForCustomisation("bumperBack")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        }, 
        true, 
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRearBumper, -1, false)
                    Client.Mecano:addPriceForCustomisation("modRearBumper", -1, price, "Pare-chocs arrière")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modRearBumper, i)
            local modName = GetLabelText(modLabel)

            if (modName == "NULL") then
                modName = "Pare-chocs #"..i
            end

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end
            
            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRearBumper, i, false)
                        Client.Mecano:addPriceForCustomisation("modRearBumper", i, price, "Pare-chocs arrière")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de pare-chocs arrière disponible")
    end
end)

mecanoStorage:Get("chassis_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modChassis)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modChassis)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrame")
    local price = Client.Mecano:getPriceForCustomisation("chassis")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modChassis, -1, false)
                    Client.Mecano:addPriceForCustomisation("modFrame", -1, price, "Chassis")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modChassis, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modChassis, i, false)
                        Client.Mecano:addPriceForCustomisation("modFrame", i, price, "Chassis")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de chassis disponible")
    end
end)

mecanoStorage:Get("exhaust_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modExhaust)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modExhaust)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modExhaust")
    local price = Client.Mecano:getPriceForCustomisation("exhaust")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modExhaust, -1, false)
                    Client.Mecano:addPriceForCustomisation("modExhaust", -1, price, "Échappement")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modExhaust, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modExhaust, i, false)
                        Client.Mecano:addPriceForCustomisation("modExhaust", i, price, "Échappement")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification d'échappement disponible")
    end
end)

mecanoStorage:Get("grill_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modGrill)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modGrill)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modGrille")
    local price = Client.Mecano:getPriceForCustomisation("grill")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modGrill, -1, false)
                    Client.Mecano:addPriceForCustomisation("modGrille", -1, price, "Calandre")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modGrill, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modGrill, i, false)
                        Client.Mecano:addPriceForCustomisation("modGrille", i, price, "Calandre")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de calandre disponible")
    end
end)

mecanoStorage:Get("hood_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modHood)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modHood)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modHood")
    local price = Client.Mecano:getPriceForCustomisation("hood")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modHood, -1, false)
                    Client.Mecano:addPriceForCustomisation("modHood", -1, price, "Capot")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modHood, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modHood, i, false)
                        Client.Mecano:addPriceForCustomisation("modHood", i, price, "Capot")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de capot disponible")
    end
end)

mecanoStorage:Get("fender_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modFender)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFender)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFender")
    local price = Client.Mecano:getPriceForCustomisation("fender")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFender, -1, false)
                    Client.Mecano:addPriceForCustomisation("modFender", -1, price, "Ailes")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modFender, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFender, i, false)
                        Client.Mecano:addPriceForCustomisation("modFender", i, price, "Ailes")
                    end
                end
            })
        end

    else
        Items:Separator("Aucune modification d'ailes disponible")
    end
end)

mecanoStorage:Get("mirror_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modRightFender)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRightFender)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modRightFender")
    local price = Client.Mecano:getPriceForCustomisation("mirror")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRightFender, -1, false)
                    Client.Mecano:addPriceForCustomisation("modRightFender", -1, price, "Rétroviseurs")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modRightFender, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRightFender, i, false)
                        Client.Mecano:addPriceForCustomisation("modRightFender", i, price, "Rétroviseurs")
                    end
                end
            })
        end

    else
        Items:Separator("Aucune modification de rétroviseurs disponible")
    end
end)

mecanoStorage:Get("horn_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modHorn)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modHorn)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modHorns")
    local price = Client.Mecano:getPriceForCustomisation("horn")

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            if (currentMod ~= -1) then
                SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modHorn, -1, false)
                Client.Mecano:addPriceForCustomisation("modHorns", -1, price, "Klaxon")
            end
        end
    })

    for i = 0, 35 - 1 do
        local horns = Engine["Enums"].Vehicles.Horn
        local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modHorn, i)
        local modName = GetLabelText(modLabel)

        if (modName == "NULL") then
            modName = horns[i]
        end

        Items:Button(modName, nil,
        {
            RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= i) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modHorn, i, false)
                    Client.Mecano:addPriceForCustomisation("modHorns", i, price, "Klaxon")
                end
            end
        })
    end
end)

mecanoStorage:Get("lights_menu"):IsVisible(function(Items)
    Items:Button("Phares", nil, {}, true, {}, mecanoStorage:Get("xenon_menu"))
    Items:Button("Kits néon", nil, {}, true, {}, mecanoStorage:Get("neon_menu"))
end)


mecanoStorage:Get("xenon_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentMod = IsToggleModOn(vehicle, Engine["Enums"].Vehicles.Customisation.modXenon)
    local currentColor = GetVehicleXenonLightsColor(vehicle)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modXenon")
    local defaultCustomColor = Client.Mecano:getDefaultCustomisationByType("xenonColor")
    local price = Client.Mecano:getPriceForCustomisation("xenon")

    SetVehicleLights(vehicle, 3)

    Items:Button("Phares de série", nil,
    {
        RightBadge = (currentMod == false) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentMod ~= false) and ("%s ~g~$~s~"):format(defaultCustom == false and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            if (currentMod ~= false) then
                ToggleVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modXenon, false)
                Client.Mecano:removePriceForCustomisation("xenonColor")
                Client.Mecano:addPriceForCustomisation("modXenon", false, price, "Phares de série")
                
                if (defaultCustom == false) then
                    Client.Mecano:removePriceForCustomisation("modXenon")
                end
            end
        end
    })
    Items:Button("Phares au xénon", nil,
    {
        RightBadge = (currentMod == 1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentMod ~= 1) and ("%s ~g~$~s~"):format(defaultCustom == 1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            if (currentMod ~= 1) then
                ToggleVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modXenon, true)
                SetVehicleXenonLightsColour(vehicle, currentColor)
                Client.Mecano:editDefaultCustomisation("modXenon", 2)
                Client.Mecano:addPriceForCustomisation("modXenon", 1, price, "Phares au xénon")

                if (defaultCustom == 1) then
                    Client.Mecano:removePriceForCustomisation("modXenon")
                end
            end
        end
    })

    if (currentMod == 1) then
        local xenonColor = Engine["Enums"].Vehicles.XenonColor
        Items:Line()

        for i = 1, #xenonColor do
            local colorName = xenonColor[i].label
            local colorId = xenonColor[i].value

            Items:Button(colorName, nil,
            {
                RightBadge = (currentColor == colorId) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentColor ~= colorId) and ("%s ~g~$~s~"):format(defaultCustomColor == colorId and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentColor ~= colorId) then
                        SetVehicleXenonLightsColour(vehicle, colorId)
                        Client.Mecano:addPriceForCustomisation("xenonColor", colorId, price, "Phares de couleur")
                    end
                end
            })
        end
    end
end)

mecanoStorage:Get("neon_menu"):IsVisible(function(Items)
    Items:Button("Support néon", nil, {}, true, {}, mecanoStorage:Get("neon_support_menu"))
    Items:Button("Couleur néon", nil, {}, true, {}, mecanoStorage:Get("neon_color_menu"))
end)

mecanoStorage:Get("neon_support_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local neonStates = Game.Vehicle:GetNeonState(vehicle)
    local neonSupportType = Engine["Enums"].Vehicles.NeonSupportType
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("neonEnabled")
    local price = Client.Mecano:getPriceForCustomisation("neon_support")

    local function GetBadgeState(left, right, front, back)
        return left == neonStates.Left and right == neonStates.Right and front == neonStates.Front and back == neonStates.Back and RageUI.BadgeStyle.Car or nil
    end

    Items:Button("Aucun", nil,
    {
        RightBadge = GetBadgeState(false, false, false, false),
        RightLabel = GetBadgeState(false, false, false, false) == nil and ("%s ~g~$~s~"):format(
            (defaultCustom[1] == false and defaultCustom[2] == false and defaultCustom[3] == false and defaultCustom[4] == false) and 0 or Shared.Math:GroupDigits(price[0])
        )
    },
    true,
    {
        onSelected = function()
            if (neonStates.Left ~= false or neonStates.Right ~= false or neonStates.Front ~= false or neonStates.Back ~= false) then
                SetVehicleNeonLightEnabled(vehicle, 0, false)
                SetVehicleNeonLightEnabled(vehicle, 1, false)
                SetVehicleNeonLightEnabled(vehicle, 2, false)
                SetVehicleNeonLightEnabled(vehicle, 3, false)
                Client.Mecano:removePriceForCustomisation("neonColor")
                Client.Mecano:addPriceForCustomisation("neonEnabled", {false, false, false, false}, price[0], "Support néon")

                if (defaultCustom[1] == false and defaultCustom[2] == false and defaultCustom[3] == false and defaultCustom[4] == false) then
                    Client.Mecano:removePriceForCustomisation("neonEnabled")
                end
            end
        end
    })

    for i = 1, #neonSupportType do
        local neonTypeName = neonSupportType[i].label
        local neonTypeId = neonSupportType[i].value
        local left = neonSupportType[i].left == true and 1 or false
        local right = neonSupportType[i].right == true and 1 or false
        local front = neonSupportType[i].front == true and 1 or false
        local back = neonSupportType[i].back == true and 1 or false

        if (i <= 2) then
            price[i] = Shared.Math:Round(price[i] * Client.Mecano:getMultiplier(), 0)
        else
            price[i] = Shared.Math:Round(price[i] * 1.007, 0)
        end

        Items:Button(neonTypeName, nil,
        {
            RightBadge = GetBadgeState(left, right, front, back),
            RightLabel = GetBadgeState(left, right, front, back) == nil and ("%s ~g~$~s~"):format(
                (defaultCustom[1] == left and defaultCustom[2] == right and defaultCustom[3] == front and defaultCustom[4] == back) and 0
                or Shared.Math:GroupDigits(price[i])
            )
        },
        true,
        {
            onSelected = function()
                if (left ~= neonStates.Left or right ~= neonStates.Right or front ~= neonStates.Front or back ~= neonStates.Back) then
                    SetVehicleNeonLightEnabled(vehicle, 0, left)
                    SetVehicleNeonLightEnabled(vehicle, 1, right)
                    SetVehicleNeonLightEnabled(vehicle, 2, front)
                    SetVehicleNeonLightEnabled(vehicle, 3, back)
                    SetVehicleNeonLightsColour(vehicle, 255, 255, 255)
                    Client.Mecano:editDefaultCustomisation("neonColor", {255, 255, 255})
                    Client.Mecano:addPriceForCustomisation("neonEnabled", {left, right, front, back}, price[i], "Support néon")

                    if (defaultCustom[1] == left and defaultCustom[2] == right and defaultCustom[3] == front and defaultCustom[4] == back) then
                        Client.Mecano:removePriceForCustomisation("neonEnabled")
                    end
                end
            end
        })
    end
end)

mecanoStorage:Get("neon_color_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local neonStates = Game.Vehicle:GetNeonState(vehicle)
    local neonColor = Engine["Enums"].Vehicles.NeonColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("neonColor")
    local price = Client.Mecano:getPriceForCustomisation("neonColor")

    if (neonStates.Left or neonStates.Right or neonStates.Front or neonStates.Back) then
        local function GetColorBadge(r, g, b)
            local currentColorRed, currentColorGreen, currentColorBlue = GetVehicleNeonLightsColour(vehicle)
            return currentColorRed == r and currentColorGreen == g and currentColorBlue == b and RageUI.BadgeStyle.Car or nil
        end

        for i = 1, #neonColor do
            local colorName = neonColor[i].label
            local colorId = neonColor[i].value
            local red = neonColor[i].red
            local green = neonColor[i].green
            local blue = neonColor[i].blue

            Items:Button(colorName, nil,
            {
                RightBadge = GetColorBadge(red, green, blue),
                RightLabel = GetColorBadge(red, green, blue) == nil and ("%s ~g~$~s~"):format(
                    (defaultCustom[1] == red and defaultCustom[2] == green and defaultCustom[3] == blue) and 0
                    or Shared.Math:GroupDigits(price)
                )
            },
            true,
            {
                onSelected = function()
                    if (red ~= neonStates.Red or green ~= neonStates.Green or blue ~= neonStates.Blue) then
                        SetVehicleNeonLightsColour(vehicle, red, green, blue)
                        Client.Mecano:addPriceForCustomisation("neonColor", {red, green, blue}, price, "Couleur néon")

                        if (defaultCustom[1] == red and defaultCustom[2] == green and defaultCustom[3] == blue) then
                            Client.Mecano:removePriceForCustomisation("neonColor")
                        end
                    end
                end
            })
        end
    else
        Items:Separator("Aucun support néon est installé")
    end
end)

mecanoStorage:Get("pattern_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modLivery)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modLivery)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modLivery")
    local price = Client.Mecano:getPriceForCustomisation("pattern")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modLivery, -1, false)
                    Client.Mecano:addPriceForCustomisation("modLivery", -1, price, "Motif")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modLivery, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modLivery, i, false)
                        Client.Mecano:addPriceForCustomisation("modLivery", i, price, "Motif")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de motif disponible")
    end
end)

mecanoStorage:Get("plate_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentPlate = GetVehicleNumberPlateTextIndex(vehicle)
    local plateType = Engine["Enums"].Vehicles.PlateType
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("plateIndex")
    local price = Client.Mecano:getPriceForCustomisation("plate")

    for i = 1, #plateType do
        local plateTypeName = plateType[i].label
        local plateTypeId = plateType[i].value

        if (i <= 2) then
            price[i] = Shared.Math:Round(price[i] * Client.Mecano:getMultiplier(), 0)
        else
            price[i] = Shared.Math:Round(price[i] * 1.007, 0)
        end

        Items:Button(plateTypeName, nil,
        {
            RightBadge = (currentPlate == plateTypeId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentPlate ~= plateTypeId) and ("%s ~g~$~s~"):format(defaultCustom == plateTypeId and 0 or Shared.Math:GroupDigits(price[i]))
        },
        true,
        {
            onSelected = function()
                if (currentPlate ~= plateTypeId) then
                    SetVehicleNumberPlateTextIndex(vehicle, plateTypeId)
                    Client.Mecano:addPriceForCustomisation("plateIndex", plateTypeId, price[i], "Plaque d'immatriculation")
                end
            end
        })
    end
end)

local lastViewMode = 0

mecanoStorage:Get("painting_menu"):IsVisible(function(Items)
    Items:Button("Couleur principale", nil, {}, true, {}, mecanoStorage:Get("primary_color_menu"))
    Items:Button("Couleur secondaire", nil, {}, true, {}, mecanoStorage:Get("secondary_color_menu"))
    Items:Button("Couleur finitions", nil, {}, true, {
        onSelected = function()
            lastViewMode = GetFollowPedCamViewMode()
        end
    }, mecanoStorage:Get("finishing_color_menu"))
end)

mecanoStorage:Get("primary_color_menu"):IsVisible(function(Items)
    Items:Button("Classique", nil, {}, true, {}, mecanoStorage:Get("primary_color_menu_classic"))
    Items:Button("Mat", nil, {}, true, {}, mecanoStorage:Get("primary_color_menu_mat"))
    Items:Button("Métalisé", nil, {}, true, {}, mecanoStorage:Get("primary_color_menu_metallic"))
    Items:Button("Métaux", nil, {}, true, {}, mecanoStorage:Get("primary_color_menu_metals"))
    Items:Button("Nacré", nil, {}, true, {}, mecanoStorage:Get("primary_color_menu_pearl"))
end)

mecanoStorage:Get("secondary_color_menu"):IsVisible(function(Items)
    Items:Button("Classique", nil, {}, true, {}, mecanoStorage:Get("secondary_color_menu_classic"))
    Items:Button("Mat", nil, {}, true, {}, mecanoStorage:Get("secondary_color_menu_mat"))
    Items:Button("Métalisé", nil, {}, true, {}, mecanoStorage:Get("secondary_color_menu_metallic"))
    Items:Button("Métaux", nil, {}, true, {}, mecanoStorage:Get("secondary_color_menu_metals"))
end)

mecanoStorage:Get("primary_color_menu_classic"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color1")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[1]

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorPrimary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorPrimary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorPrimary ~= colorId) then
                    ClearVehicleCustomPrimaryColour(vehicle)
                    SetVehicleColours(vehicle, colorId, vehicleColorSecondary)
                    Client.Mecano:addPriceForCustomisation("color1", colorId, price, "Couleur principale")
                end
            end
        })
    end
end)

mecanoStorage:Get("primary_color_menu_mat"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local matColor = Engine["Enums"].Vehicles.MatColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color1")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[2]

    for colorName, colorId in pairs(matColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorPrimary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorPrimary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorPrimary ~= colorId) then
                    ClearVehicleCustomPrimaryColour(vehicle)
                    SetVehicleColours(vehicle, colorId, vehicleColorSecondary)
                    Client.Mecano:addPriceForCustomisation("color1", colorId, price, "Couleur principale")
                end
            end
        })
    end
end)

mecanoStorage:Get("primary_color_menu_metallic"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color1")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[3]

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorPrimary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorPrimary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorPrimary ~= colorId) then
                    ClearVehicleCustomPrimaryColour(vehicle)
                    SetVehicleColours(vehicle, colorId, vehicleColorSecondary)
                    SetVehicleExtraColours(vehicle, vehicleColorSecondary, wheelColor)
                    Client.Mecano:addPriceForCustomisation("color1", colorId, price, "Couleur principale")
                end
            end
        })
    end
end)

mecanoStorage:Get("primary_color_menu_metals"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local metalsColor = Engine["Enums"].Vehicles.MetalsColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color1")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[4]

    for colorName, colorId in pairs(metalsColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorPrimary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorPrimary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorPrimary ~= colorId) then
                    ClearVehicleCustomPrimaryColour(vehicle)
                    SetVehicleColours(vehicle, colorId, vehicleColorSecondary)
                    Client.Mecano:addPriceForCustomisation("color1", colorId, price, "Couleur principale")
                end
            end
        })
    end
end)

mecanoStorage:Get("primary_color_menu_pearl"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("pearlescentColor")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[5]

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (pearlescentColor == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (pearlescentColor ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (pearlescentColor ~= colorId) then
                    SetVehicleExtraColours(vehicle, colorId, wheelColor)
                    Client.Mecano:addPriceForCustomisation("pearlescentColor", colorId, price, "Couleur nacrée")
                end
            end
        })
    end
end)

mecanoStorage:Get("secondary_color_menu_classic"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color2")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[1]

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorSecondary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorSecondary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorSecondary ~= colorId) then
                    ClearVehicleCustomSecondaryColour(vehicle)
                    SetVehicleColours(vehicle, vehicleColorPrimary, colorId)
                    Client.Mecano:addPriceForCustomisation("color2", colorId, price, "Couleur secondaire")
                end
            end
        })
    end
end)

mecanoStorage:Get("secondary_color_menu_mat"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local matColor = Engine["Enums"].Vehicles.MatColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color2")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[2]

    for colorName, colorId in pairs(matColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorSecondary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorSecondary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorSecondary ~= colorId) then
                    ClearVehicleCustomSecondaryColour(vehicle)
                    SetVehicleColours(vehicle, vehicleColorPrimary, colorId)
                    Client.Mecano:addPriceForCustomisation("color2", colorId, price, "Couleur secondaire")
                end
            end
        })
    end
end)

mecanoStorage:Get("secondary_color_menu_metallic"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color2")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[3]

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorSecondary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorSecondary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorSecondary ~= colorId) then
                    ClearVehicleCustomSecondaryColour(vehicle)
                    SetVehicleColours(vehicle, vehicleColorPrimary, colorId)
                    SetVehicleExtraColours(vehicle, vehicleColorSecondary, -1)
                    Client.Mecano:addPriceForCustomisation("color2", colorId, price, "Couleur secondaire")
                end
            end
        })
    end
end)

mecanoStorage:Get("secondary_color_menu_metals"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local vehicleColorPrimary, vehicleColorSecondary = GetVehicleColours(vehicle)
    local metalsColor = Engine["Enums"].Vehicles.MetalsColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("color2")
    local price = Client.Mecano:getPriceForCustomisation("primaryColor")[4]

    for colorName, colorId in pairs(metalsColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (vehicleColorSecondary == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (vehicleColorSecondary ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (vehicleColorSecondary ~= colorId) then
                    ClearVehicleCustomSecondaryColour(vehicle)
                    SetVehicleColours(vehicle, vehicleColorPrimary, colorId)
                    Client.Mecano:addPriceForCustomisation("color2", colorId, price, "Couleur secondaire")
                end
            end
        })
    end
end)

mecanoStorage:Get("finishing_color_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local color = GetVehicleInteriorColor(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("interiorColor")
    local price = Client.Mecano:getPriceForCustomisation("finishingColor")

    SetCamViewModeForContext(1, 4)

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (color == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (color ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (color ~= colorId) then
                    SetVehicleInteriorColor(vehicle, colorId)
                    Client.Mecano:addPriceForCustomisation("interiorColor", colorId, price, "Couleur intérieur")
                end
            end
        })
    end
end, nil, function()
    SetCamViewModeForContext(1, lastViewMode)
end)

mecanoStorage:Get("roof_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modRoof)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRoof)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modRoof")
    local price = Client.Mecano:getPriceForCustomisation("roof")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRoof, -1, false)
                    Client.Mecano:addPriceForCustomisation("modRoof", -1, price, "Toit")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modRoof, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 0.5, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modRoof, i, false)
                        Client.Mecano:addPriceForCustomisation("modRoof", i, price, "Toit")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de toit disponible")
    end
end)

mecanoStorage:Get("underbody_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modSideSkirt)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSideSkirt)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modSideSkirt")
    local price = Client.Mecano:getPriceForCustomisation("sideSkirt")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSideSkirt, -1, false)
                    Client.Mecano:addPriceForCustomisation("modSideSkirt", -1, price, "Bas de caisse")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modSideSkirt, i)
            local modName = GetLabelText(modLabel)

            if (modName == "NULL") then
                modName = "Bas de caisse #"..i
            end

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSideSkirt, i, false)
                        Client.Mecano:addPriceForCustomisation("modSideSkirt", i, price, "Bas de caisse")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de bas de caisse disponible")
    end
end)

mecanoStorage:Get("spoiler_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local numMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modSpoiler)
    local currentMod = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSpoiler)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modSpoilers")
    local price = Client.Mecano:getPriceForCustomisation("spoiler")

    if (numMods > 0) then
        Items:Button("Par défaut", nil,
        {
            RightBadge = (currentMod == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentMod ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (currentMod ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSpoiler, -1, false)
                    Client.Mecano:addPriceForCustomisation("modSpoilers", -1, price, "Spoiler")
                end
            end
        })

        for i = 0, numMods - 1 do
            local modLabel = GetModTextLabel(vehicle, Engine["Enums"].Vehicles.Customisation.modSpoiler, i)
            local modName = GetLabelText(modLabel)

            if (i <= 2) then
                price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
            else
                price = Shared.Math:Round(price * 1.007, 0)
            end

            Items:Button(modName, nil,
            {
                RightBadge = (currentMod == i) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentMod ~= i) and ("%s ~g~$~s~"):format(defaultCustom == i and 0 or Shared.Math:GroupDigits(price))
            },
            true,
            {
                onSelected = function()
                    if (currentMod ~= i) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSpoiler, i, false)
                        Client.Mecano:addPriceForCustomisation("modSpoilers", i, price, "Spoiler")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de spoiler disponible")
    end
end)

mecanoStorage:Get("wheels_menu"):IsVisible(function(Items)
    Items:Button("Type de roue", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu"))
    Items:Button("Couleur des jantes", nil, {}, true, {}, mecanoStorage:Get("wheels_color_menu"))
    Items:Button("Fumée des pneus", nil, {}, true, {},mecanoStorage:Get("wheels_fume_menu"))
end)

mecanoStorage:Get("wheels_type_menu"):IsVisible(function(Items)
    Items:Button("Haut de gamme", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_high"))
    Items:Button("Lowrider", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_lowrider"))
    Items:Button("Muscle car", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_muscle"))
    Items:Button("Tout-terrain", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_offroad"))
    Items:Button("Sport", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_sport"))
    Items:Button("SUV", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_suv"))
    Items:Button("Tunning", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_tunning"))
    Items:Button("De rue", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_street"))
    Items:Button("Circuit", nil, {}, true, {}, mecanoStorage:Get("wheels_type_menu_track"))
end)

mecanoStorage:Get("wheels_type_menu_high"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local HighEndWheels = Engine["Enums"].Vehicles.HighEndWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[1]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(7, -1, price, "Roues haut de gamme")
        end
    })

    for i, wheel in ipairs(HighEndWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 7) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 7) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 7 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 7) then
                    SetVehicleWheelType(vehicle, 7)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(7, wheel.id, price, "Roues haut de gamme")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_lowrider"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local LowriderWheels = Engine["Enums"].Vehicles.LowriderWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[2]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(2, -1, price, "Roues Lowrider")
        end
    })

    for i, wheel in ipairs(LowriderWheels) do
        if (i <= 2) then
            price = Shared.Math:Round(price * Client.Mecano:getMultiplier(), 0)
        else
            price = Shared.Math:Round(price * 1.007, 0)
        end

        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 2) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 2) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 2 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 2) then
                    SetVehicleWheelType(vehicle, 2)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(2, wheel.id, price, "Roues Lowrider")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_muscle"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local MuscleCarWheels = Engine["Enums"].Vehicles.MuscleCarWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[3]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(1, -1, price, "Roues Muscle car")
        end
    })

    for i, wheel in ipairs(MuscleCarWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 1) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 1 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 1) then
                    SetVehicleWheelType(vehicle, 1)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(1, wheel.id, price, "Roues Muscle car")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_offroad"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local OffRoadWheels = Engine["Enums"].Vehicles.OffRoadWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[4]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(4, -1, price, "Roues Tout-terrain")
        end
    })

    for i, wheel in ipairs(OffRoadWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 4) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 4) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 4 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 4) then
                    SetVehicleWheelType(vehicle, 4)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(4, wheel.id, price, "Roues Tout-terrain")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_sport"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local SportWheels = Engine["Enums"].Vehicles.SportWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[5]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(0, -1, price, "Roues Sport")
        end
    })

    for i, wheel in ipairs(SportWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 0) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 0) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 0 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 0) then
                    SetVehicleWheelType(vehicle, 0)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(0, wheel.id, price, "Roues Sport")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_suv"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local SuvWheels = Engine["Enums"].Vehicles.SuvWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[6]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(3, -1, price, "Roues SUV")
        end
    })

    for i, wheel in ipairs(SuvWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 3) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 3) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 3 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 3) then
                    SetVehicleWheelType(vehicle, 3)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(3, wheel.id, price, "Roues SUV")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_tunning"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local tunningWheels = Engine["Enums"].Vehicles.TunningWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[7]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(5, -1, price, "Roues haut de gamme")
        end
    })

    for i, wheel in ipairs(tunningWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 5) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 5) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 5 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 5) then
                    SetVehicleWheelType(vehicle, 5)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(5, wheel.id, price, "Roues haut de gamme")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_street"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local StreetWheels = Engine["Enums"].Vehicles.StreetWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[8]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(11, -1, price, "Roues Street")
        end
    })

    for i, wheel in ipairs(StreetWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 11) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 11) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 11 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 11) then
                    SetVehicleWheelType(vehicle, 11)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(11, wheel.id, price, "Roues Street")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_type_menu_track"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentWheel = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local currentWheelType = GetVehicleWheelType(vehicle)
    local TrackWheels = Engine["Enums"].Vehicles.TrackWheels
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modFrontWheels")
    local defaultWheelsType = Client.Mecano:getDefaultCustomisationByType("wheels")
    local price = Client.Mecano:getPriceForCustomisation("wheels")[9]

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheel == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheel ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForWheels(12, -1, price, "Roues Track")
        end
    })

    for i, wheel in ipairs(TrackWheels) do
        Items:Button(wheel.name, nil,
        {
            RightBadge = (currentWheel == wheel.id and currentWheelType == 12) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentWheel ~= wheel.id or currentWheelType ~= 12) and ("%s ~g~$~s~"):format(
                (defaultWheelsType == 12 and defaultCustom == wheel.id) and 0 or Shared.Math:GroupDigits(price)
            )
        },
        true,
        {
            onSelected = function()
                if (currentWheel ~= wheel.id or currentWheelType ~= 12) then
                    SetVehicleWheelType(vehicle, 12)
                    SetVehicleMod(vehicle, 23, wheel.id, false)
                    Client.Mecano:addPriceForWheels(12, wheel.id, price, "Roues Track")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_color_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local classicColor = Engine["Enums"].Vehicles.ClassicColor
    local currentWheelType = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modFrontWheels)
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("wheelColor")
    local price = Client.Mecano:getPriceForCustomisation("wheels_color")

    Items:Button("Par défaut", nil,
    {
        RightBadge = (currentWheelType == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentWheelType ~= -1) and ("%s ~g~$~s~"):format(defaultCustom == -1 and 0 or Shared.Math:GroupDigits(price))
    },
    true,
    {
        onSelected = function()
            SetVehicleMod(vehicle, 23, -1, false)
            Client.Mecano:addPriceForCustomisation("modFrontWheels", -1, 0, "Couleur des roues")
        end
    })

    for colorName, colorId in pairs(classicColor) do
        Items:Button(colorName, nil,
        {
            RightBadge = (wheelColor == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (wheelColor ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price))
        },
        true,
        {
            onSelected = function()
                if (wheelColor ~= colorId) then
                    SetVehicleExtraColours(vehicle, pearlescentColor, colorId)
                    Client.Mecano:addPriceForCustomisation("wheelColor", colorId, price, "Couleur des roues")
                end
            end
        })
    end
end)

mecanoStorage:Get("wheels_fume_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentFume = GetVehicleTyreSmokeColor(vehicle)
    local wheelsFumes = Engine["Enums"].Vehicles.WheelsFumes
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("tyreSmokeColor")
    local price = Client.Mecano:getPriceForCustomisation("wheels_fume")

    local function GetColorBadge(r, g, b)
        local currentFumeRed, currentFumeGreen, currentFumeBlue = GetVehicleTyreSmokeColor(vehicle)
        return currentFumeRed == r and currentFumeGreen == g and currentFumeBlue == b and RageUI.BadgeStyle.Car or nil
    end

    Items:Button("Par défaut", nil,
    {
        RightBadge = GetColorBadge(255, 255, 255),
        RightLabel = (GetColorBadge(255, 255, 255) == nil) and ("%s ~g~$~s~"):format(
            defaultCustom[1] == 255 and defaultCustom[2] == 255 and defaultCustom[3] == 255 and 0
            or Shared.Math:GroupDigits(price)
        )
    },
    true,
    {
        onSelected = function()
            if (currentFume ~= {255, 255, 255}) then
                SetVehicleTyreSmokeColor(vehicle, 255, 255, 255)
                Client.Mecano:addPriceForCustomisation("tyreSmokeColor", {255, 255, 255}, price, "Fumée des pneus")

                if (defaultCustom[1] == 255 and defaultCustom[2] == 255 and defaultCustom[3] == 255) then
                    Client.Mecano:removePriceForCustomisation("tyreSmokeColor")
                end
            end
        end
    })

    for colorName, colorId in pairs(wheelsFumes) do
        Items:Button(colorName, nil,
        {
            RightBadge = GetColorBadge(colorId[1], colorId[2], colorId[3]),
            RightLabel = (GetColorBadge(colorId[1], colorId[2], colorId[3]) == nil) and ("%s ~g~$~s~"):format(
                defaultCustom[1] == colorId[1] and defaultCustom[2] == colorId[2] and defaultCustom[3] == colorId[3] and 0
                or Shared.Math:GroupDigits(price)
            )

        },
        true,
        {
            onSelected = function()
                if (currentFume ~= colorId) then
                    SetVehicleTyreSmokeColor(vehicle, colorId[1], colorId[2], colorId[3])
                    Client.Mecano:addPriceForCustomisation("tyreSmokeColor", {colorId[1], colorId[2], colorId[3]}, price, "Fumée des pneus")

                    if (defaultCustom[1] == colorId[1] and defaultCustom[2] == colorId[2] and defaultCustom[3] == colorId[3]) then
                        Client.Mecano:removePriceForCustomisation("tyreSmokeColor")
                    end
                end
            end
        })
    end
end)

mecanoStorage:Get("window_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentColor = GetVehicleWindowTint(vehicle)
    local windowColor = Engine["Enums"].Vehicles.WindowColor
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("windowTint")
    local price = Client.Mecano:getPriceForCustomisation("window")

    if (defaultCustom == -1) then
        defaultCustom = 0
    end

    if (currentColor == -1) then
        currentColor = 0
    end

    Items:Button("Aucune", nil,
    {
        RightBadge = (currentColor == 0 or currentColor == -1) and RageUI.BadgeStyle.Car or nil,
        RightLabel = (currentColor ~= 0) and ("%s ~g~$~s~"):format((defaultCustom == 0) and 0 or Shared.Math:GroupDigits(price[0]))
    },
    true,
    {
        onSelected = function()
            if (currentColor ~= 0 and currentColor ~= -1) then
                SetVehicleWindowTint(vehicle, 0)
                Client.Mecano:addPriceForCustomisation("windowTint", 0, price[0], "Teinte des vitres")
            end
        end
    })

    for i = 1, #windowColor do
        local colorName = windowColor[i].label
        local colorId = windowColor[i].value

        Items:Button(colorName, nil,
        {
            RightBadge = (currentColor == colorId) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentColor ~= colorId) and ("%s ~g~$~s~"):format(defaultCustom == colorId and 0 or Shared.Math:GroupDigits(price[i]))
        },
        true,
        {
            onSelected = function()
                if (currentColor ~= colorId) then
                    SetVehicleWindowTint(vehicle, colorId)
                    Client.Mecano:addPriceForCustomisation("windowTint", colorId, price[i], "Teinte des vitres")
                end
            end
        })
    end
end)

mecanoStorage:Get("brake_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentBrake = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modBrakes)
    local GetNumVehicleMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modBrakes)
    local brakeType = Engine["Enums"].Vehicles.BrakeType
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modBrakes")
    local price = Client.Mecano:getPriceForCustomisation("brake")

    if (GetNumVehicleMods > 0) then
        Items:Button("Freins de série", nil,
        {
            RightBadge = (currentBrake == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentBrake ~= -1) and ("%s ~g~$~s~"):format((defaultCustom == -1) and 0 or Shared.Math:GroupDigits(price[0]))
        },
        true,
        {
            onSelected = function()
                if (currentBrake ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modBrakes, -1)
                    Client.Mecano:addPriceForCustomisation("modBrakes", -1, price[0], "Freins")
                end
            end
        })

        for i = 1, #brakeType do
            local brakeTypeName = brakeType[i].label
            local brakeTypeId = brakeType[i].value

            if (i <= 2) then
                price[i] = Shared.Math:Round(price[i] * Client.Mecano:getMultiplier(), 0)
            else
                price[i] = Shared.Math:Round(price[i] * 1.007, 0)
            end

            Items:Button(brakeTypeName, nil,
            {
                RightBadge = (currentBrake == brakeTypeId) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentBrake ~= brakeTypeId) and ("%s ~g~$~s~"):format(defaultCustom == brakeTypeId and 0 or Shared.Math:GroupDigits(price[i]))
            },
            true,
            {
                onSelected = function()
                    if (currentBrake ~= brakeTypeId) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modBrakes, brakeTypeId)
                        Client.Mecano:addPriceForCustomisation("modBrakes", brakeTypeId, price[i], "Freins")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de freins disponible")
    end
end)

mecanoStorage:Get("engine_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentEngine = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modEngine)
    local GetNumVehicleMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modEngine)
    local engineType = Engine["Enums"].Vehicles.EngineType
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modEngine")
    local price = Client.Mecano:getPriceForCustomisation("engine")

    if (GetNumVehicleMods > 0) then
        Items:Button("Reprog moteur Niv. 1", nil,
        {
            RightBadge = (currentEngine == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentEngine ~= -1) and ("%s ~g~$~s~"):format((defaultCustom == -1) and 0 or Shared.Math:GroupDigits(price[0]))
        },
        true,
        {
            onSelected = function()
                if (currentEngine ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modEngine, -1)
                    Client.Mecano:addPriceForCustomisation("modEngine", -1, price[0], "Moteur")
                end
            end
        })

        for i = 1, #engineType do
            local engineTypeName = engineType[i].label
            local engineTypeId = engineType[i].value

            if (i <= 2) then
                price[i] = Shared.Math:Round(price[i] * Client.Mecano:getMultiplier(), 0)
            else
                price[i] = Shared.Math:Round(price[i] * 1.007, 0)
            end

            Items:Button(engineTypeName, nil,
            {
                RightBadge = (currentEngine == engineTypeId) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentEngine ~= engineTypeId) and ("%s ~g~$~s~"):format(defaultCustom == engineTypeId and 0 or Shared.Math:GroupDigits(price[i]))
            },
            true,
            {
                onSelected = function()
                    if (currentEngine ~= true) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modEngine, engineTypeId)
                        Client.Mecano:addPriceForCustomisation("modEngine", engineTypeId, price[i], "Moteur")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de moteur disponible")
    end
end)

mecanoStorage:Get("suspension_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentSuspension = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSuspension)
    local GetNumVehicleMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modSuspension)
    local suspensionType = Engine["Enums"].Vehicles.SuspensionType
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modSuspension")
    local price = Client.Mecano:getPriceForCustomisation("suspension")

    if (GetNumVehicleMods > 0) then
        Items:Button("Suspension de série", nil,
        {
            RightBadge = (currentSuspension == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentSuspension ~= -1) and ("%s ~g~$~s~"):format((defaultCustom == -1) and 0 or Shared.Math:GroupDigits(price[0]))
        },
        true,
        {
            onSelected = function()
                if (currentSuspension ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSuspension, -1)
                    Client.Mecano:addPriceForCustomisation("modSuspension", -1, price[0], "Suspension")
                end
            end
        })

        for i = 1, #suspensionType do
            local suspensionTypeName = suspensionType[i].label
            local suspensionTypeId = suspensionType[i].value

            if (i <= 2) then
                price[i] = Shared.Math:Round(price[i] * Client.Mecano:getMultiplier(), 0)
            else
                price[i] = Shared.Math:Round(price[i] * 1.007, 0)
            end

            Items:Button(suspensionTypeName, nil,
            {
                RightBadge = (currentSuspension == suspensionTypeId) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentSuspension ~= suspensionTypeId) and ("%s ~g~$~s~"):format(defaultCustom == suspensionTypeId and 0 or Shared.Math:GroupDigits(price[i]))
            },
            true,
            {
                onSelected = function()
                    if (currentSuspension ~= suspensionTypeId) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modSuspension, suspensionTypeId, false)
                        Client.Mecano:addPriceForCustomisation("modSuspension", suspensionTypeId, price[i], "Suspension")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de suspension disponible")
    end
end)

mecanoStorage:Get("transmission_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentTransmission = GetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modTransmission)
    local GetNumVehicleMods = GetNumVehicleMods(vehicle, Engine["Enums"].Vehicles.Customisation.modTransmission)
    local transmission_type = Engine["Enums"].Vehicles.TransmissionType
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modTransmission")
    local price = Client.Mecano:getPriceForCustomisation("transmission")

    if (GetNumVehicleMods > 0) then
        Items:Button("Transmission de série", nil,
        {
            RightBadge = (currentTransmission == -1) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentTransmission ~= -1) and ("%s ~g~$~s~"):format((defaultCustom == -1) and 0 or Shared.Math:GroupDigits(price[0]))
        },
        true,
        {
            onSelected = function()
                if (currentTransmission ~= -1) then
                    SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modTransmission, -1)
                    Client.Mecano:addPriceForCustomisation("modTransmission", -1, price[0], "Transmission")
                end
            end
        })

        for i = 1, #transmission_type do
            local transmissionTypeName = transmission_type[i].label
            local transmissionTypeId = transmission_type[i].value

            if (i <= 2) then
                price[i] = Shared.Math:Round(price[i] * Client.Mecano:getMultiplier(), 0)
            else
                price[i] = Shared.Math:Round(price[i] * 1.007, 0)
            end

            Items:Button(transmissionTypeName, nil,
            {
                RightBadge = (currentTransmission == transmissionTypeId) and RageUI.BadgeStyle.Car or nil,
                RightLabel = (currentTransmission ~= transmissionTypeId) and ("%s ~g~$~s~"):format(defaultCustom == transmissionTypeId and 0 or Shared.Math:GroupDigits(price[i]))
            },
            true,
            {
                onSelected = function()
                    if (currentTransmission ~= transmissionTypeId) then
                        SetVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modTransmission, transmissionTypeId)
                        Client.Mecano:addPriceForCustomisation("modTransmission", transmissionTypeId, price[i], "Transmission")
                    end
                end
            })
        end
    else
        Items:Separator("Aucune modification de transmission disponible")
    end
end)

mecanoStorage:Get("turbo_menu"):IsVisible(function(Items)
    local vehicle = Client.Mecano.getVehicleHandle()
    local currentTurbo = IsToggleModOn(vehicle, Engine["Enums"].Vehicles.Customisation.modTurbo)
    local hasTurboOption = IsThisModelACar(GetEntityModel(vehicle)) and IsToggleModOn(vehicle, Engine["Enums"].Vehicles.Customisation.modTurbo) ~= nil
    local defaultCustom = Client.Mecano:getDefaultCustomisationByType("modTurbo")
    local price = Client.Mecano:getPriceForCustomisation("turbo")

    if (currentTurbo == 1) then
        currentTurbo = true
    end

    if (defaultCustom == 1) then
        defaultCustom = true
    end

    if (hasTurboOption) then
        Items:Button("Aucun", nil,
        {
            RightBadge = (currentTurbo == false) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentTurbo ~= false) and ("%s ~g~$~s~"):format((defaultCustom == false) and 0 or Shared.Math:GroupDigits(price[0]))
        },
        true,
        {
            onSelected = function()
                if (currentTurbo ~= false) then
                    ToggleVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modTurbo, false)
                    Client.Mecano:addPriceForCustomisation("modTurbo", false, price[0], "Turbo")
                end
            end
        })

        Items:Button("Tuning turbo", nil,
        {
            RightBadge = (currentTurbo == true) and RageUI.BadgeStyle.Car or nil,
            RightLabel = (currentTurbo ~= true) and ("%s ~g~$~s~"):format((defaultCustom == true) and 0 or Shared.Math:GroupDigits(price[1]))
        },
        true,
        {
            onSelected = function()
                if (currentTurbo ~= true) then
                    ToggleVehicleMod(vehicle, Engine["Enums"].Vehicles.Customisation.modTurbo, true)
                    Client.Mecano:addPriceForCustomisation("modTurbo", true, price[1], "Turbo")

                    if (defaultCustom == true) then
                        Client.Mecano:removePriceForCustomisation("modTurbo")
                    end
                end
            end
        })
    else
        Items:Separator("Aucune modification de turbo disponible")
    end
end)

CreateThread(function()
    local customVehicleZone = Engine["Config"]["Mecano"]["Zones"]

    for k, v in pairs(customVehicleZone) do
        Game.Blip("Mecano#"..k,
            {
                coords = v.craftZone,
                label = v.blip.label,
                sprite = v.blip.sprite,
                color = v.blip.color,
            }
        )

        for i = 1, #v.customZones do
            local customZoneCoords = v.customZones[i]
            local customZone = Game.Zone("customVehicleZone#"..i, {
                job = v.jobName
            })

            customZone:Start(function()
                customZone:SetTimer(1000)
                customZone:SetCoords(customZoneCoords)
    
                customZone:IsPlayerInRadius(15.0, function()
                    customZone:SetTimer(0)
                    customZone:Marker(nil, nil, 3.0, "vehicle")

                    customZone:IsPlayerInRadius(7.0, function()
                        Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")

                        customZone:KeyPressed("E", function()
                            if (Client.Mecano:isInService()) then
                                local vehicle = Client.Player:GetVehicle()

                                if (customZoneCoords ~= nil and v.jobName ~= nil and v.customType ~= nil) then
                                    local selectedZone = {
                                        customZone = customZoneCoords,
                                        jobName = v.jobName,
                                        customType = v.customType,
                                    }

                                    Client.Mecano:setMenuStyle(v.menuStyle)
                                    Client.Mecano:openMenu(vehicle, selectedZone)
                                else
                                    Game.Notification:showNotification(
                                        "Une erreur est survenue",
                                        false
                                    )

                                    Shared.Log:Error(
                                        "Failed to open custom menu "
                                        ..("[%s, %s, %s]"):format(customZoneCoords ~= nil, v.jobName ~= nil, v.customType ~= nil)
                                        .." please contact developer."
                                    )
                                end
                            else
                                Game.Notification:showNotification("Vous devez être en service pour faire des modifications sur un véhicule", false)
                            end
                        end)

                        end, false, true)
                end, false, true)
    
                customZone:RadiusEvents(7.0, nil, function()
                    if (Client.Mecano:isInCustom()) then
                        Client.Mecano:resetDefaultCustomisation()
                    end
                end)
            end)
        end
    end
end)

Game.Vehicle:PlayerLeft(function()
    if (Client.Mecano:isInCustom()) then
        Client.Mecano:resetDefaultCustomisation()
    end
end)

Game.Vehicle:PlayerSwitchSeat(function()
    if (Client.Mecano:isInCustom()) then
        Client.Mecano:resetDefaultCustomisation()
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.requestProperties, function()
    if (Client.Mecano:isInCustom()) then
        local vehicle = Client.Mecano.getVehicleHandle()
        local vehicleProps = Game.Vehicle:GetProperties(vehicle)

        if (type(vehicleProps) == "table") then
            Shared.Events:ToServer(Engine["Enums"].Mecano.Events.receiveProperties, vehicleProps)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.changeBillState, function()
    if (Client.Mecano:isInCustom()) then
        Client.Mecano:changeBillState()
        bill = nil
    end
end)