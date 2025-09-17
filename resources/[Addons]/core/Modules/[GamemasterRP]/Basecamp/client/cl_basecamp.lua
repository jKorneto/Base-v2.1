GM_F6_Menu = RageUI.AddMenu("", "F.Cliton & Partner")
GM_MainMenu = RageUI.AddMenu("", "Faites vos actions")
GM_SubMenu = RageUI.AddMenu("", "Faites vos actions")
GM_GarageMenu = RageUI.AddMenu("", "Garage")
GM_CameraMenu = RageUI.AddMenu("", "Caméra de surveillance")

local GM_ShowCamera = false
local GM_Cam = nil

local Announces = {
    List = {
        "~s~Ouvertures",
        "~s~Fermutures",
        "~s~Recrutement"
    },
    ListIndex = 1
}

local function GM_StartCamera()
    DoScreenFadeOut(500)
    Wait(1500)
    DoScreenFadeIn(500)

    local PlayerPed = Client.Player:GetPed()
    local CamPos = Config["Gamemaster"]["Cam"]
    local CamRot = Config["Gamemaster"]["CamRot"]

    if (not GM_Cam) then
        GM_Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(GM_Cam, CamPos.x, CamPos.y, CamPos.z)
        SetCamRot(GM_Cam, CamRot.x, CamRot.y, CamRot.z)
        SetCamFov(GM_Cam, 55.0)
        SetCamActive(GM_Cam, true)
        RenderScriptCams(true, false, 0, true, true)
        ShakeCam(GM_Cam, "HAND_SHAKE", 0.3)
        SetTimecycleModifier("CAMERA_secuirity")
        SetTimecycleModifierStrength(1.0)
        InteractMenuShowHud()
        DisplayRadar(false)
    end
end

local function GM_DestroyCamera()
    DoScreenFadeOut(500)
    Wait(1500)
    DoScreenFadeIn(500)

    local PlayerPed = Client.Player:GetPed()

    if (GM_Cam) then
        StopCamShaking(GM_Cam, true)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(GM_Cam, false)
        ClearTimecycleModifier()
        InteractMenuShowHud()
        DisplayRadar(true)
        GM_Cam = nil
    end
end


