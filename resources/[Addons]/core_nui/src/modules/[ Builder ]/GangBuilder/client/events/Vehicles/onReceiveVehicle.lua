RegisterNetEvent('OneLife:GangBuilder:ReceiveVehicle')
AddEventHandler('OneLife:GangBuilder:ReceiveVehicle', function(plate, vehicle)
    MOD_GangBuilder:SetVehicle(plate, vehicle)
end)