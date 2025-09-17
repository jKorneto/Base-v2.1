local main_menu = RageUI.AddMenu("", "Faites vos actions")

local InWork = false

local TreeBlips = {}
local TBlip, SBlip

local CurrentWoodObject = nil
local WoodInHand = false

local function StartHatchetAnim()
    if not (WoodInHand) then
        local PlayerPed = PlayerPedId()
        local AnimDict, AnimName = "amb@world_human_hammering@male@base", "base"
        Game.Streaming:RequestAnimDict(AnimDict, function()
            TaskPlayAnim(PlayerPed, AnimDict, AnimName, 8.0, 8.0, -1, 1, 0.0, false, false, false)
            HUDProgressBar("Sciage en cours...", 5, function()
                ClearPedTasks(PlayerPed)
                local PlayerPos = GetEntityCoords(PlayerPed)
                local WoodType = CreateObject(GetHashKey("prop_fncwood_16d"), PlayerPos.x, PlayerPos.y, PlayerPos.z, true, true, true)
                local HandBone = GetPedBoneIndex(PlayerPed, 60309)
                CurrentWoodObject = WoodType
                AttachEntityToEntity(WoodType, PlayerPed, HandBone, 0.00, 0.00, 0.00, -0.0, 0.0, 0.0, true, true, false, true, 2, true)
    
                local AnimDictWood, AnimNameWood = "anim@heists@box_carry@", "idle"
                Game.Streaming:RequestAnimDict(AnimDictWood, function()
                    TaskPlayAnim(PlayerPed, AnimDictWood, AnimNameWood, 3.0, -8, -1, 63, 0, false, false, false)
                    TriggerServerEvent("iZeyy:Sawmill:HandWood")
                end)
            end)
        end)

        CreateThread(function()
            local Interval = 3000
            while true do
                Wait(Interval)
                if (WoodInHand) then
                    Interval = 0
                    local PlayerPed = PlayerPedId()
                    local AnimDictCheck, AnimNameCheck = "anim@heists@box_carry@", "idle"
                    if (IsEntityPlayingAnim(PlayerPed, AnimDictCheck, AnimNameCheck, 3)) then
                        DisableControlAction(0, 21, true)
                        DisableControlAction(0, 22, true)
                    end
                    if (not IsEntityPlayingAnim(PlayerPed, AnimDictCheck, AnimNameCheck, 3)) then
                        TaskPlayAnim(PlayerPed, AnimDictCheck, AnimNameCheck, 3.0, -8, -1, 63, 0, false, false, false)
                    end
                    local Vehicle = GetVehiclePedIsTryingToEnter(PlayerPed)
                    local CurrentVeh = GetVehiclePedIsIn(PlayerPed, false)
                    local Seat = GetSeatPedIsTryingToEnter(PlayerPed)
                    local Driver = (GetPedInVehicleSeat(CurrentVeh, -1) == PlayerPed)
                    if (Vehicle ~= 0 and Seat == -1) then
                        ESX.ShowNotification("Vous ne pouvez pas monter dans un vehicule avec du bois dans les mains")
                        ClearPedTasksImmediately(PlayerPed)
                    end
                    if (CurrentVeh ~= 0 and Driver) then
                        ESX.ShowNotification("Vous ne pouvez pas conduire de vehicule avec du bois dans les mains")
                        TaskLeaveVehicle(PlayerPed, CurrentVeh, 4160)
                    end
                else
                    break
                end
            end
        end)
    else 
        ESX.ShowNotification("Vous ne pouvez pas prendre du bois en ayant deja du bois sur vous")
    end
end

local function ResellWood()
    if (InWork) then
        if (WoodInHand) then
            TriggerServerEvent("iZeyy:Sawmill:Sell")
        else
            ESX.ShowNotification("Vous n'avez pas de bois dans les mains...")
        end
    end
end

