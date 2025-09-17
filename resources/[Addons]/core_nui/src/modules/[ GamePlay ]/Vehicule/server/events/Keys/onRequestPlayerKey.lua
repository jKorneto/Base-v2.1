RegisterNetEvent('OneLife:Keys:RequestPlayerKey')
AddEventHandler('OneLife:Keys:RequestPlayerKey', function(vehiclePlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicle = MOD_Vehicle:GetVehicleByPlate(vehiclePlate)

    if (xPlayer) then
        if (vehicle) then
            if (vehicle:IsPlayerHasKey(xPlayer)) then
                TriggerClientEvent('OneLife:Keys:VehiclePlayerKey', xPlayer.source)
            end
        end
    end
end)