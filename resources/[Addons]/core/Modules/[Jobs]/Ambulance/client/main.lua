local main_menu = RageUI.AddMenu("", "Los Santos Emergency Services")
local dead_menu = RageUI.AddMenu("", "Vous êtes mort")
local garage_menu = RageUI.AddMenu("", "Garage")
local cloakroom_menu = RageUI.AddMenu("", "Vestiaire")
local pharmacy_menu = RageUI.AddMenu("", "Pharmacie")
local player_action_menu = RageUI.AddSubMenu(main_menu, "", "Action Joueur")
local call_menu = RageUI.AddSubMenu(main_menu, "", "Liste des appels")

local IsInPVP = false
local inWork = false
local isInService = false
local UNARMED = GetHashKey("WEAPON_UNARMED")
local callInWaiting = {}
local playerSpawned = false

AddEventHandler("engine:enterspawn:finish", function()
    playerSpawned = true
end)

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
garage_menu:SetSpriteBanner("commonmenu", "interaction_legal")
garage_menu:SetButtonColor(0, 137, 201, 255)
cloakroom_menu:SetSpriteBanner("commonmenu", "interaction_legal")
cloakroom_menu:SetButtonColor(0, 137, 201, 255)
pharmacy_menu:SetSpriteBanner("commonmenu", "interaction_legal")
pharmacy_menu:SetButtonColor(0, 137, 201, 255)
player_action_menu:SetSpriteBanner("commonmenu", "interaction_legal")
player_action_menu:SetButtonColor(0, 137, 201, 255)
call_menu:SetSpriteBanner("commonmenu", "interaction_legal")
call_menu:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerLoaded = true
    ESX.PlayerData = xPlayer

    while not playerSpawned do
        Wait(500)
    end

    if (ESX.PlayerData.isDead) then
        SetTimeout(5000, function()
            TriggerServerEvent("core:jail:deco_reco")
        end)
    else
        SetTimeout(5000, function()
            if ESX.PlayerData.isHurt then
                setHurt(PlayerPedId(), ESX.PlayerData.hurtTime)
                ESX.ShowNotification("Vous êtes blessé, il est nécessaire d'attendre la fin de votre ATA (temps restant : " .. (ESX.PlayerData.hurtTime / 60) .. " minutes)")
            end
        end)
    end
end)

AddEventHandler("JustGod:onelife:pvpModeUpdated", function(inPVP)
    IsInPVP = inPVP
end)

AddEventHandler("justgod:player:work_state", function(state)
    inWork = state
end)

CreateThread(function()

    for k, v in pairs(Config["AmbulanceJob"]["DoctorPed"]) do
        local model = GetHashKey("s_m_m_doctor_01")
        local ped = CreatePed(4, model, v.pos, v.heading, false, true)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end

end)

main_menu:IsVisible(function(Items)
    if isInService then
        Items:Button("Action joueur", nil, {}, true, {}, player_action_menu)
        Items:Button("Consulter les appels", nil, {}, true, {}, call_menu)
    else
        Items:Separator("")
        Items:Separator("Vous devez être en service")
        Items:Separator("")
    end
end)

player_action_menu:IsVisible(function(Items)
    local player, distance = ESX.Game.GetClosestPlayer()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    Items:Button("Faire une facture", nil, {}, true, {
        onSelected = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance < 5.0 then
                local success, input = pcall(function()
                    return lib.inputDialog("Montant", {
                        {type = "number", label = "Entrez votre prix"},
                    })
                end)

                if not success then
                    return
                elseif input == nil then
                    ESX.ShowNotification("Entrez un texte Valide")
                else
                    local price = input[1]
                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'ambulance', 'Ambulance', price)
                end
            else
                ESX.ShowNotification("Aucun joueurs a coté de vous.")
            end
        end
    })

    Items:Button("Retirer l'ATA", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                TriggerServerEvent("fowlmas:ambulance:removeATA", GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Faire une réanimation", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                TriggerServerEvent('fowlmas:ambulance:heal', GetPlayerServerId(closestPlayer), "resuscitation")
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Faire un petit soin", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                TriggerServerEvent('fowlmas:ambulance:heal', GetPlayerServerId(closestPlayer), "small")
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Faire un grand soin", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                TriggerServerEvent('fowlmas:ambulance:heal', GetPlayerServerId(closestPlayer), "big")
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })


end)

