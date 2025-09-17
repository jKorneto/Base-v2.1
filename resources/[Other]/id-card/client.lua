local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local open = false
local objectCreationTimestamps = {}

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(5)
    end
end

local function CanCreateObject()
    local currentTime = GetGameTimer()
    
    for i = #objectCreationTimestamps, 1, -1 do
        if currentTime - objectCreationTimestamps[i] > 15000 then
            table.remove(objectCreationTimestamps, i)
        end
    end

    if #objectCreationTimestamps >= 4 then
        return false
    end

    table.insert(objectCreationTimestamps, currentTime)
    return true
end

local function PlayIDCardAnimation()

    if not CanCreateObject() then
        ESX.ShowNotification("Vous ne pouvez pas regarder d'objet pour l'instant. Veuillez attendre quelques secondes.")
        return
    end

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

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type)
	if (open) then open = false end

	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
	CreateThread(function()
		while (open) do
			Interval = 0
			if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
				SendNUIMessage({
					action = "close"
				})
				open = false
			end

			Wait(0)
		end
	end)
end)

RegisterNetEvent("jsfour-idcard:animation")
AddEventHandler("jsfour-idcard:animation", function()
	PlayIDCardAnimation()
end)
