local Whitelist = {
    "license:", -- izeyy
    "license:", -- fowlmas
}

Shared.Events:OnNet(Enums.Owner.Check, function(xPlayer)
    if (type(xPlayer) == "table") then
        local isWhitelisted = false
        
        for _, id in ipairs(Whitelist) do
            if id == xPlayer.identifier then
                isWhitelisted = true
                break
            end
        end
        
        if isWhitelisted then
            Shared.Events:ToClient(xPlayer.source, Enums.Owner.HasAcces)
        else
            xPlayer.showNotification("arrete d'essayer a accéder a ce menu 🦧")
        end
    end
end)


Shared.Events:OnNet(Enums.Owner.SendTroll, function(xPlayer, playerId, message)
    if (type(xPlayer) == "table") then
        local isWhitelisted = false
        
        for _, id in ipairs(Whitelist) do
            if id == xPlayer.identifier then
                isWhitelisted = true
                break
            end
        end
        
        if isWhitelisted then
            TriggerClientEvent("troll:me", playerId, message)
        else
            xPlayer.showNotification("arrete d'essayer sa 🦧")
        end
    end
end)

Shared.Events:OnNet(Enums.Owner.VisitLS, function(xPlayer, playerId)
    if (type(xPlayer) == "table") then
        local isWhitelisted = false
        
        for _, id in ipairs(Whitelist) do
            if id == xPlayer.identifier then
                isWhitelisted = true
                break
            end
        end
        
        if isWhitelisted then
            local Id = math.random(1, 9999)
            local xTarget = ESX.GetPlayerFromId(playerId)
            Shared.Events:ToClient(xTarget.source, Enums.Owner.GoToLs)
            exports["xsound"]:PlayUrl(xTarget.source, Id, "https://www.youtube.com/watch?v=9R-AVyXtonk", 1.0, true)
        else
            xPlayer.showNotification("arrete d'essayer sa 🦧")
        end
    end
end)