call_menu:IsVisible(function(Items)
    for k, v in pairs(callInWaiting) do
        Items:Button("Appel #"..k, nil, {}, true, {
            onSelected = function()
                SetNewWaypoint(v.coords.x, v.coords.y)
                TriggerServerEvent("fowlmas:ambulance:removeCall", k)
                ESX.ShowNotification("Vous avez pris l'appel #"..k)
            end
        })
    end
end)

pharmacy_menu:IsVisible(function(Items)
    for k, v in pairs(Config["AmbulanceJob"]["PharmacyShop"]) do
        Items:Button(v.label, nil, {}, true, {
            onSelected = function()
                local item = tostring(Shared:KeyboardInput("Nombre(s) d'objet(s) ?", 2))
                if (Shared:InputIsValid(item, "number")) then
                    TriggerServerEvent('fowlmas:ambulance:buyItem', v.item, tonumber(item))
                end
            end
        })
    end
end)

local function RespawnPed(player, coords)
    if not IsInPVP then

        TriggerServerEvent("fowlmas:ambulance:check")

        CreateThread(function()
            DoScreenFadeOut(800)

            while not IsScreenFadedOut() do
                Wait(0)
            end

            NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
            SetPlayerInvincible(player, false)
            ClearPedBloodDamage(player)
            ResetPedVisibleDamage(player)
            ClearPedLastWeaponDamage(player)

            local respawnData = {
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                },
                heading = coords.heading or 0.0,
                model = GetEntityModel(player)
            }

            TriggerEvent("playerSpawned", respawnData, false)

            StopScreenEffect('DeathFailOut')
            DoScreenFadeIn(800)
        end)

    else

        CreateThread(function()
            DoScreenFadeOut(800)

            while not IsScreenFadedOut() do
                Wait(0)
            end

            NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
            SetPlayerInvincible(player, false)
            ClearPedBloodDamage(player)
            ResetPedVisibleDamage(player)
            ClearPedLastWeaponDamage(player)

            local respawnData = {
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                },
                heading = coords.heading or 0.0,
                model = GetEntityModel(player)
            }

            TriggerEvent("playerSpawned", respawnData, false)

            local godCheck = true
            local state = 100

            SetTimeout(2500, function() godCheck = false
                SetEntityAlpha(playerPed, 255)
                SetPlayerInvincible(PlayerId(), false)
                DisablePlayerFiring(PlayerId(), false)
                NetworkSetFriendlyFireOption(true)
            end)

            CreateThread(function()
                while godCheck do

                    if (state == 100) then
                        state = 250
                    elseif (state == 250) then
                        state = 100
                    end

                    SetPlayerInvincible(PlayerId(), true)
                    SetEntityAlpha(playerPed, state)
                    DisablePlayerFiring(PlayerId(), true)
                    NetworkSetFriendlyFireOption(false)

                    Wait(250)

                end

            end)

            StopScreenEffect('DeathFailOut')
            DoScreenFadeIn(800)
        end)

    end
end

