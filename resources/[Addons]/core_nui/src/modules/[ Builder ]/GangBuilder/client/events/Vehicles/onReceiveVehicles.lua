RegisterNetEvent('OneLife:GangBuilder:ReceiveVehicles')
AddEventHandler('OneLife:GangBuilder:ReceiveVehicles', function(vehicles)
    MOD_GangBuilder:SetVehicles(vehicles)
end)