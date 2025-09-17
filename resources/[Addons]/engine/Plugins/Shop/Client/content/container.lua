local props = {}
local mystery_preview_menu = shopStorage:Get("mystery_preview_menu")

local function spawnObject(model, coords)
    local propHash = type(model) == 'string' and joaat(model) or model
    Game.Streaming:RequestModel(propHash)
    local object = CreateObject(propHash, coords.xyz, true, false, false)
    while not DoesEntityExist(object) do
        Wait(10)
    end

    SetEntityAsMissionEntity(object, true, true)
    FreezeEntityPosition(object, true)
    SetEntityHeading(object, coords.w)

    SetModelAsNoLongerNeeded(propHash)
    return object
end

local function destroCaseCam()
    RenderScriptCams(0, 1, 1500, 0, 0)
    SetCamActive(cam, false)
    ClearPedTasks(PlayerPedId())
    DestroyAllCams()
end

local function DrawText3D(x, y, scale, text, red, green, blue, alpha)
    SetTextFont(ServerFontStyle)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(red, green, blue, alpha)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local function showReward(item, isBuy)
    local running = true
    local rewardTaken = false
    local refundTriggered = false

    while running do
        DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 200)
        DrawText3D(0.5, 0.48, 1.0, "Vous avez gagné : "..item, 255, 255, 255, 255)

        if isBuy then
            DrawText3D(0.5, 0.55, 0.7, "[E] Prendre    [R] Rembourser", 255, 255, 255, 255)

            if IsControlJustReleased(0, 38) then
                rewardTaken = true
                running = false
            elseif IsControlJustReleased(0, 45) then
                refundTriggered = true
                running = false
            end
        else
            DrawText3D(0.5, 0.55, 0.7, "[E] Continuer", 255, 255, 255, 255)

            if IsControlJustReleased(0, 38) then
                rewardTaken = true
                running = false
            end
        end

        Wait(0)
    end

    destroCaseCam()
    TriggerEvent('iZeyy:Hud:StateStatus', true)
    TriggerEvent("iZeyy::Hud::StateHud", true)
    DisplayRadar(true)

    if isBuy then
        if rewardTaken then
            Shared.Events:ToServer(Engine["Enums"].Shop.Events.acceptMysteryReward, isBuy)
        elseif refundTriggered then
            Shared.Events:ToServer(Engine["Enums"].Shop.Events.refundMysteryReward)
        end
    else
        Shared.Events:ToServer(Engine["Enums"].Shop.Events.acceptMysteryReward, isBuy)
    end
end

local function createShopCam(index)
	CreateThread(function()
		if (index == 1) then
			cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
			SetCamActive(cam, true)
			SetCamCoord(cam, -1074.261475, -71.904686, -94.599785)
			SetCamFov(cam, 55.0)
			PointCamAtCoord(cam, vector3(-1072.476196, -72.729370, -94.599785))
			RenderScriptCams(1, 1, 1500, 0, 0)
		elseif (index == 2) then
			cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
			SetCamActive(cam, true)
			SetCamCoord(cam, -1072.592163, -70.505035, -94.599785)
			SetCamFov(cam, 50.0)
			PointCamAtCoord(cam, vector3(-1072.476196, -72.729370, -94.599785))
			RenderScriptCams(1, 1, 1500, 0, 0)
		end
	end)
end

