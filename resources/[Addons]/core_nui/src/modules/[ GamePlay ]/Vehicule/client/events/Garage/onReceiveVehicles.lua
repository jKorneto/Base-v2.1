RegisterNetEvent('OneLife:Garage:ReceiveVehicles')
AddEventHandler('OneLife:Garage:ReceiveVehicles', function(vehicles)
    MOD_Vehicle.Garage.vehicles = vehicles
end)