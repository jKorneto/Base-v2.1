RegisterNetEvent('OneLife:Pound:ReceiveVehicles')
AddEventHandler('OneLife:Pound:ReceiveVehicles', function(vehicles)
    MOD_Vehicle.Pound.vehicles = vehicles
end)