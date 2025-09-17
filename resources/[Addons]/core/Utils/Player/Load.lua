RegisterNetEvent("fowlmas:onelife:player:receive_player_data", function(playerData)
    if (playerData and type(playerData) == "table") then
        Shared.Log:Info("Données chargées avec succès")
        -- @todo a retiré apres Noel
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        Client:InitializePlayer(playerData);
    else
        TriggerServerEvent("Enums.Player.Events.KickPlayer", "Les données du joueur n'ont pas pu être chargées.")
    end

end);