local main_menu = RageUI.AddMenu("", "Vigneron")
local service_menu = RageUI.AddMenu("", "Vigneron")
local vehicle_menu = RageUI.AddMenu("", "Vigneron")

local InService = true
local Timeout = false

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
service_menu:SetSpriteBanner("commonmenu", "interaction_legal")
service_menu:SetButtonColor(0, 137, 201, 255)
vehicle_menu:SetSpriteBanner("commonmenu", "interaction_legal")
vehicle_menu:SetButtonColor(0, 137, 201, 255)

local function SetUniform(type)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Vigneron"]["Uniform"].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Vigneron"]["Uniform"].female)
        end
    end)
end

local function Harvest()
    local PlayerPed = Client.Player.GetPed()

    if not IsPedInAnyVehicle(PlayerPed, false) then
        local AnimDict, AnimName = "amb@medic@standing@kneel@idle_a", "idle_a"
        Game.Streaming:RequestAnimDict(AnimDict, function()
            TaskPlayAnim(PlayerPed, AnimDict, AnimName, 8.0, -8.0, -1, 0, 0, false, false, false)
            HUDProgressBar("Recolte de raison en cours...", 4, function()
                ClearPedTasks(PlayerPed)
                TriggerServerEvent("iZeyy:Vigneron:RecolteRaisin")
            end)
        end)
    else
        ESX.ShowNotification("Vous ne pouvez pas récolter en voiture")
    end
end

local function Traitement()
    local PlayerPed = Client.Player.GetPed()
    if not IsPedInAnyVehicle(PlayerPed, false) then
        local AnimDict, AnimName = "amb@medic@standing@kneel@idle_a", "idle_a"
        Game.Streaming:RequestAnimDict(AnimDict, function()
            TaskPlayAnim(PlayerPed, AnimDict, AnimName, 8.0, -8.0, -1, 0, 0, false, false, false)
            HUDProgressBar("Traitement du raisin en cours...", 4, function()
                ClearPedTasks(PlayerPed)
                TriggerServerEvent("iZeyy:Vigneron:TraitementRaisin")
            end)
        end)
    else
        ESX.ShowNotification("Vous ne pouvez pas traiter en voiture")
    end
end

