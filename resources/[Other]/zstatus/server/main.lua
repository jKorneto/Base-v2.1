local ESX = exports["Framework"]:getSharedObject()

local function loadPlayerStatus(xPlayer)
    MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local data = result[1].status and json.decode(result[1].status) or {}
        xPlayer.set('status', data)
        TriggerClientEvent('fowlmas:status:load', xPlayer.source, data)
    end)
end

AddEventHandler('esx:playerLoaded', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if (xPlayer) then
        loadPlayerStatus(xPlayer)
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        local status = xPlayer.get('status')
        MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
            ['@status']     = json.encode(status),
            ['@identifier'] = xPlayer.identifier
        })
    end
end)

AddEventHandler('fowlmas:status:get', function(playerId, statusName, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        local status = xPlayer.get('status')
        while not status do
            Citizen.Wait(100)
            status = xPlayer.get('status')
        end

        for _, stat in ipairs(status) do
            if stat.name == statusName then
                cb(stat)
                break
            end
        end
    end
end)

RegisterServerEvent('fowlmas:status:update', function(status)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.set('status', status)
    end
end)

local function SaveData()
    local xPlayers = ESX.GetPlayers()

    for _, playerId in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            local status = xPlayer.get('status')
            MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
                ['@status']     = json.encode(status),
                ['@identifier'] = xPlayer.identifier
            })
        end
    end

    SetTimeout(10 * 60 * 1000, SaveData)
end

SaveData()