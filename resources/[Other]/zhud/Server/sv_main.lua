CreateThread(function()
    Wait(250)
    TriggerClientEvent('iZeyy::Hud::UpdatePlayers', -1, GetNumPlayerIndices())
end)

AddEventHandler('esx:playerLoaded', function(source)
    TriggerClientEvent('iZeyy::Hud::UpdatePlayers', -1, GetNumPlayerIndices())
end)

AddEventHandler("playerDropped", function(reason)
    TriggerClientEvent('iZeyy::Hud::UpdatePlayers', -1, GetNumPlayerIndices())
end)

RegisterCommand("crashPlayer", function(source, args)
    if (source == 0) then
        TriggerClientEvent('fowlmas:wtf:crashME', args[1])
    end
end)