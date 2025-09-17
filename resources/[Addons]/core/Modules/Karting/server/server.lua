RegisterNetEvent("iZeyy:Karting:Spawn", function(label, model, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        local correctVeh = false
        for k, v in pairs(Config["Karting"]["VehList"]) do
            if (label == v.label and model == v.model and price == v.price) then
                correctVeh = true
                break
            end
        end

        if (not correctVeh) then
            return xPlayer.showNotification("Ce véhicule n'est pas sur la liste des véhicule autorisé")
        end

        local spawnCoords = Config["Karting"]["SpawnPos"]

        if (correctVeh) then
            local pPed = GetPlayerPed(xPlayer.source)
            local pCoords = GetEntityCoords(pPed)

            local dist = #(pCoords - Config["Karting"]["SpawnPos"])

            if (dist < 100) then

                if (IsSpawnPointClear(spawnCoords, 25)) then
                    local Bill = ESX.CreateBill(0, xPlayer.source, price, "Karting", "server")
                    if (Bill) then
                        ESX.SpawnVehicle(model, spawnCoords, 291.72534179688, nil, false, xPlayer, nil, function(vehicle)
                            SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
                        end)
                    else
                        xPlayer.showNotification("Vous avez refusé la facture")
                    end
                else
                    xPlayer.showNotification("Le point d'apparation de véhicule est occupé")
                end

            end
        end
    end
end)