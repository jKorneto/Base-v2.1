local currentHour = 18
local currentMinute = 30
local currentWeather = "EXTRASUNNY"
local frezzeTime = false
local players = {}

local Weather = {
    ["EXTRASUNNY"] = true,
    ["CLEARING"] = true,
    ["CLOUDS"] = true,
    ["SMOG"] = true,
    ["FOGGY"] = true,
    ["OVERCAST"] = true,
    ["RAIN"] = true,
    ["THUNDER"] = true,
    ["CLEAR"] = true,
    ["SNOWLIGHT"] = true,
    ["BLIZZARD"] = true,
    ["HALLOWEEN"] = true,
    ["XMAS"] = true,
    ["NEUTRAL"] = true
}

local function isValidWeather(weather)
    if (Weather[weather:upper()]) then
        return true
    end

    return false
end

local function isValidZone(zone)
    for _, v in ipairs(Config["Weather"]["Zones"]) do
        if (v.name == zone) then
            return v
        end
    end

    return false
end

local function getAllZoneNames()
    local zoneNames = {}

    for _, z in ipairs(Config["Weather"]["Zones"]) do
        table.insert(zoneNames, z.name)
    end

    return table.concat(zoneNames, ", ")
end

local function setGlobalWeather(weather)
    weather = weather:upper()

    if (weather) then
        if (isValidWeather(weather)) then
            for _, zone in ipairs(Config["Weather"]["Zones"]) do
                zone.currentWeather = weather
                zone.lastUpdateTime = GetGameTimer()
            end

            TriggerClientEvent("core:weather:receiveWeather", -1, weather , "all")
            return true
        else
            Shared.Log:Error("The weather ^4" .. weather .. "^7 doesn't exist")
            return false
        end
    end
end

local function setTime(hour, minute)
    if (hour and minute) then
        if (hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59) then
            currentHour = hour
            currentMinute = minute
            TriggerClientEvent("core:weather:receiveTime", -1, currentHour, currentMinute)
            return true
        else
            return Shared.Log:Error("The time is invalid")
        end
    end
end

local function freezeTime()
    frezzeTime = not frezzeTime
    TriggerClientEvent("core:weather:freezeTime", -1, frezzeTime)
    return true
end

local function GetClockHours()
    return currentHour, currentMinute
end

CreateThread(function()
    while true do
        if (not frezzeTime) then
            currentMinute += 1

            if (currentMinute >= 60) then
                currentMinute = 0
                currentHour += 1
            end

            if (currentHour >= 24) then
                currentHour = 0
            end

            if (next(players)) then
                for k, v in pairs(players) do
                    TriggerClientEvent("core:weather:receiveTime", k, currentHour, currentMinute)
                    players[k] = nil
                end
            end
        end

        Wait(5000)
    end
end)

RegisterCommand("setweather", function(source, args)
    if (source == 0) then
        if (args[1]) then
            local weather = args[1]:upper()

            if (isValidWeather(weather)) then
                if (args[2]) then
                    local zoneName = table.concat(args, " ", 2)
                    local zone = isValidZone(zoneName)

                    if (zone) then
                        zone.currentWeather = weather
                        TriggerClientEvent("core:weather:receiveWeather", -1, weather, zone.name)
                        Shared.Log:Success("Weather for zone '^4" .. zoneName .. "^7' is now '^4" .. weather .. "^7'^3.^7")
                    else
                        local allZoneNames = getAllZoneNames()
                        Shared.Log:Error("The zone ^4" .. zoneName .. "^7 doesn't exist. Available zones are: ^7" .. allZoneNames)
                    end
                else
                    if (setGlobalWeather(weather)) then
                        Shared.Log:Success("Weather for all zones is now '^4" .. weather .. "^7'^3.^7")
                    end
                end
            else
                Shared.Log:Error("The weather ^4" .. args[1] .. "^7 doesn't exist")
            end
        else
            Shared.Log:Error("Usage: /setweather <weather> [zone]")
        end
    end
end)

RegisterCommand("time", function(source, args)
    if (source == 0) then
        if (args[1] and args[2]) then
            if (setTime(tonumber(args[1]), tonumber(args[2]))) then
                Shared.Log:Success("Time is now '^4" .. args[1] .. ":" .. args[2] .. "^7'^3.^7")
            end
        else
            Shared.Log:Error("Usage: /time <hour> <minute>")
        end
    end
end)

RegisterCommand("freezetime", function(source, args)
    if (source == 0) then
        if (freezeTime()) then
            Shared.Log:Success("Time is now '^4" .. (frezzeTime and "FROZEN" or "UNFROZEN") .. "^7'^3.^7")
        end
    end
end)

local function getRandomWeatherForPeriod(period)
    local weatherOptions = Config["Weather"]["Chances"][period]
    local totalWeight = 0

    for _, option in ipairs(weatherOptions) do
        totalWeight = totalWeight + option.weight
    end

    local randomWeight = math.random() * totalWeight

    for _, option in ipairs(weatherOptions) do
        if (randomWeight < option.weight) then
            return option.weather
        end

        randomWeight = randomWeight - option.weight
    end

    return "CLEAR"
end

local function getCurrentTimePeriod()
    local hour = GetClockHours()

    if (hour >= 6 and hour < 12) then
        return 'morning'
    elseif (hour >= 12 and hour < 18) then
        return 'day'
    elseif (hour >= 18 and hour < 21) then
        return 'evening'
    else
        return 'night'
    end
end

local function updateWeatherForZone(zone)
    local period = getCurrentTimePeriod()
    local stockWeather = zone.currentWeather
    local randomWeather = getRandomWeatherForPeriod(period)

    if (stockWeather ~= randomWeather) then
        zone.currentWeather = randomWeather
        Shared.Log:Success("Weather for zone '^4" .. zone.name .. "^7' is now '^4" .. zone.currentWeather .. "^7'^3.^7")
        TriggerClientEvent("core:weather:receiveWeather", -1, zone.currentWeather or "CLEAR", zone.name)
    end

    zone.lastUpdateTime = GetGameTimer()
    
    return zone.currentWeather
end

CreateThread(function()
    while true do
        math.randomseed(os.time())

        for _, zone in ipairs(Config["Weather"]["Zones"]) do
            if not zone.lastUpdateTime or (GetGameTimer() - zone.lastUpdateTime > 60000 * 10) then
                updateWeatherForZone(zone)
            end
        end

        Wait(10000)
    end
end)

local function getZoneForCoords(x, y)
    for _, zone in ipairs(Config["Weather"]["Zones"]) do
        if (x >= zone.coords.x1 and x <= zone.coords.x2 and y >= zone.coords.y1 and y <= zone.coords.y2) then
            return zone
        end
    end

    return nil
end

RegisterNetEvent("core:weather:requestWeather", function(playerCoords)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if (type(xPlayer) == "table") then
        local zone = getZoneForCoords(playerCoords.x, playerCoords.y)

        if (zone) then
            local weather = zone.currentWeather
            TriggerClientEvent("core:weather:receiveWeather", xPlayer.source, weather or "CLEAR", zone.name)
        end
    end
end)

AddEventHandler("engine:enterspawn:finish", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        players[xPlayer.source] = true
    end
end)