CreateThread(function()
    
    GM_F6_Menu:IsVisible(function(Items)
        Items:List("Status Entreprise", Announces.List, Announces.ListIndex, nil, {}, true, {
            onListChange = function(index)
                Announces.ListIndex = index
            end,
            onSelected = function(index)
                Shared.Events:ToServer(Enums.Gamemaster.SendAnnoucement, Announces.List)
            end
        })

        local Ped = PlayerPedId()
        local Player, Distance = ESX.Game.GetClosestPlayer()
        local Coords = GetEntityCoords(Ped)
        local GetPlayerSearch = GetPlayerPed(Player)
        local IsHandsUP = IsEntityPlayingAnim(GetPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3)
    
        Items:Button("Fouiller l'individue", nil, {}, true, {
            onSelected = function()
                if Player ~= -1 and Distance <= 5.0 then
                    if IsHandsUP then
                        TriggerServerEvent("iZeyy:gang:frisk", GetPlayerServerId(Player))
                        RageUI.CloseAll()
    
                        CreateThread(function()
                            local Bool = true
                            while Bool do
                                local GetPlayerSearch = GetPlayerPed(Player)
                                local Coords = GetEntityCoords(GetPlayerPed(-1))
                                local Dist = #(GetEntityCoords(GetPlayerSearch) - Coords)
                                if (Dist > 3) then
                                    Bool = false
                                    TriggerServerEvent("iZeyy:gang:close:frisk", GetPlayerServerId(Player))
                                end
                                if not IsEntityPlayingAnim(GetPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3) then
                                    Bool = false
                                    TriggerServerEvent("iZeyy:gang:close:frisk", GetPlayerServerId(Player))
                                end
                                Wait(100)
                            end
                        end)
                    else
                        ESX.ShowNotification("La personne en face ne lève pas les mains")
                    end
                else
                    ESX.ShowNotification("Personne autour de vous")
                end
            end
        })
    
        Items:Button("Prendre la carte d'identité", nil, { RightLabel = "→" }, true, {
            onSelected = function()
                IdCard()
            end
        })

        Items:Button("Crocheter le véhicule", nil, { RightLabel = "→" }, true, {
            onSelected = function()
                Crocheter()
            end
        })

    end)

    for k, v in ipairs(Config["Gamemaster"]["Peds"]) do
    
        Game.Peds:Spawn(GetHashKey(v.model), v.position, v.heading, true, true, function(ped)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_AA_COFFEE", 0, true)
        end)
    
    end

    Game.Blip("FClinton&Partner",
    {
        coords = Config["Gamemaster"]["BlipsPos"],
        label = Config["Gamemaster"]["BlipsLabel"],
        sprite = Config["Gamemaster"]["BlipsSprite"],
        color = Config["Gamemaster"]["BlipsColor"],
        scale = 0.5,
    })

    local GM_BaseCamp_Enter = Game.Zone("GM_BaseCamp_Enter")

    GM_BaseCamp_Enter:Start(function()
        GM_BaseCamp_Enter:SetTimer(1000)
        GM_BaseCamp_Enter:SetCoords(Config["Gamemaster"]["EnterCoords"])
        GM_BaseCamp_Enter:IsPlayerInRadius(5.0, function()
            GM_BaseCamp_Enter:SetTimer(0)
            local Job = Client.Player:GetJob().name
            if Job == Config["Gamemaster"]["RequiredJob"] then 
                GM_BaseCamp_Enter:Marker()

                GM_BaseCamp_Enter:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GM_BaseCamp_Enter:KeyPressed("E", function()
                        GM_MainMenu:Toggle()
                    end)
                end, false, false)
    
                GM_BaseCamp_Enter:RadiusEvents(3.0, nil, function()
                    if GM_MainMenu:IsOpen() then
                        GM_MainMenu:Close()
                    end
                end)
                
            end
        end, false, false)
    end)

    local GM_BaseCamp_Exit = Game.Zone("GM_BaseCamp_Exit")

    GM_BaseCamp_Exit:Start(function()
        GM_BaseCamp_Exit:SetTimer(1000)
        GM_BaseCamp_Exit:SetCoords(Config["Gamemaster"]["InteriorCoords"])
        GM_BaseCamp_Exit:IsPlayerInRadius(5.0, function()
            GM_BaseCamp_Exit:SetTimer(0)
            local Job = Client.Player:GetJob().name
            if Job == Config["Gamemaster"]["RequiredJob"] then 
                GM_BaseCamp_Exit:Marker()

                GM_BaseCamp_Exit:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GM_BaseCamp_Exit:KeyPressed("E", function()
                        GM_SubMenu:Toggle()
                    end)
                end, false, false)
    
                GM_BaseCamp_Exit:RadiusEvents(3.0, nil, function()
                    if GM_SubMenu:IsOpen() then
                        GM_SubMenu:Close()
                    end
                end)
                
            end
        end, false, false)
    end)

    local GM_BaseCamp_Garage = Game.Zone("GM_BaseCamp_Garage")

    GM_BaseCamp_Garage:Start(function()
        GM_BaseCamp_Garage:SetTimer(1000)
        GM_BaseCamp_Garage:SetCoords(Config["Gamemaster"]["GarageInteractPos"])
        GM_BaseCamp_Garage:IsPlayerInRadius(2.5, function()
            GM_BaseCamp_Garage:SetTimer(0)
            local Job = Client.Player:GetJob().name
            if Job == Config["Gamemaster"]["RequiredJob"] then 

                GM_BaseCamp_Garage:IsPlayerInRadius(2.5, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule")
                    GM_BaseCamp_Garage:KeyPressed("E", function()
                        GM_GarageMenu:Toggle()
                    end)
                end, false, false)
    
                GM_BaseCamp_Garage:RadiusEvents(2.5, nil, function()
                    if GM_GarageMenu:IsOpen() then
                        GM_GarageMenu:Close()
                    end
                end)
                
            end
        end, false, false)
    end)

    local GM_BaseCamp_Delete = Game.Zone("GM_BaseCamp_Delete")

    GM_BaseCamp_Delete:Start(function()
        GM_BaseCamp_Delete:SetTimer(1000)
        GM_BaseCamp_Delete:SetCoords(Config["Gamemaster"]["GarageSpawnPos"])

        GM_BaseCamp_Delete:IsPlayerInRadius(60, function()
            GM_BaseCamp_Delete:SetTimer(0)
            local Job = Client.Player:GetJob().name

            if Job == Config["Gamemaster"]["RequiredJob"] then 
                GM_BaseCamp_Delete:Marker(nil, nil, 3.0)
                GM_BaseCamp_Delete:IsPlayerInRadius(8.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")
                    GM_BaseCamp_Delete:KeyPressed("E", function()
                        local Ped = Client.Player:GetId()
                        local Vehicle = GetVehiclePedIsIn(Ped, false)

                        TaskLeaveVehicle(Ped, Vehicle, 0)
                        SetTimeout(2000, function()
                            DeleteEntity(Vehicle)
                        end)
                    end)
                end, false, true)
            end
        end, false, true)
    end)

    local GM_BaseCamp_Camera = Game.Zone("GM_BaseCamp_Camera")

    GM_BaseCamp_Camera:Start(function()
        GM_BaseCamp_Camera:SetTimer(1000)
        GM_BaseCamp_Camera:SetCoords(Config["Gamemaster"]["CameraInteractPos"])
        GM_BaseCamp_Camera:IsPlayerInRadius(2.5, function()
            GM_BaseCamp_Camera:SetTimer(0)
            local Job = Client.Player:GetJob().name
            if Job == Config["Gamemaster"]["RequiredJob"] then 

                GM_BaseCamp_Camera:IsPlayerInRadius(2.5, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour regarder les caméra")
                    GM_BaseCamp_Camera:KeyPressed("E", function()
                        GM_CameraMenu:Toggle()
                    end)
                end, false, false)
    
                GM_BaseCamp_Camera:RadiusEvents(2.5, nil, function()
                    if GM_GarageMenu:IsOpen() then
                        GM_CameraMenu:Close()
                    end
                end)
                
            end
        end, false, false)
    end)

    GM_MainMenu:IsVisible(function(Items)
        Items:Button("Entrer dans le bâtiment", nil, {}, true, {
            onSelected = function()
                if (not Client.Player:IsInAnyVehicle()) then
                    Shared.Events:ToServer(Enums.Gamemaster.CheckToEnter)
                end
            end
        })
    end)    

    GM_SubMenu:IsVisible(function(Items)
        Items:Button("Sortir du bâtiment", nil, {}, true, {
            onSelected = function()
                if (not Client.Player:IsInAnyVehicle()) then
                    Shared.Events:ToServer(Enums.Gamemaster.CheckToExit)
                end
            end
        })
    end)

    GM_GarageMenu:IsVisible(function(Items)
        for k, v in pairs(Config["Gamemaster"]["VehList"]) do
            Items:Button(v.label, v.desc, { RightLabel = "Sortir →" }, true, {
                onSelected = function()
                    Shared.Events:ToServer(Enums.Gamemaster.SpawnVehicle, v.label, v.model)
                end
            })
        end
    end)

    GM_CameraMenu:IsVisible(function()
        Items:Button("Regarder la caméra de surveillance", nil, {}, not GM_ShowCamera, {
            onSelected = function()
                GM_ShowCamera = true
                GM_StartCamera()
            end
        })
        Items:Button("Quitter la caméra de surveillance",  nil, {}, GM_ShowCamera, {
            onSelected = function()
                GM_ShowCamera = false
                GM_DestroyCamera()
            end  
        })
    end)

