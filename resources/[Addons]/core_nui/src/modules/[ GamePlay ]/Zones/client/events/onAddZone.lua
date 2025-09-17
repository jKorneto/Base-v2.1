RegisterNetEvent('OneLife:Zones:AddZone')
AddEventHandler('OneLife:Zones:AddZone', function(zone)
    MOD_Zones:add(zone)
end)