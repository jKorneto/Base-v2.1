local canDoEmote = true

RegisterNetEvent("fowlmas:player:DeadMenu", function(bool)
    if (type(bool) == "boolean") then
        canDoEmote = not bool
    end
end)

RegisterNetEvent('animations:client:PlayEmote', function(args)
    if (canDoEmote) then
        EmoteCommandStart(source, args)
    end
end)

RegisterNetEvent('animations:client:ListEmotes', function()
    if (canDoEmote) then
        EmotesOnCommand()
    end
end)

RegisterNetEvent('animations:client:Walk', function(args)
    if (canDoEmote) then
        WalkCommandStart(source, args)
    end
end)

RegisterNetEvent('animations:client:ListWalks', function()
    if (canDoEmote) then
        WalksOnCommand()
    end
end)

RegisterNetEvent('animations:client:EmoteCommandStart', function(args)
    if (CanDoEmote) then
        EmoteCommandStart(source, args)
    end
end)