local function playAnimation(type)
    local player = PlayerPedId()

    if type == "resuscitation" then
        TaskStartScenarioInPlace(player, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    elseif type == "small" then
        TaskStartScenarioInPlace(player, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    elseif type == "big" then
        TaskStartScenarioInPlace(player, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    end

    SetTimeout(10000, function()
        ClearPedTasks(player)
    end)
end

RegisterNetEvent("fowlmas:player:playAnimation", function(type)
    playAnimation(type)
end)

local hurt = false

---@param ped number
function setNotHurt(ped)
    if (not hurt) then return end
    hurt = false
    ResetPedMovementClipset(ped)
    ResetPedWeaponMovementClipset(ped)
    ResetPedStrafeClipset(ped)
end

---@param ped number
function setHurt(ped, time)
    local timerHurt = Shared.Timer(time)
    timerHurt:Start()

    if (hurt) then return end
    hurt = true
    
    local dict = "anim@scripted@heist@ig25_beach@male@"
    RequestAnimDict(dict)
    repeat Wait(0) until HasAnimDictLoaded(dict)

    CreateThread(function()

        local anim_set = "move_m@injured"

        RequestAnimSet(anim_set)

        while not HasAnimSetLoaded(anim_set) do
            Wait(0)
        end

        SetPedMovementClipset(ped, anim_set, true)
        ESX.ShowNotification("Vous êtes blessé, il est nécessaire d'attendre la fin de votre ATA (temps restant : "..timerHurt:ShowRemaining()..")")

    end)

    CreateThread(function()
        while true do
            local anim_set = "move_m@injured"

            if (hurt and not timerHurt:HasPassed()) then

                SetPedMovementClipset(ped, anim_set, true)
                SetPlayerHealthRechargeLimit(ped, 0.0)
                SetPlayerHealthRechargeMultiplier(ped, 0.0)
                DisablePlayerFiring(ped, true)

                local weapon = GetSelectedPedWeapon(ped)

                if (weapon ~= UNARMED and not inWork) then
                    SetCurrentPedWeapon(ped, UNARMED, true)
                    ESX.ShowNotification("Vous devez être complétement soigné avant de pouvoir utiliser une arme (temps restant : "..timerHurt:ShowRemaining()..")")
                end

                local vehicle = GetVehiclePedIsTryingToEnter(ped)
                local current_vehicle = GetVehiclePedIsIn(ped, false)
                local seat = GetSeatPedIsTryingToEnter(ped)
                local isDriver = (GetPedInVehicleSeat(current_vehicle, -1) == ped)

                if (vehicle ~= 0 and seat == -1) then
                    ESX.ShowNotification("Vous devez être complétement soigné avant de pouvoir monter dans un véhicule (temps restant : "..timerHurt:ShowRemaining()..")")
                    ClearPedTasksImmediately(ped)
                end

                if (current_vehicle ~= 0 and isDriver) then
                    ESX.ShowNotification("Vous devez être complétement soigné avant de pouvoir conduire un véhicule (temps restant : "..timerHurt:ShowRemaining()..")")
                    TaskLeaveVehicle(ped, current_vehicle, 4160)
                end

                if (IsInPVP) then
                    setNotHurt(ped)
                end

            else
                setNotHurt(ped)
                TriggerServerEvent("fowlmas:ambulance:removeATA", GetPlayerServerId(PlayerId()))
                break
            end
            
            Wait(0)

        end
    end)

end

exports('IsHurt', function()
    return hurt
end)

RegisterNetEvent("fowlmas:player:receiveATA", function(time, active)
    if active then
        setHurt(PlayerPedId(), time*60)
    else
        setNotHurt(PlayerPedId())
    end
end)

RegisterNetEvent("fowlmas:player:heal", function(type, postion)
    local player = PlayerPedId()
    local health = GetEntityHealth(player)
    local coords = GetEntityCoords(player)

    if type == "resuscitation" then
        ESX.SetPlayerData('lastPosition', {
            x = coords.x,
            y = coords.y,
            z = coords.z
        })

        TriggerServerEvent('esx:updateLastPosition', {
            x = coords.x,
            y = coords.y,
            z = coords.z
        })

        RespawnPed(player, coords)
    elseif type == "small" then
        SetEntityHealth(player, health + 50)
    elseif type == "big" then
        SetEntityHealth(player, health + 100)
    elseif type == "respawn" then
        ESX.SetPlayerData('lastPosition', {
            x = postion.x,
            y = postion.y,
            z = postion.z
        })

        TriggerServerEvent('esx:updateLastPosition', {
            x = postion.x,
            y = postion.y,
            z = postion.z
        })

        RespawnPed(player, postion)
    elseif type == "slay" then
        SetEntityHealth(player, 0)
    end

end)

-- RegisterNetEvent("fowlmas:player:consoleRevive", function(type, postion)
--     CreateThread(function()
--         DoScreenFadeOut(800)

--         while not IsScreenFadedOut() do
--             Wait(0)
--         end

--         local player = PlayerPedId()
--         local health = GetEntityHealth(player)
--         local coords = GetEntityCoords(player)

--         --NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
--         SetPlayerInvincible(player, false)
--         ClearPedBloodDamage(player)
--         ResetPedVisibleDamage(player)
--         ClearPedLastWeaponDamage(player)


--         TriggerEvent("playerSpawned", respawnData, false)

--         StopScreenEffect('DeathFailOut')
--         DoScreenFadeIn(800)
--     end)
-- end)

local timer = 0
local clicked = false

dead_menu:IsVisible(function(Items)

    dead_menu:SetClosable(false)

    local timerHasPassed = timer:HasPassed()

    Items:Button("Envoyer un signal de détresse", nil, {}, true, {
        onSelected = function()
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            TriggerServerEvent("fowlmas:ambulance:callEmergency", coords)
        end
    })

    local label = not timerHasPassed and ("Réaparition possible dans %s"):format(timer:ShowRemaining()) or "Réapparaître"
    Items:Button(label, nil, {}, timerHasPassed, {
        onSelected = function()
            TriggerServerEvent("fowlmas:ambulance:respawn")
        end
    })

    for k, v in pairs(Config["AmbulanceJob"]["DoctorPed"]) do
        local PedPos = v.pos 
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PedPos) < 10 then
            Items:Button("Se faire soigner par le docteur", nil, {}, true, {
                onSelected = function()
                    TriggerServerEvent("fowlmas:ambulance:buyNPC")
                end
            })
        end
    end

    Items:Line()

    local desc = "~r~En cas de FreeKill veuillez utiliser ce Button tout report sans que la raison de mort soit un FreeKill le Staff se reservera le droit de vous Jail (100 Taches)"

    if (not clicked) then
        Items:Button("Faire un report", desc, {}, true, {
            onSelected = function()
                clicked = true
                TriggerServerEvent("iZeyy:Report:SendTicket", "FreeKill")
            end
        })
    else
        Items:Button("Faire un report", "Demande d'aide effectué (Report)", {}, false, {})
    end

end)

RegisterNetEvent("fowlmas:player:DeadMenu", function(bool)
    if bool then
        timer = Shared.Timer(Config["AmbulanceJob"]["RespawnTime"])
        timer:Start()
        dead_menu:Open()
        clicked = false
    else
        dead_menu:Close()
        clicked = false
    end
end)

RegisterNetEvent("fowlmas:player:receiveCall", function(data, isNew)
    if (data) then

        if (isNew) then
            ESX.ShowNotification("Un nouvel appel a été reçu")
        end

        callInWaiting = data
    end
end)

garage_menu:IsVisible(function(Items)
    local playerData = ESX.GetPlayerData()
    local grade = playerData.job.grade

    for k, v in pairs(Config["AmbulanceJob"]["GarageVehicle"]) do
        if tonumber(grade) >= tonumber(v.grade) then
            Items:Button(v.label, nil, {}, true, {
                onSelected = function()
                    TriggerServerEvent("fowlmas:ambulance:spawnVehicle", v.vehicle, v.label)
                end
            })
        end
    end
end)

local function setUniform(type)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, Config["AmbulanceJob"]["Uniform"][type].male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, Config["AmbulanceJob"]["Uniform"][type].female)
		end
	end)
