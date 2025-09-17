Shared.Events:OnNet(Engine["Enums"].Player.Events.ReceivePlayerData, function(playerData)
    if (playerData and type(playerData) == "table") then
        Client:InitializePlayer(playerData)
        Shared.Events:Trigger(Engine["Enums"].Player.Events.PlayerLoaded, playerData)
        Shared.Events:ToServer(Engine["Enums"].Player.Events.PlayerLoaded)
    else
        Shared.Events:Protected(Engine["Enums"].Player.Events.KickPlayer, "Les données du joueur n'ont pas pu être chargées.")
    end
end)