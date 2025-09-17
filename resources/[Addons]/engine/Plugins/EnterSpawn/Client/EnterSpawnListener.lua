---@type EnterSpawnListener
EnterSpawnListener = Class.new(function(class)

    ---@class EnterSpawnListener: BaseObject
    local self = class
    local camera = nil
    local pedCamera = nil
    local playerNeedInteract = false
    local hasFinish = false
    local peds = {}

    ---@param coords vector3
    ---@param heading number
    ---@param dict string
    ---@param animation string
    function self:createClone(coords, heading, dict, animation)
        local player = Client.Player:GetPed()
        local coords = vector3(-2045.219, -1024.357, 11.907)
        local heading = 325.451
        local clone = CreatePed(26, GetEntityModel(player), nil, nil, nil, 0, false, false)

        Game.Streaming:RequestAnimDict("amb@prop_human_bum_shopping_cart@male@idle_a", function()
            ClonePedToTarget(player, clone)
            SetEntityCoords(clone, coords)
            SetEntityHeading(clone, heading)
            TaskPlayAnim(clone, "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 8.0, 8.0, -1, 1, 0.0, false, false, false)
        end)

        table.insert(peds, clone)
    end

    function self:createNPC()
        for k,v in pairs(Engine["Enums"].EnterSpawn.NPC) do
            local modelList = Engine["Enums"].EnterSpawn.ModelList
            local Animation = Engine["Enums"].EnterSpawn.Animations
            local modelHash = GetHashKey(modelList[math.random(1, #modelList)])

            if IsModelInCdimage(modelHash) then
                if not HasModelLoaded(modelHash) then 
                    RequestModel(modelHash) 

                    while not HasModelLoaded(modelHash) do 
                        Wait(0)  
                    end 
                end
    
                local ped = CreatePed(4, modelHash, v.pos, v.heading, false, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetEntityInvincible(ped, true)
                SetPedCanRagdoll(ped, false)
                Game.Streaming:RequestAnimDict("anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", function()
                    TaskPlayAnim(ped, "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", Animation[math.random(1, #Animation)], 8.0, -8.0, -1, 9, 1, 0, 0, 0)
                end)

                table.insert(peds, ped)
            end
        end

        return true
    end

    function self:destroyNPC()
        for k,v in pairs(peds) do
            DeleteEntity(v)
        end
    end

    ---@param camCoords vector3
    ---@param fov number
    ---@param pointCoords vector3
    function self:createCamera(camCoords, fov, pointCoords)
        if (type(camCoords) == "vector3" and type(pointCoords) == "vector3") then
            local player = Client.Player:GetPed()

            camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
            local camRot = GetCamRot(camera, 2)
            SetCamActive(camera, true)
            SetCamCoord(camera, camCoords)
            SetCamFov(camera, fov)
            PointCamAtCoord(camera, pointCoords)
            SetGameplayCamRelativeHeading(camRot.z)
            RenderScriptCams(1, 1, 1500, 0, 0)
        end
    end

    ---@param camCoords vector3
    ---@param fov number
    ---@param pointCoords vector3
    function self:createPedCamera(camCoords, fov, pointCoords)
        if (type(camCoords) == "vector3" and type(pointCoords) == "vector3") then
            local player = Client.Player:GetPed()

            pedCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
            SetCamCoord(pedCamera, camCoords)
            SetCamFov(pedCamera, fov)
            PointCamAtCoord(pedCamera, pointCoords)
        end
    end

    function self:destroyCamera()
        if DoesCamExist(camera) then
            DestroyCam(camera, false)
        end

        if DoesCamExist(pedCamera) then
            DestroyCam(pedCamera, false)
        end

        RenderScriptCams(false, false, 0, 1, 0)
    end

    ---@param duration number
    function self:followCameraDuringTransition(duration)
        Citizen.CreateThread(function()
            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < duration do
                if pedCamera and DoesCamExist(pedCamera) then
                    local ped = Client.Player:GetPed()
                    local camCoords = GetCamCoord(pedCamera)
                    local camRot = GetCamRot(pedCamera, 2)

                    FreezeEntityPosition(ped, false)
                    SetEntityCoords(ped, camCoords.x, camCoords.y, camCoords.z, false, false, false, true)
                    SetGameplayCamRelativeHeading(camRot.z)
                    FreezeEntityPosition(ped, true)
                end

                Wait(0)
            end
        end)
    end

    ---@param cameraType string | "ped" | "default"
    ---@param transitionTime number
    function self:changeCamera(cameraType, transitionTime)
        if cameraType == "ped" then
            if DoesCamExist(camera) and DoesCamExist(pedCamera) then
                SetCamActiveWithInterp(pedCamera, camera, transitionTime or 1000, true, true)
                self:followCameraDuringTransition(transitionTime or 1000)
            end
        else
            if DoesCamExist(pedCamera) and DoesCamExist(camera) then
                SetCamActiveWithInterp(camera, pedCamera, transitionTime or 1000, true, true)
                self:followCameraDuringTransition(transitionTime or 1000)
            end
        end
    end

    ---@param volume number
    ---@param position vector3
    ---@param distance number
    function self:startMusic(position, distance)
        local sound = exports["spatial_audio"]:Create({
            id = "EnterSpawnMusic",
            src = { "https://cfx-nui-engine/Nui/assets/sounds/enter.mp3" },
            distance = distance or 20,
            volume = 100
        })

        Shared.Events:ToServer(Engine["Enums"].EnterSpawn.Events.startMusic, position, distance)
    end

    function self:stopMusic()
        Shared.Events:ToServer(Engine["Enums"].EnterSpawn.Events.stopMusic)
    end

    ---@param bool boolean
    function self:enableHUD(bool)
        if (type(bool) == "boolean") then
            DisplayRadar(bool)
            TriggerEvent("iZeyy::Hud::StateHud", bool)
            TriggerEvent("iZeyy:Hud:StateStatus", bool)
        end
    end

    ---@param bool boolean
    function self:showWelcomeMessage(bool)
        exports["engine_nui"]:SendNUIMessage({
            type = "showWelcomeMessage",
            showWelcome = bool
        }, "/enterspawn", false)
    end

    function self:hasFinish()
        return hasFinish
    end

    function self:setFinish(bool)
        if (type(bool) == "boolean") then
            hasFinish = bool
        end
    end

    ---@param bool boolean
    ---@param isNewPlayer boolean
    function self:showPlayerInfo(bool, isNewPlayer)
        if (not isNewPlayer) then
            exports["engine_nui"]:SendNUIMessage({
                type = "showPlayerCard",
                showPlayerCard = bool,
                playerName = tostring(("%s %s"):format(Client.Player:GetFirstName(), Client.Player:GetLastName())) or "??",
                playerID = tostring(Client.Player:GetUniqueID()) or "??",
                playerSociety = tostring(Client.Player:GetJob().label) or "??",
                playerOrganization = tostring(Client.Player:GetJob2().label) or "??",
                playerMoney = tostring(Shared.Math:GroupDigits(Client.Player:GetMoney())) or "??",
                playerBlackMoney = tostring(Shared.Math:GroupDigits(Client.Player:GetDirtyMoney())) or "??",
                playerBank = tostring(Shared.Math:GroupDigits(Client.Player:GetBank())) or "??"
            }, "/enterspawn", true)
        else
            exports["engine_nui"]:SendNUIMessage({
                type = "showNewPlayerCard",
                showNewPlayerCard = bool,
                playerName = "??? ???",
                playerID = "?",
                playerSociety = "???",
                playerOrganization = "???",
                playerMoney = "?",
                playerBlackMoney = "?",
                playerBank = "?",
            }, "/enterspawn", true)
        end
    end

    function self:showEnterSpawn()
        self:startMusic( 
            vector3(-2052.622314, -1028.843018, 11.907584),
            50
        )

        self:enableHUD(false)
        self:createNPC()

        if (not Client.Player:IsNewPlayer()) then
            self:createClone()
        end

        self:createCamera(
            vector3(-2039.618164, -1042.811401, 15.542208),
            45.0, 
            vector3(-2048.996826, -1028.981201, 11.907735)
        )

        self:createPedCamera(
            vector3(-2045.170532, -1021.002075, 12.524987),
            35.0, 
            vector3(-2045.219, -1024.357, 11.907)
        )

        SetTimeout(2000, function()
            self:showWelcomeMessage(true)
            playerNeedInteract = true

            CreateThread(function()
                while playerNeedInteract do
                    if IsControlJustPressed(1, 51) then
                        playerNeedInteract = false
                        self:changeCamera("ped", 3000)
                        self:showWelcomeMessage(false)
                        Wait(3000)
                        self:showPlayerInfo(true, Client.Player:IsNewPlayer())
                    end
                    Wait(0)
                end
            end)
        end)
    end

    return self
end)