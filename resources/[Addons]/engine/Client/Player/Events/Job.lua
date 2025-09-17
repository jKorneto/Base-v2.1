RegisterNetEvent(Engine["Enums"].ESX.Player.Job.Client.setJob(), function(job)
    Client.Player:SetJob(job)
    Shared.Events:Trigger(Engine["Enums"].Player.Events.updateZonesAndBlips)
end)

RegisterNetEvent(Engine["Enums"].ESX.Player.Job.Client.setJob2(), function(job2)
    Client.Player:SetJob2(job2)
    Shared.Events:Trigger(Engine["Enums"].Player.Events.updateZonesAndBlips)
end)