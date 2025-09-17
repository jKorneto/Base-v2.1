RegisterNetEvent('OneLife:Zones:onRemoveAllZoneJobType')
AddEventHandler('OneLife:Zones:onRemoveAllZoneJobType', function(jobType)
    MOD_Zones:deleteAllByJobType(jobType)
end)