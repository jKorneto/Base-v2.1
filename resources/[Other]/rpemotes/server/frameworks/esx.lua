RegisterCommand("e", function(source, args)
    TriggerClientEvent('animations:client:PlayEmote', source, args)
end)

RegisterCommand("emote", function(source, args)
    TriggerClientEvent('animations:client:PlayEmote', source, args)
end)

RegisterCommand("emotes", function(source, args)
    TriggerClientEvent('animations:client:ListEmotes', source)
end)

RegisterCommand("walk", function(source, args)
    TriggerClientEvent('animations:client:Walk', source, args)
end)

RegisterCommand("walks", function(source, args)
    TriggerClientEvent('animations:client:ListWalks', source)
end)

RegisterCommand("nearby", function(source, args)
    TriggerClientEvent('animations:client:Nearby', source, args)
end)