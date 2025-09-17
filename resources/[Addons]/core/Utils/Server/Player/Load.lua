AddEventHandler("esx:playerLoaded", function(playerSrc)
    local xPlayer = ESX.GetPlayerFromId(playerSrc)

    if (xPlayer) then
        TriggerClientEvent("fowlmas:onelife:player:receive_player_data", xPlayer.source, xPlayer)
    end
end)

AddEventHandler("fowlmas:esx:loaded", function()
    local players = GetPlayers();

    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(tonumber(players[i]));

        if (type(xPlayer) == "table") then
            TriggerClientEvent("fowlmas:onelife:player:receive_player_data", xPlayer.source, xPlayer);
        end
    end
end);