RegisterNetEvent('OneLife:GangBuilder:PoundReceiveVehicles')
AddEventHandler('OneLife:GangBuilder:PoundReceiveVehicles', function(vehicles)
    MOD_GangBuilder.data.pound.vehicles = vehicles
end)