end)

Shared.Events:OnNet(Enums.Gamemaster.GotoInterior, function(Coords, Heading)
    local Player = Client.Player:GetPed()
    local Job = Client.Player:GetJob().name

    if Job == Config["Gamemaster"]["RequiredJob"] then
        GM_MainMenu:Close()
        Elevator:Teleport(Player, Coords, Heading)
        Game.Notification:showNotification("Bienvenue (~b~" .. GetPlayerName(Client.Player:GetId()) .. "~s~)")
    end
end)

Shared.Events:OnNet(Enums.Gamemaster.GotoExterior, function(Coords, Heading)
    local Player = Client.Player:GetPed()
    local Job = Client.Player:GetJob().name

    if Job == Config["Gamemaster"]["RequiredJob"] then
        GM_SubMenu:Close()
        Elevator:Teleport(Player, Coords, Heading)
        Game.Notification:showNotification("Bonne sortie en ville (~b~" .. GetPlayerName(Client.Player:GetId()) .. "~s~)")
    end
end)

Shared.Events:OnNet(Enums.Gamemaster.GotoGarage, function(Coords, Heading)
    local Player = Client.Player:GetPed()
    local Job = Client.Player:GetJob().name

    if Job == Config["Gamemaster"]["RequiredJob"] then
        GM_GarageMenu:Close()
        Elevator:Teleport(Player, Coords, Heading)
        Game.Notification:showNotification("Bonne sortie en ville (~b~" .. GetPlayerName(Client.Player:GetId()) .. "~s~)")
    end
end)

Shared:RegisterKeyMapping("iZeyy:Gamemaster:OpenMenu", { label = "open_menu_interactSasp" }, "F6", function()
    local Job = Client.Player:GetJob().name

    if Job == Config["Gamemaster"]["RequiredJob"] then
        GM_F6_Menu:Toggle()
    end
end)