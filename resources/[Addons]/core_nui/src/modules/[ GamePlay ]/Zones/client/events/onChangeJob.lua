OneLife:OnJobChange(function(typeJob, job)
    TriggerServerEvent('OneLife:Zones:ChangePlayerJob', typeJob, job)
end)