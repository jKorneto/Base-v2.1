RegisterNetEvent('OneLife:GangBuilder:GetParkVehicule')
AddEventHandler('OneLife:GangBuilder:GetParkVehicule', function(gangId)
    local veh = GetVehiclePedIsIn(PlayerPedId())

    if (veh) then
        TriggerServerEvent('OneLife:GangBuilder:ParkVehicule', GetVehicleNumberPlateText(veh), gangId, API_Vehicles:getProperties(veh))
    end
end)