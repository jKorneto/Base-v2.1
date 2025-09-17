Shared.Events:OnNet(Enums.Shooting.Send, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name ~= "police") then
            local player = GetPlayerPed(xPlayer.source)
            local playerPos = GetEntityCoords(player)

            for k, v in pairs(SaspInService) do
                local player = ESX.GetPlayerFromId(v);

                if (player) then
                    if player.job.name == "police" then
                        player.showNotification("Un tir a été détecté une position a été ajoutée sur votre GPS")
                        Shared.Events:ToClient(player.source, Enums.Shooting.Receive, playerPos)
                    end
                end
            end
        end
    end
end)