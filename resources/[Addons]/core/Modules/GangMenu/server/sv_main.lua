-- Notification pour les victimes
RegisterServerEvent('victimMessage', function(player)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pName = xPlayer.getName()
    if (#(GetEntityCoords(GetPlayerPed(xPlayer.source)) - GetEntityCoords(GetPlayerPed(player))) < 5.0) then
        TriggerClientEvent('esx:showNotification', player, "le joueurs " ..pName.. " a essayé de vous fouiller.")
    end
end);

RegisterServerEvent('aggressorMessage', function(player)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pName = xPlayer.getName()
    if (#(GetEntityCoords(GetPlayerPed(xPlayer.source)) - GetEntityCoords(GetPlayerPed(player))) < 5.0) then
        TriggerClientEvent('esx:showNotification', player, "Vous êtes fouiller par " ..pName.. ".")
    end
end);

local function NotifyPolice(plate, modelName, coords)
    local policePlayers = ESX.GetPlayers()
    for _, playerId in ipairs(policePlayers) do
        local xPolicePlayer = ESX.GetPlayerFromId(playerId)
        if xPolicePlayer.job.name == "police" then
            TriggerClientEvent("iZeyy:factionMenu:NotifyPolice", playerId, plate, modelName, coords) 
        end
    end
end

RegisterNetEvent("iZeyy:factionMenu:checkItems", function(plate, modelName, netID)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasLockPick = xPlayer.getInventoryItem("kitcrochetage")

    if hasLockPick and hasLockPick.quantity > 0 then
        TriggerClientEvent("iZeyy:factionMenu:HasItems", source, plate, modelName, netID)
        local coords = GetEntityCoords(GetPlayerPed(source))
        NotifyPolice(plate, modelName, coords)
    else
        xPlayer.showNotification("Vous n'avez pas de kit de crochetage")
    end
end)

RegisterNetEvent("iZeyy:factionMenu:deblock", function(netID)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasLockPick = xPlayer.getInventoryItem("kitcrochetage")
    local vehicle = NetworkGetEntityFromNetworkId(netID)

    if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
        if hasLockPick and hasLockPick.quantity > 0 then
            SetVehicleDoorsLocked(vehicle, 1)
            xPlayer.removeInventoryItem("kitcrochetage", 1)
            xPlayer.showNotification("Vous avez déverrouillé le véhicule")
        else
            xPlayer.showNotification("Vous n'avez pas de kit de crochetage")
        end
    end
end)

RegisterNetEvent("iZeyy:gang:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.job2.name == "unemployed" or xPlayer.job2.name == "unemployed2") then
            return xPlayer.ban(0, "(iZeyy:gang:frisk)")
        end

        local player = GetPlayerPed(xPlayer.source)
        local target = GetPlayerPed(xTarget.source)
        local playerCoords = GetEntityCoords(player)
        local targetCoords = GetEntityCoords(target)

        if #(playerCoords - targetCoords) > 15 then
            return xPlayer.ban(0, "(iZeyy:gang:frisk) #2")
        end

        exports["inventory"]:FriskTarget(xPlayer.source, xTarget.source)
    end
end)

RegisterNetEvent("iZeyy:gang:close:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.job2.name == "unemployed" or xPlayer.job2.name == "unemployed2") then
            return xPlayer.ban(0, "(iZeyy:gouv:frisk)")
        end

        exports["inventory"]:CloseFrisk(xPlayer.source, xTarget.source)
    end
end)