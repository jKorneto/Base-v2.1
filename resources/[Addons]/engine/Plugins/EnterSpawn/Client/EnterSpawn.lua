exports("enterSpawn", function()
    return Client.EnterSpawn:showEnterSpawn()
end)

exports("hasFinishEnterSpawn", function()
    return Client.EnterSpawn:hasFinish()
end)

RegisterNUICallback('teleportToLastPosition', function(data, cb)
    local player = Client.Player:GetPed()
    local lastCoords = Client.Player:GetLastPosition()

    DoScreenFadeOut(1000)
    Wait(1000)
    Client.EnterSpawn:showPlayerInfo(false, false)
    Client.EnterSpawn:destroyCamera()
    SetEntityCoords(player, lastCoords)
    SetEntityVisible(player, true)
    FreezeEntityPosition(player, false)
    Shared.Events:ToServer(Engine["Enums"].Vehicles.Events.RequestSeat)
    Wait(1000)
    DoScreenFadeIn(1000)

    Client.EnterSpawn:enableHUD(true)
    Client.EnterSpawn:setFinish(true)
    Client.EnterSpawn:stopMusic()
    Client.EnterSpawn:destroyNPC()
    exports["engine_nui"]:SetNuiFocus(false, false)
    TriggerEvent("engine:enterspawn:finish")
    cb('ok')
end)

RegisterNUICallback('createNewPlayer', function(data, cb)
    local player = Client.Player:GetPed()
    
    DoScreenFadeOut(1000)
    Wait(1000)
    Client.EnterSpawn:showPlayerInfo(false, true)
    Client.EnterSpawn:destroyCamera()
    Client.EnterSpawn:setFinish(true)
    Client.EnterSpawn:stopMusic()
    Client.EnterSpawn:destroyNPC()
    SetEntityVisible(player, true)
    FreezeEntityPosition(player, false)
    Wait(1000)
    DoScreenFadeIn(1000)
    exports["engine_nui"]:SetNuiFocus(false, false)
    exports["epicenter"]:openCreatorMenu()
    cb('ok')
end)

local function FreezePlayer(player)
	SetPlayerControl(player, true, false)
	local ped = GetPlayerPed(player)

    if (IsEntityVisible(ped)) then
        SetEntityVisible(ped, false)
    end

    SetEntityCollision(ped, false)
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(player, true)

    if (not IsPedFatallyInjured(ped)) then
        ClearPedTasksImmediately(ped)
    end
end

RegisterNetEvent("engine:enterspawn:playerspawned", function(model)
    local player = PlayerId()
    local coords = vector3(-2039.618, -1042.811, 15.542)
    local heading = 45.0

    if (model) then
        FreezePlayer(player)
        RequestModel(GetHashKey(model))

        Game.Streaming:RequestModel(GetHashKey(model), function()
            SetPlayerModel(player, GetHashKey(model))
            SetModelAsNoLongerNeeded(GetHashKey(model))
        end)

        player = PlayerPedId()

        RequestCollisionAtCoord(coords)
        SetEntityCoordsNoOffset(player, coords, false, false, false, true)
        NetworkResurrectLocalPlayer(coords, heading, true, true, false)

        ClearPedTasksImmediately(player)
        RemoveAllPedWeapons(player)

        while not HasCollisionLoadedAroundEntity(player) do
            Wait(100)
        end
    end

    DoScreenFadeIn(2000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    TriggerEvent("playerSpawned", coords, true)
end)