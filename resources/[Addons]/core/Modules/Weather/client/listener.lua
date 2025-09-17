local currentHour = 0
local currentMinute = 0
local freezeTime = false
local currentZone = nil
local currentWeather = ""
local playerSpawned = false

local function startTimeSync()
    CreateThread(function()
        while true do
            Wait(5000)

            if (not freezeTime) then
                currentMinute += 1

                if (currentMinute >= 60) then
                    currentMinute = 0
                    currentHour += 1
                end

                if (currentHour >= 24) then
                    currentHour = 0
                end

                SetClockTime(currentHour, currentMinute, 0)
                NetworkOverrideClockTime(currentHour, currentMinute, 0)
            end
        end
    end)
end

local function getCurrentWeather()
    return currentWeather
end

local function getCurrentTime()
    return currentHour, currentMinute
end

local function isTimeFrozen()
    return freezeTime
end

exports("GetCurrentWeather", getCurrentWeather)
exports("GetCurrentTime", getCurrentTime)
exports("IsTimeFrozen", isTimeFrozen)

AddEventHandler("engine:enterspawn:finish", function()
    playerSpawned = true
end)

RegisterNetEvent("core:weather:receiveTime", function(hour, minute)
    if (hour and minute) then
        currentHour = hour
        currentMinute = minute

        SetClockTime(hour, minute, 0)
        NetworkOverrideClockTime(hour, minute, 0)
        startTimeSync()
    end
end)

RegisterNetEvent("core:weather:receiveWeather", function(weather, zoneName)
    if (currentZone == zoneName or zoneName == "all") then
        if (currentWeather ~= weather) then
            currentWeather = weather
            SetWeatherTypeOverTime(weather, 10.0)
            Wait(10000)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(weather)
            SetWeatherTypeNow(weather)
            SetWeatherTypeNowPersist(weather)
        end
    end
end)

RegisterNetEvent("core:weather:freezeTime", function(bool)
    freezeTime = bool
end)

function isPlayerInZone(coords, zoneName)
    for _, zone in ipairs(Config["Weather"]["Zones"]) do
        if (zone.name == zoneName) then
            if (coords.x >= zone.coords.x1 and coords.x <= zone.coords.x2 and coords.y >= zone.coords.y1 and coords.y <= zone.coords.y2) then
                return true
            end
        end
    end
    return false
end

CreateThread(function()
    while true do
        if (playerSpawned) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local newZone = nil

            for _, zone in ipairs(Config["Weather"]["Zones"]) do
                if isPlayerInZone(playerCoords, zone.name) then
                    newZone = zone.name
                    break
                end
            end
            
            if (newZone and newZone ~= currentZone) then
                currentZone = newZone
                TriggerServerEvent("core:weather:requestWeather", playerCoords)
            end
        end

        Wait(5000)
    end
end)