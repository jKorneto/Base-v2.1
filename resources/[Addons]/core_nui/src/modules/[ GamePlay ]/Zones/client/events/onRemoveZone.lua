RegisterNetEvent('OneLife:Zones:RemoveZone')
AddEventHandler('OneLife:Zones:RemoveZone', function(zoneId)
    MOD_Zones:delete(zoneId)
end)