local function ActivePos()
    InWork = true
    if (InWork) then
        for k, v in pairs(Config["Scierie"]["TreesPos"]) do
            TBlip = AddBlipForCoord(v)
            SetBlipSprite(TBlip, 365)
            SetBlipColour(TBlip, 2)
            SetBlipScale(TBlip, 0.8)
            SetBlipAsShortRange(TBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Arbre à Abattre")
            EndTextCommandSetBlipName(TBlip)
            table.insert(TreeBlips, TBlip)
    
            local TreesZone = Game.Zone("TreesZone")
    
            TreesZone:Start(function()
                TreesZone:SetTimer(1000)
                TreesZone:SetCoords(v)
        
                TreesZone:IsPlayerInRadius(3.0, function()
                    TreesZone:SetTimer(0)
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
        
                    TreesZone:IsPlayerInRadius(3.0, function()
        
                        TreesZone:KeyPressed("E", function()
                            if not (WoodInHand) then
                                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                    StartHatchetAnim()
                                else
                                    ESX.ShowNotification("Vous ne pouvez pas prendre du bois en voiture")
                                end
                            else
                                ESX.ShowNotification("Vous ne pouvez pas prendre du bois en ayant deja du bois sur vous")
                            end
                        end)
        
                    end, false, false)
                end, false, false)
            end)
        end

        -- Vente
        SBlip = AddBlipForCoord(Config["Scierie"]["SellPedPos"])
        SetBlipSprite(SBlip, 85)
        SetBlipColour(SBlip, 3)
        SetBlipScale(SBlip, 0.8)
        SetBlipAsShortRange(SBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Revente de Bois")
        EndTextCommandSetBlipName(SBlip)

        local SellZone = Game.Zone("SellZone")

        SellZone:Start(function()
            SellZone:SetTimer(1000)
            SellZone:SetCoords(Config["Scierie"]["SellPedPos"])
    
            SellZone:IsPlayerInRadius(3.0, function()
                SellZone:SetTimer(0)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
    
                SellZone:IsPlayerInRadius(3.0, function()
    
                    SellZone:KeyPressed("E", function()
                        if not IsPedInAnyVehicle(PlayerPedId(), false) then
                            ResellWood()
                        else
                            ESX.ShowNotification("Vous ne pouvez pas vendre en voiture")
                        end
                    end)
    
                end, false, false)
            end, false, false)
        end)
    end
end

local function DisbalePos()
    if (InWork) then
        for _, TBlip in ipairs(TreeBlips) do
            RemoveBlip(TBlip)
        end
        TreeBlips = {}
        RemoveBlip(SBlip)
        InWork = false
    end
end

CreateThread(function()
    local ScierieZone = Game.Zone("ScierieZone")

    ScierieZone:Start(function()
        ScierieZone:SetTimer(1000)
        ScierieZone:SetCoords(Config["Scierie"]["PedPos"])

        ScierieZone:IsPlayerInRadius(3.0, function()
            ScierieZone:SetTimer(0)
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

            ScierieZone:IsPlayerInRadius(3.0, function()

                ScierieZone:KeyPressed("E", function()
                    main_menu:Toggle()
                end)

            end, false, false)
        end, false, false)
    end)

    local Model = GetHashKey(Config["Scierie"]["PedModel"])
    RequestModel(Model)
    while not HasModelLoaded(Model) do Wait(1) end
    local Ped = CreatePed(4, Model, Config["Scierie"]["PedPos"], Config["Scierie"]["PedHeading"], false, true)
    FreezeEntityPosition(Ped, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    local SModel = GetHashKey(Config["Scierie"]["SellPedModel"])
    RequestModel(SModel)
    while not HasModelLoaded(SModel) do Wait(1) end
    local SPed = CreatePed(4, SModel, Config["Scierie"]["SellPedPos"], Config["Scierie"]["SellPedHeading"], false, true)
    FreezeEntityPosition(SPed, true)
    SetEntityInvincible(SPed, true)
    SetBlockingOfNonTemporaryEvents(SPed, true)

    local Blip = AddBlipForCoord(Config["Scierie"]["BlipsPos"])
    SetBlipSprite(Blip, 761)
    SetBlipColour(Blip, 17)
    SetBlipScale(Blip, 0.7)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Scierie")
    EndTextCommandSetBlipName(Blip)

    main_menu:IsVisible(function(Items)
        Items:Button("Commencez a Travailler", nil, {}, not InWork, {
            onSelected = function()
                TriggerServerEvent("iZeyy:Sawmill:Service", true)
            end
        })
        Items:Button("Terminer de Travailler", nil, {}, InWork, {
            onSelected = function()
                TriggerServerEvent("iZeyy:Sawmill:Service", false)
            end
        })
    end)

end)

RegisterNetEvent("iZeyy:Sawmill:ShowPos", function()
    if not (InWork) then
        ActivePos()
    end
end)

RegisterNetEvent("iZeyy:Sawmill:DisiblePos", function()
    if (InWork) then
        DisbalePos()
    end
end)

RegisterNetEvent("iZeyy:Sawmill:StopAnim", function()
    if (InWork) then
        if (CurrentWoodObject) then
            local PlayerPed = PlayerPedId()
            WoodInHand = false
            DeleteObject(CurrentWoodObject)
            CurrentWoodObject = nil
            ClearPedTasks(PlayerPed)
        end
    end
end)

RegisterNetEvent("iZeyy:Sawmill:HandWood", function()
    if (InWork) then
        WoodInHand = true
    end
end)