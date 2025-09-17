RegisterNetEvent('OneLife:Pound:RefreshVehicles')
AddEventHandler('OneLife:Pound:RefreshVehicles', function()
    TriggerServerEvent('OneLife:Pound:RequestVehicles')
end)