end

cloakroom_menu:IsVisible(function(Items)
    Items:Button("Prendre sa tenue", nil, {}, true, {
        onSelected = function()
            setUniform("Uniforms")
            TriggerServerEvent("iZeyy:job:takeService", "ambulance", true)
            ESX.ShowNotification("Vous avez pris votre service")
            isInService = true
        end
    })

    Items:Button("Reprendre ses vêtements", nil, {}, true, {
        onSelected = function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent("iZeyy:job:takeService", "ambulance", false)
            ESX.ShowNotification("Vous avez quitter votre service")
            isInService = false
        end
    })
end)

CreateThread(function()
    local GarageZone = Game.Zone("GarageAmbulanceZone")

    GarageZone:Start(function()

        GarageZone:SetTimer(1000)
        GarageZone:SetCoords(Config["AmbulanceJob"]["Garage"])

        GarageZone:IsPlayerInRadius(8.0, function()
            GarageZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "ambulance" then

                if isInService then

                    GarageZone:Marker()

                    
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage")
                    GarageZone:IsPlayerInRadius(2.0, function()

                        GarageZone:KeyPressed("E", function()
                            garage_menu:Toggle()
                        end)

                    end, false, false)

                end

            end

        end, false, false)

        GarageZone:RadiusEvents(3.0, nil, function()
            garage_menu:Close()
        end)
    end)

    local DeleteZone = Game.Zone("DeleteAmbulanceZone")

    DeleteZone:Start(function()

        DeleteZone:SetTimer(1000)
        DeleteZone:SetCoords(Config["AmbulanceJob"]["DeleteCar"])

        DeleteZone:IsPlayerInRadius(60, function()
            DeleteZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "ambulance" then

                DeleteZone:Marker(nil, nil, 3.0)

                DeleteZone:IsPlayerInRadius(8.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")

                    DeleteZone:KeyPressed("E", function()
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

    -- local BossActionZone = Game.Zone("BossActionAmbulanceZone")

    -- BossActionZone:Start(function()

    --     BossActionZone:SetTimer(1000)
    --     BossActionZone:SetCoords(Config["AmbulanceJob"]["BossAction"])

    --     BossActionZone:IsPlayerInRadius(8.0, function()
    --         BossActionZone:SetTimer(0)
    --         local playerData = ESX.GetPlayerData()
    --         local job = playerData.job.name
    --         local grade = playerData.job.grade_name

    --         if job == "ambulance" then

    --             if isInService then

    --                 if grade == "boss" then
    --                     BossActionZone:Marker()

    --                     ESX.ShowHelpNotification("Appuyez sur ~c~["..Shared:ServerColorCode().."E~c~]~s~ pour accéder à l'action patron")
    --                     BossActionZone:IsPlayerInRadius(2.0, function()

    --                         BossActionZone:KeyPressed("E", function()
    --                             ESX.OpenSocietyMenu("ambulance")
    --                         end)

    --                     end, false, false)

    --                 end

    --             end

    --         end

    --     end, false, false)
    -- end)

    local CloakroomZone = Game.Zone("CloakroomAmbulanceZone")

    CloakroomZone:Start(function()

        CloakroomZone:SetTimer(1000)
        CloakroomZone:SetCoords(Config["AmbulanceJob"]["Cloakroom"])

        CloakroomZone:IsPlayerInRadius(5.0, function()
            CloakroomZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "ambulance" then

                CloakroomZone:Marker()

                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au vestiaire")
                CloakroomZone:IsPlayerInRadius(2.0, function()

                    CloakroomZone:KeyPressed("E", function()
                        cloakroom_menu:Toggle()
                    end)

                end, false, false)

            end

        end, false, false)

        CloakroomZone:RadiusEvents(3.0, nil, function()
            cloakroom_menu:Close()
        end)
    end)

    local PharmacyZone = Game.Zone("PharmacyAmbulanceZone")

    PharmacyZone:Start(function()

        PharmacyZone:SetTimer(1000)
        PharmacyZone:SetCoords(Config["AmbulanceJob"]["Pharmacy"])

        PharmacyZone:IsPlayerInRadius(8.0, function()
            PharmacyZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "ambulance" then

                if isInService then

                    PharmacyZone:Marker()

                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à la pharmacie")
                    PharmacyZone:IsPlayerInRadius(2.0, function()

                        PharmacyZone:KeyPressed("E", function()
                            pharmacy_menu:Toggle()
                        end)

                    end, false, false)

                end

            end

        end, false, false)

        PharmacyZone:RadiusEvents(3.0, nil, function()
            pharmacy_menu:Close()
        end)
    end)

    local Blip = AddBlipForCoord(Config["AmbulanceJob"]["BlipsPos"])
    SetBlipSprite(Blip, 61)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 2)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Hôpital")
    EndTextCommandSetBlipName(Blip)
    local BlipsZone = AddBlipForRadius(Config["AmbulanceJob"]["BlipsPos"], 1000.0)
    SetBlipSprite(BlipsZone, 1)
    SetBlipColour(BlipsZone, 2)
    SetBlipAlpha(BlipsZone, 100)

    for k, v in pairs(Config["AmbulanceJob"]["DoctorPed"]) do
        local DoctorZone = Game.Zone("DoctorZone")

        DoctorZone:Start(function()
    
            DoctorZone:SetTimer(1000)
            DoctorZone:SetCoords(v.pos)
    
            DoctorZone:IsPlayerInRadius(3.0, function()
                DoctorZone:SetTimer(0)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au docteur")
    
                DoctorZone:IsPlayerInRadius(2.0, function()
    
                    DoctorZone:KeyPressed("E", function()
                        TriggerServerEvent("fowlmas:ambulance:buyNPC")
                    end)
    
                end, false, false)
    
            end, false, false)
    
        end)
    end

    for k, v in pairs(Config["AmbulanceJob"]["DoctorPedBlips"]) do
        local Blip = AddBlipForCoord(v)
        SetBlipSprite(Blip, 61)
        SetBlipScale(Blip, 0.5)
        SetBlipColour(Blip, 2)
        SetBlipDisplay(Blip, 4)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Centre de Soins")
        EndTextCommandSetBlipName(Blip)
    end

end)

Shared:RegisterKeyMapping("iZeyy:SAMS:OpenMenu", { label = "open_menu_interactSams" }, "F6", function()
    if not IsInPVP then
        local playerData = ESX.GetPlayerData()
        local job = playerData.job.name

        if job == "ambulance" then
		    main_menu:Toggle()
        end
	end
end)