local function doContainerAnim(item, isBuy)
    local container = NetworkGetEntityFromNetworkId(NetworkGetNetworkIdFromEntity(props.container))
    local lock = NetworkGetEntityFromNetworkId(NetworkGetNetworkIdFromEntity(props.lock))
    local collision = NetworkGetEntityFromNetworkId(NetworkGetNetworkIdFromEntity(props.collision))

    NetworkRequestControlOfEntity(container)
    NetworkRequestControlOfEntity(lock)
    local timer = GetGameTimer()

    while not NetworkHasControlOfEntity(container) or not NetworkHasControlOfEntity(lock) do
        Wait(0)
        if GetGameTimer() - timer > 5000 then
            print("Failed to get control of object")
            break
        end
    end

    Game.Streaming:RequestAnimDict("anim@scripted@player@mission@tunf_train_ig1_container_p1@male@")
    Game.Streaming:RequestNamedPtfxAsset("scr_tn_tr")
    Game.Streaming:RequestNamedAudioAsset("dlc_tuner/dlc_tuner_generic")
    
    local grinderHash = GetHashKey("tr_prop_tr_grinder_01a")
    local bagHash = GetHashKey("hei_p_m_bag_var22_arm_s")
    Game.Streaming:RequestModel(grinderHash)
    Game.Streaming:RequestModel(bagHash)

    local ped = PlayerPedId()
    local containerCoords = GetEntityCoords(container)
    local containerRot = GetEntityRotation(container)
    local playerCoords = GetEntityCoords(ped)
    local grinder = CreateObject(grinderHash, playerCoords, true, true, false)
    local bag = CreateObject(bagHash, playerCoords, true, true, false)
    SetEntityCollision(bag, false, false)

    FreezeEntityPosition(ped, true)
	DisplayRadar(false)
	createShopCam(1)
    
    local containerScene = NetworkCreateSynchronisedScene(containerCoords, containerRot, 2, true, false, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, containerScene, "anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", "action", 10.0, 10.0, 0, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(lock, containerScene, "anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", "action_lock", 2.0, -4.0, 134149)
    NetworkAddEntityToSynchronisedScene(grinder, containerScene, "anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", "action_angle_grinder", 2.0, -4.0, 134149)
    NetworkAddEntityToSynchronisedScene(bag, containerScene, "anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", "action_bag", 2.0, -4.0, 134149)
    NetworkStartSynchronisedScene(containerScene)

    PlayEntityAnim(container, "action_container", "anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", 8.0, false, true, false, 0, 0)   
    
    CreateThread(function()
        while NetworkGetLocalSceneFromNetworkId(containerScene) == -1 do Wait(0) end
        local localScene = NetworkGetLocalSceneFromNetworkId(containerScene)
        local ptfx
        
        while IsSynchronizedSceneRunning(localScene) do
            if HasAnimEventFired(ped, -1953940906) then
                UseParticleFxAsset("scr_tn_tr")
                ptfx = StartNetworkedParticleFxLoopedOnEntity("scr_tn_tr_angle_grinder_sparks", grinder, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 1)
            elseif HasAnimEventFired(ped, -258875766) then
                StopParticleFxLooped(ptfx, false)
				createShopCam(2)
            end
            Wait(0)
        end
    end)
    
    Wait(GetAnimDuration("anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", "action_container") * 1000)
    
    FreezeEntityPosition(ped, false)
    NetworkStopSynchronisedScene(containerScene)

	TaskGoStraightToCoord(ped, Engine["Config"]["Shop"]["containerZone"], 3.0, 500, 121.89, 1.0)
    DeleteEntity(bag)
    DeleteEntity(grinder)
    showReward(item, isBuy)

    DeleteEntity(lock)
    DeleteEntity(container)
    ClearPedTasks(ped)

    DisposeSynchronizedScene(containerScene)
    RemoveNamedPtfxAsset("scr_tn_tr")
    ReleaseNamedScriptAudioBank("dlc_tuner/dlc_tuner_generic")
    RemoveAnimDict("anim@scripted@player@mission@tunf_train_ig1_container_p1@male@")

    DoScreenFadeOut(500)
    Wait(500)
    Client.Shop:teleportToLastPosition()
    Client.Shop:changeBucket(true)
    Client.Shop:toggleHud(true)
    Wait(1000)
    DoScreenFadeIn(500)
end

local function spawnContainer(coords, item, isBuy)
    Game.Streaming:RequestAnimDict("anim@scripted@player@mission@tunf_train_ig1_container_p1@male@")
    local container = spawnObject("tr_prop_tr_container_01a", vector4(coords.x, coords.y, coords.z - 1, coords.w - 180))
    local containerCoords = GetEntityCoords(container)
    
    local lockCoords = GetAnimInitialOffsetPosition("anim@scripted@player@mission@tunf_train_ig1_container_p1@male@", "action_lock", GetEntityCoords(container), GetEntityRotation(container), 0.0, 0)
    local lock = spawnObject("tr_prop_tr_lock_01a", vector4(lockCoords, coords.w - 180))
    SetEntityCoords(lock, lockCoords)

    local crateCoords = GetObjectOffsetFromCoords(coords, 0.0, -0.6, -0.8)
    local crate = spawnObject("tr_prop_tr_crates_sam_01a", vector4(crateCoords, coords.w + 90))

    local collision = spawnObject("tr_prop_tr_cont_coll_01a", vector4(containerCoords, coords.w - 180))
    SetEntityCoords(collision, containerCoords, false, false, false)
    SetEntityCollision(collision, false, false)
    
    props = {
        container = container, 
        lock = lock,
        crate = crate,
        collision = collision,
    }

    doContainerAnim(item, isBuy)

    return props

end

Shared.Events:OnNet(Engine["Enums"].Shop.Events.startAnimationMystery, function(reward, isBuy)
    if (type(reward) == "string") then
        local player = Client.Player:GetPed()
        DoScreenFadeOut(500)
        Wait(500)
        Client.Shop:getLastPosition()
        Client.Shop:changeBucket()
        Client.Shop:toggleHud(false)
        mystery_preview_menu:Toggle()

        RequestCollisionAtCoord(Engine["Config"]["Shop"]["containerZone"])
        while IsEntityWaitingForWorldCollision() do
            Wait(0)
        end

        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
        SetEntityCoords(player, Engine["Config"]["Shop"]["containerZone"])

        Wait(500)
        DoScreenFadeIn(500)

        spawnContainer(Engine["Config"]["Shop"]["containerPreview"], reward, isBuy)
    end
end)
