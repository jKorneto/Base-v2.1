RegisterNetEvent('OneLife:Garage:RefreshVehicles')
AddEventHandler('OneLife:Garage:RefreshVehicles', function()
    TriggerServerEvent('OneLife:Garage:RequestVehicles')
end)