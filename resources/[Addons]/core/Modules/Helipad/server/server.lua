Shared.Events:OnNet(Enums.Helipad.Spawn, function(xPlayer, model)
    if (type(xPlayer) == "table") then
        local playerJob = xPlayer.job.name

        if Config["Helipad"]["List"][playerJob] then
            local spawnPos = Config["Helipad"]["List"][playerJob].spawnPos
            local spawnHeading = Config["Helipad"]["List"][playerJob].spawnHeading

            if (IsSpawnPointClear(spawnPos, 5)) then
                ESX.SpawnVehicle(model, spawnPos, spawnHeading, nil, false, xPlayer, nil, function(vehicle)
                    --TaskWarpPedIntoVehicle(player, vehicle, -1)
                    SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
                end)
            else
                xPlayer.showNotification("Un Hélicoptère ocupe déja la place")
            end
        else
            return xPlayer.ban(0, "Tentative de Cheat (Enums.Helipad.Spawn) #1")
        end
    end
end)
