function _bot_api:SpawnCar(id, car, cb)
    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer ~= nil then
        -- TriggerClientEvent('esx:spawnVehicle', xPlayer.source, car)
        local model = (type(car) == 'number' and car or GetHashKey(car))
        local xPlayer = ESX.GetPlayerFromId(xPlayer.source)
        local plyCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
    
        exports['core_nui']:SpawnVehicle(model, plyCoords, 0.0, nil, false, function(vehicle)
            SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)

            vehicle:SetLocked(false)
        end, xPlayer)

        cb("Le joueur " ..xPlayer.name.. " a bien recu la voiture (Nom: "..car..") !")
    else
        cb("Le joueurs n'est pas connecté !")
    end
end