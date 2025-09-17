RegisterNetEvent('OneLife:Zones:ChangePlayerJob')
AddEventHandler('OneLife:Zones:ChangePlayerJob', function(type, job)
    TriggerClientEvent('OneLife:Zones:onRemoveAllZoneJobType', source, type)

    MOD_Zones:loadZonesByJob(source, job)
end)