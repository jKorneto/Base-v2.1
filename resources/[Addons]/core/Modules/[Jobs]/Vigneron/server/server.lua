local Timeout = {}
local SpawnTimeout = {}

RegisterNetEvent("iZeyy:Vigneron:RecolteRaisin", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local player = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(player)
    local recoltePos = Config["Vigneron"]["Recolte"]
    local distance = #(playerCoords - recoltePos)

    if (distance < 50) then

        if (xPlayer.job.name == Config["Vigneron"]["AllowedJob"]) then

            if (not Timeout[xPlayer.identifier] or GetGameTimer() - Timeout[xPlayer.identifier] > 2000) then
            
                Timeout[xPlayer.identifier] = GetGameTimer()

                if (xPlayer.canCarryItem(Config["Vigneron"]["RecolteItem"], 2)) then
                    xPlayer.addInventoryItem(Config["Vigneron"]["RecolteItem"], 1)
                else
                    xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                end
            
            end
        end
    end
end)

RegisterNetEvent("iZeyy:Vigneron:TraitementRaisin", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(player)
    local recoltePos = Config["Vigneron"]["Traitement"]
    local distance = #(playerCoords - recoltePos)

    if (distance < 25) then

        if (xPlayer.job.name == Config["Vigneron"]["AllowedJob"]) then

            if (not Timeout[xPlayer.identifier] or GetGameTimer() - Timeout[xPlayer.identifier] > 2000) then

                Timeout[xPlayer.identifier] = GetGameTimer()

                if (xPlayer.canCarryItem(Config["Vigneron"]["TraitementItem"], 1)) then
                    local hasRecolteItem = xPlayer.getInventoryItem(Config["Vigneron"]["RecolteItem"])
                    if (hasRecolteItem and hasRecolteItem.quantity >= 1) then
                        xPlayer.removeInventoryItem(Config["Vigneron"]["RecolteItem"], 1)
                        xPlayer.addInventoryItem(Config["Vigneron"]["TraitementItem"], 1)
                    else
                        xPlayer.showNotification("Vous n'avez pas assez de raisin")
                    end
                else
                    xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                end
            end
        end
    end
end)

RegisterNetEvent("iZeyy:Vigneron:SpawnVehicle", function(Model, Label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    local correctVehicle = false

    if xPlayer then
        if xPlayer.job.name ~= Config["Vigneron"]["AllowedJob"] then
            xPlayer.ban(0, "(iZeyy:Vigneron:SpawnVehicle) (job)")
            return
        end

        if (not SpawnTimeout[xPlayer.identifier] or GetGameTimer() - SpawnTimeout[xPlayer.identifier] > 10000) then
            SpawnTimeout[xPlayer.identifier] = GetGameTimer()

            for k, v in pairs(Config["Vigneron"]["VehList"]) do
                if Model == v.model and Label == v.label then
                    correctVehicle = true
                    break
                end
            end

            if not (correctVehicle) then
                return
            end

            if #(coords - Config["Vigneron"]["Garage"]) < 15 then
                local spawnPos = Config["Vigneron"]["GarageDelete"] 
                ESX.SpawnVehicle(Model, spawnPos, 258.04565429688, nil, false, xPlayer, xPlayer.identifier, function(handle)
                    --TaskWarpPedIntoVehicle(ped, handle, -1);
                    SetPedIntoVehicle(GetPlayerPed(xPlayer.source), handle:GetHandle(), -1)
                end);
            else
                xPlayer.ban(0, "(iZeyy:Vigneron:SpawnVehicle) (coords)")
            end

        else
            xPlayer.showNotification("Veuillez attendre 10 seconde avant de refaire appel a un véhicule")
        end
    end
end)    

RegisterNetEvent("iZeyy:Vigneron:Vente", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(player)
    local recoltePos = Config["Vigneron"]["Vente"]
    local distance = #(playerCoords - recoltePos)

    if (distance < 25) then

        if (xPlayer.job.name == Config["Vigneron"]["AllowedJob"]) then

            if (not Timeout[xPlayer.identifier] or GetGameTimer() - Timeout[xPlayer.identifier] > 2000) then

                Timeout[xPlayer.identifier] = GetGameTimer()

                local hasRecolteItem = xPlayer.getInventoryItem(Config["Vigneron"]["TraitementItem"])
                if (hasRecolteItem and hasRecolteItem.quantity >= 0) then
                    local Price = Config["Vigneron"]["VentePrice"]
                    local totalAmount = Price * hasRecolteItem.quantity
                    xPlayer.removeInventoryItem(Config["Vigneron"]["TraitementItem"], hasRecolteItem.quantity)
                    xPlayer.showNotification(("Vous avez vendu %d bouteilles de vin pour %d$ votre entreprise a été crédité de ce montant"):format(hasRecolteItem.quantity, totalAmount, totalAmount))
                    ESX.AddSocietyMoney("vigneron", totalAmount)
                else
                    xPlayer.showNotification("Vous n'avez pas assez de vin")
                end
            end
        end
    end
end)