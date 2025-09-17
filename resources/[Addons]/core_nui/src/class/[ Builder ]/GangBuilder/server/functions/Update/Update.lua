function _OneLifeGangBuilder:Update(type, ...)
    local players = ESX.GetPlayers();

    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i]);

        if (player) then
            if (player.job2.name == self.name) then
                TriggerClientEvent('OneLife:GangBuilder:UpdateGang', player.source, type, ...)
            end
        end
    end
end