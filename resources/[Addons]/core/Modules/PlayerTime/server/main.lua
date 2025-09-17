PlayeTime = {}

AddEventHandler('esx:playerLoaded', function(source)
    StartPlayerTime(source)
end)

AddEventHandler('esx:playerDropped', function(source)
    SaveTimePlayed(source)
    PlayeTime[source] = nil
end)

function StartPlayerTime(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM playtime WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            PlayeTime[source] = {
                source = source,
                timeplayed = result[1].timeplayed
            }
            TriggerClientEvent("iZeyy:PlayerTime:StartTimer", source, result[1].timeplayed)
        else
            MySQL.Async.execute("INSERT INTO playtime (identifier, timeplayed) VALUES (@identifier, @timeplayed)", {
                ['@identifier'] = xPlayer.identifier,
                ['@timeplayed'] = 0
            }, function(rowsChanged)
                PlayeTime[source] = {
                    source = source,
                    timeplayed = 0
                }
                TriggerClientEvent("iZeyy:PlayerTime:StartTimer", source, 0)
            end)
        end
    end)
end

function SaveTimePlayed(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if PlayeTime[source] then
        MySQL.Async.execute("UPDATE playtime SET timeplayed = @timeplayed WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.identifier,
            ['@timeplayed'] = PlayeTime[source].timeplayed
        }, function(rowsChanged)

        end)
    end
end

RegisterServerEvent("iZeyy:PlayerTime:UpdateTimer")
AddEventHandler("iZeyy:PlayerTime:UpdateTimer", function(timeplayed)
    local xPlayer = ESX.GetPlayerFromId(source)
    if PlayeTime[source] then
        PlayeTime[source].timeplayed = timeplayed
    end
end)
