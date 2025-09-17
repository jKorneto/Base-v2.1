function InteractMenuFreeCam()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not isFreecamActive then
        freecam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(freecam, playerCoords.x, playerCoords.y, playerCoords.z + .0)
        SetCamActive(freecam, true)
        RenderScriptCams(true, false, 0, true, true)
        isFreecamActive = true
        initialPlayerCoords = playerCoords

        TaskStandStill(playerPed, -1)

        CreateThread(function()
            while isFreecamActive do
                Wait(0)

                -- Désactiver certaines actions du joueur
                DisableControlAction(0, 21, true)  -- Sprint
                DisableControlAction(0, 22, true)  -- Jump
                DisableControlAction(0, 30, true)  -- Move left/right
                DisableControlAction(0, 31, true)  -- Move up/down

                -- Gestion de la rotation de la caméra
                local mouseX, mouseY = GetDisabledControlNormal(0, 1), GetDisabledControlNormal(0, 2)
                local camRot = GetCamRot(freecam, 2)
                local newCamRot = vector3(camRot.x - mouseY * 10.0, 0.0, camRot.z - mouseX * 10.0)
                SetCamRot(freecam, newCamRot, 2)

                -- Déplacement de la caméra
                local camCoords = GetCamCoord(freecam)
                local forwardVector = InteractMenuRotAnglesToVec(GetCamRot(freecam, 2))

                -- Calcul de la nouvelle position cible
                local targetCoords = camCoords

                if IsControlPressed(0, 32) then -- Z
                    targetCoords = vector3(camCoords.x + forwardVector.x * 0.1, camCoords.y + forwardVector.y * 0.1, camCoords.z + forwardVector.z * 0.1)
                end

                if IsControlPressed(0, 33) then -- S
                    targetCoords = vector3(camCoords.x - forwardVector.x * 0.1, camCoords.y - forwardVector.y * 0.1, camCoords.z - forwardVector.z * 0.1)
                end

                if IsControlPressed(0, 34) then -- Q
                    local rightVector = InteractMenuRotAnglesToVec(GetCamRot(freecam, 2) + vector3(0, 0, 90))
                    targetCoords = vector3(camCoords.x + rightVector.x * 0.1, camCoords.y + rightVector.y * 0.1, camCoords.z + rightVector.z * 0.1)
                end

                if IsControlPressed(0, 35) then -- D
                    local leftVector = InteractMenuRotAnglesToVec(GetCamRot(freecam, 2) + vector3(0, 0, -90))
                    targetCoords = vector3(camCoords.x + leftVector.x * 0.1, camCoords.y + leftVector.y * 0.1, camCoords.z + leftVector.z * 0.1)
                end

                -- Raycast pour détecter les collisions
                local _, hit, hitCoords, _, _ = GetShapeTestResult(StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, -1, -1, 0))

                if hit then
                    -- Si la caméra est bloquée, elle ne bouge pas plus loin
                    SetCamCoord(freecam, camCoords.x, camCoords.y, camCoords.z)
                else
                    -- Sinon, mettre à jour la position de la caméra
                    SetCamCoord(freecam, targetCoords.x, targetCoords.y, targetCoords.z)
                end

                -- Vérification de la distance maximale
                if #(camCoords - initialPlayerCoords) > 10.0 then
                    Game.Notification:showNotification("Destruction de la caméra, vous êtes trop loin de votre position initiale.")
                    InteractMenuStopFreecam()
                end

                -- Sortie de la caméra avec BACKSPACE
                if IsControlJustPressed(0, 177) then -- BACKSPACE
                    InteractMenuStopFreecam()
                end
            end
        end)
    else
        InteractMenuStopFreecam()
    end
end

function InteractMenuStopFreecam()
    if isFreecamActive then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(freecam, false)
        isFreecamActive = false

        local playerPed = PlayerPedId()
        ClearPedTasksImmediately(playerPed)
        EnableControlAction(0, 21, true)  -- Sprint
        EnableControlAction(0, 22, true)  -- Jump
        EnableControlAction(0, 30, true)  -- Move left/right
        EnableControlAction(0, 31, true)  -- Move up/down
    end
end

function InteractMenuRotAnglesToVec(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

-- ShowHud
local HudVisible = true
local StatusVisible = true
local InfoVisible = true

function InteractMenuShowHud()
	HudVisible = not HudVisible
	if HudVisible then
		TriggerEvent('iZeyy:Hud:StateStatus', true)
        TriggerEvent("iZeyy::Hud::StateHud", true)
	else
		TriggerEvent('iZeyy:Hud:StateStatus', false)
        TriggerEvent("iZeyy::Hud::StateHud", false)
	end
end

function InteractStatusHud()
	StatusVisible = not StatusVisible
	if StatusVisible then
        TriggerEvent('iZeyy:Hud:StateStatus', true)
	else
        TriggerEvent('iZeyy:Hud:StateStatus', false)
	end
end

function InteractInfoHud()
	InfoVisible = not InfoVisible
	if InfoVisible then
        TriggerEvent("iZeyy::Hud::StateHud", true)
	else
        TriggerEvent("iZeyy::Hud::StateHud", false)
	end
end

-- ShowRadar
local RadarVisible = true
function InteractMenuShowRadar()
	RadarVisible = not RadarVisible
	if RadarVisible then
		DisplayRadar(true)
	else
		DisplayRadar(false)
	end
end

-- PlayerHelmet
local UseHelmet = false
function InteractMenuPlayerHelmet()
	UseHelmet = not UseHelmet
	if UseHelmet then
		SetPedHelmet(PlayerPedId(), false)
		Game.Notification:showNotification("Casque de moto retiré")
	else
		SetPedHelmet(PlayerPedId(), true)
		Game.Notification:showNotification("Casque de moto equipé")
	end
end

local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function PlayIDCardAnimation()
    local ped = PlayerPedId()
    local animDict = "cop_badge_1@dad"
    local animName = "cop_badge_1_clip"
    local propModel = "prop_franklin_dl"
    local propBone = 28422
    local propCoords = vector3(0.0840, 0.0200, -0.0260)
    local propRot = vector3(-173.8514, -88.0171, 63.0612)

    LoadAnimDict(animDict)

    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(5)
    end

    local prop = CreateObject(GetHashKey(propModel), 0, 0, 0, true, true, false)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, propBone), propCoords.x, propCoords.y, propCoords.z, propRot.x, propRot.y, propRot.z, true, true, false, true, 1, true)

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 51, 0, false, false, false)

    SetTimeout(5000, function()
        ClearPedTasksImmediately(ped)
        DeleteObject(prop)
    end)
end

RegisterNetEvent('hud:cinema')
AddEventHandler('hud:cinema', function()
    noir = not noir
    if noir then 
		TriggerEvent('iZeyy:Hud:StateStatus', false)
        TriggerEvent("iZeyy::Hud::StateHud", false)
        DisplayRadar(false) 
    end
    while noir do
        if not HasStreamedTextureDictLoaded('revolutionbag') then
            RequestStreamedTextureDict('revolutionbag')
            while not HasStreamedTextureDictLoaded('revolutionbag') do
                Wait(50)
            end
        end

        DrawSprite('revolutionbag', 'cinema', 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        Wait(0)
    end
	TriggerEvent('iZeyy:Hud:StateStatus', true)
    TriggerEvent("iZeyy::Hud::StateHud", true)
    DisplayRadar(true)
    SetStreamedTextureDictAsNoLongerNeeded('revolutionbag')
end)