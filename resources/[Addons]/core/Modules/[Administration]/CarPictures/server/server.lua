local vehicles = nil

RegisterNetEvent('boutique:spawnVehicle', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'fondateur' then
        ::respawn::
        if vehicles == nil then
            ESX.SpawnVehicle(model, vector3(-147.47764587402, -593.23937988281, 167.00012207031), 160.512, nil, false, xPlayer, xPlayer.identifier, function(vehicle)
                vehicles = vehicle
                TriggerClientEvent("boutique:repairVehicle", -1, NetworkGetNetworkIdFromEntity(vehicle))
                ExecuteCommand('time 00 00')
            end);
        else
            if (DoesEntityExist(vehicles)) then
                DeleteEntity(vehicles)
            end

            vehicles = nil
            Wait(500)
            goto respawn
        end
    end
end)