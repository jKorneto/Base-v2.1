local Status, isPaused = {}, false
local ESX = exports["Framework"]:getSharedObject()
local playerSpawned = false

local function GetStatusData()
    local status = {}

    for _, stat in ipairs(Status) do
        local data = {
            name    = stat.name,
            val     = stat.val,
            percent = (stat.val / 1000000) * 100
        }
        table.insert(status, data)
    end

    return status
end

AddEventHandler("engine:enterspawn:finish", function()
    playerSpawned = true
end)

AddEventHandler("fowlmas:status:register", function(name, default, tickCallback)
    local status = CreateStatus(name, default, tickCallback)
    table.insert(Status, status)
end)

AddEventHandler("fowlmas:status:unregister", function(name)
    for k, v in ipairs(Status) do
        if v.name == name then
            table.remove(Status, k)
            break
        end
    end
end)

RegisterNetEvent("fowlmas:status:load", function(status)
    for _, stat in ipairs(Status) do
        for _, s in ipairs(status) do
            if stat.name == s.name then
                stat.set(s.val)
            end
        end
    end

    Citizen.CreateThread(function()
        while true do
            for _, stat in ipairs(Status) do
                stat.onTick()
            end
            Citizen.Wait(5000)
        end
    end)
end)

local function checkStatus()
    if (playerSpawned) then
        local player = PlayerPedId()
        local prevHealth = GetEntityHealth(player)
        local health = prevHealth
        local isFemale = (GetEntityModel(player) == GetHashKey("mp_f_freemode_01"))
        local lowHealthThreshold = isFemale and 50 or 150
        local hungerLevel, thirstLevel = 100, 100

        local function updateHealth(status)
            local level = math.floor(status.getPercent())
            if level <= 0 then
                health = health - (prevHealth <= lowHealthThreshold and 15 or 5)
            end
            return level
        end

        TriggerEvent('fowlmas:status:get', 'hunger', function(hunger)
            hungerLevel = updateHealth(hunger)
        end)

        TriggerEvent('fowlmas:status:get', 'thirst', function(thirst)
            thirstLevel = updateHealth(thirst)
        end)

        Wait(50)

        if hungerLevel <= 5 then
            ESX.ShowNotification("Pensez à manger vous avez faim")
        end

        if thirstLevel <= 5 then
            ESX.ShowNotification("Pensez à boire vous avez soif")
        end

        if (hungerLevel <= 0 or thirstLevel <= 0) and health ~= prevHealth then
            SetEntityHealth(player, health)
        end
    end
end


local function updateStatusUI()
    local info = GetStatusData()
    local sendThirst, sendHunger = 0, 0

    for _, v in pairs(info) do
        if v.name == "thirst" then
            sendThirst = v.percent
        elseif v.name == "hunger" then
            sendHunger = v.percent
        end
    end

    Wait(500)

    SendNUIMessage({
        type = "updatePlayerStatus",
        thirstLevel = sendThirst,
        hungerLevel = sendHunger
    })
end

RegisterNetEvent("fowlmas:status:set", function(name, val)
    for _, stat in ipairs(Status) do
        if stat.name == name then
            stat.set(val)
            break
        end
    end
    updateStatusUI()
end)

RegisterNetEvent("fowlmas:status:add", function(name, val)
    for _, stat in ipairs(Status) do
        if stat.name == name then
            stat.add(val)
            break
        end
    end
    updateStatusUI()
end)

RegisterNetEvent("fowlmas:status:remove", function(name, val)
    for _, stat in ipairs(Status) do
        if stat.name == name then
            stat.remove(val)
            break
        end
    end
    updateStatusUI()
end)

AddEventHandler("fowlmas:status:get", function(name, cb)
    for _, stat in ipairs(Status) do
        if stat.name == name then
            cb(stat)
            return
        end
    end
end)

local function loadStatus()
    TriggerEvent('fowlmas:status:register', 'hunger', 1000000, function(status) 
        status.remove(250)     
    end)
    TriggerEvent('fowlmas:status:register', 'thirst', 1000000, function(status)
        status.remove(350) 
    end)

    updateStatusUI()
end

CreateThread(function()
    loadStatus()

    while true do
		updateStatusUI()
        checkStatus()
        TriggerServerEvent("fowlmas:status:update", GetStatusData())
        Wait(30000)
    end
end)