CreateThread(function()

    Game.Blip("Vigneron1",
    {
        coords = Config["Vigneron"]["Vestiaire"],
        label = "Vigneron",
        sprite = 85,
        color = 7,
        scale = 0.6,
    })
    Game.Blip("Vigneron2",
    {
        coords = Config["Vigneron"]["Vente"],
        label = "Vente de vin",
        sprite = 85,
        color = 7,
        scale = 0.6,
    })

    Game.Peds:Spawn(GetHashKey("a_f_m_prolhost_01"), Config["Vigneron"]["Vente"], 93.776321411133, true, true, function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end)

    local VigneronServiceZone = Game.Zone("VigneronServiceZone")

    VigneronServiceZone:Start(function()
        VigneronServiceZone:SetTimer(1000)
        VigneronServiceZone:SetCoords(Config["Vigneron"]["Vestiaire"])
        local job = Client.Player:GetJob().name

        if job == Config["Vigneron"]["AllowedJob"] then
            VigneronServiceZone:IsPlayerInRadius(10.0, function()
                VigneronServiceZone:SetTimer(0)
                VigneronServiceZone:Marker()

                VigneronServiceZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    VigneronServiceZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end, false, false)

            end, false, false)

            VigneronServiceZone:RadiusEvents(3.0, nil, function()
                service_menu:Close()
            end)
        end
    end)

    service_menu:IsVisible(function(Items)
        Items:Button("Prendre votre Service", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                service_menu:Close()
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("iZeyy:job:takeService", Config["Vigneron"]["AllowedJob"], true)
                TriggerEvent("iZeyy:Vigneron:ShowBlip", true)
                SetUniform("service")
                InService = true
            end
        })
        Items:Button("Fin de service", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                service_menu:Close()
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
                TriggerServerEvent("iZeyy:job:takeService", Config["Vigneron"]["AllowedJob"], false)
                TriggerEvent("iZeyy:Vigneron:ShowBlip", false)
                InService = false
            end 
        })
    end)

    vehicle_menu:IsVisible(function(Items)
        if (InService) then
            for k, v in pairs(Config["Vigneron"]["VehList"]) do
                Items:Button(v.label, nil, { RightLabel = "Prendre →"}, true, {
                    onSelected = function()
                        TriggerServerEvent("iZeyy:Vigneron:SpawnVehicle", v.model, v.label)
                    end
                })
            end
        else
            Items:Separator()
            Items:Separator("Vous devez etre en service")
            Items:Separator()
        end
    end)

    local VigneronGarageZone = Game.Zone("VigneronGarageZone")

    VigneronGarageZone:Start(function()
        VigneronGarageZone:SetTimer(1000)
        VigneronGarageZone:SetCoords(Config["Vigneron"]["Garage"]) 

        VigneronGarageZone:IsPlayerInRadius(10.0, function()
            VigneronGarageZone:SetTimer(0)
            local job = Client.Player:GetJob().name

            if job == Config["Vigneron"]["AllowedJob"] then
                VigneronGarageZone:Marker()
                VigneronGarageZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage")
                    VigneronGarageZone:KeyPressed("E", function()
                        vehicle_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local VigneronGarageDeleteZone = Game.Zone("VigneronGarageDeleteZone")

    VigneronGarageDeleteZone:Start(function()
        VigneronGarageDeleteZone:SetTimer(1000)
        VigneronGarageDeleteZone:SetCoords(Config["Vigneron"]["GarageDelete"])

        VigneronGarageDeleteZone:IsPlayerInRadius(60, function()
            VigneronGarageDeleteZone:SetTimer(0)
            local job = Client.Player:GetJob().name

            if job == Config["Vigneron"]["AllowedJob"] then
                VigneronGarageDeleteZone:Marker(nil, nil, 3.0)
                VigneronGarageDeleteZone:IsPlayerInRadius(8.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")
                    VigneronGarageDeleteZone:KeyPressed("E", function()
                        local ped = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(ped, false)

                        TaskLeaveVehicle(ped, vehicle, 0)
                        SetTimeout(2000, function()
                            DeleteEntity(vehicle)
                        end)
                    end)
                end, false, true)
            end
        end, false, true)
    end)


    local VigneronRecolteZone = Game.Zone("VigneronRecolteZone")

    VigneronRecolteZone:Start(function()
        VigneronRecolteZone:SetTimer(1000)
        VigneronRecolteZone:SetCoords(Config["Vigneron"]["Recolte"])
        local job = Client.Player:GetJob().name

        if job == Config["Vigneron"]["AllowedJob"] then
            VigneronRecolteZone:IsPlayerInRadius(40.0, function()
                VigneronRecolteZone:SetTimer(0)

                VigneronRecolteZone:IsPlayerInRadius(30.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour recolter du raisin")
                    VigneronRecolteZone:KeyPressed("E", function()
                        if (InService) then
                            if (not Timeout) then
                                Timeout = true
                                Harvest()
                                SetTimeout(4000, function()
                                    Timeout = false
                                end)
                            end
                        else
                            ESX.ShowNotification("Vous devez etre en service")
                        end
                    end)
                end, false, false)

            end, false, false)
        end
    end)

    local VigneronTraitementZone = Game.Zone("VigneronTraitementZone")

    VigneronTraitementZone:Start(function()
        VigneronTraitementZone:SetTimer(1000)
        VigneronTraitementZone:SetCoords(Config["Vigneron"]["Traitement"])
        local job = Client.Player:GetJob().name

        if job == Config["Vigneron"]["AllowedJob"] then
            VigneronTraitementZone:IsPlayerInRadius(10.0, function()
                VigneronTraitementZone:SetTimer(0)
                VigneronTraitementZone:Marker()

                VigneronTraitementZone:IsPlayerInRadius(7.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter du raisin")
                    VigneronTraitementZone:KeyPressed("E", function()
                        if (InService) then
                            if (not Timeout) then
                                Timeout = true
                                Traitement()
                                SetTimeout(4000, function()
                                    Timeout = false
                                end)
                            end
                        else
                            ESX.ShowNotification("Vous devez etre en service")
                        end
                    end)
                end, false, false)

            end, false, false)
        end
    end)

    local VigneronVenteZone = Game.Zone("VigneronVenteZone")

    VigneronVenteZone:Start(function()
        VigneronVenteZone:SetTimer(1000)
        VigneronVenteZone:SetCoords(Config["Vigneron"]["Vente"])
        local job = Client.Player:GetJob().name

        if job == Config["Vigneron"]["AllowedJob"] then
            VigneronVenteZone:IsPlayerInRadius(10.0, function()
                VigneronVenteZone:SetTimer(0)
                --VigneronVenteZone:Marker()

                VigneronVenteZone:IsPlayerInRadius(7.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre votre vin")
                    VigneronVenteZone:KeyPressed("E", function()
                        if (InService) then
                            HUDProgressBar("Vente du vin en cours...", 10, function()
                                TriggerServerEvent("iZeyy:Vigneron:Vente")
                            end)
                        else
                            ESX.ShowNotification("Vous devez etre en service")
                        end
                    end)
                end, false, false)

            end, false, false)
        end
    end)

end)

-- F6
Shared:RegisterKeyMapping("iZeyy:Vigneron:OpenMenu", { label = "open_menu_interactVigneron" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == Config["Vigneron"]["AllowedJob"] then
        main_menu:Toggle()
    end
end)
