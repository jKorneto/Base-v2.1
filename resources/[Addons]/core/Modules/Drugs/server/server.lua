local HarvestTimeout = {}
local ProcessTimeout = {}
local ReseelTimeout = {}

Shared.Events:OnNet(Enums.Drugs.Harvest, function(xPlayer, label)
    if (type(xPlayer) == "table") then

        local playerPed = GetPlayerPed(xPlayer.source)
        local playerPos = GetEntityCoords(playerPed)
        local label = tostring(label)

        if #(playerPos - Config[label]["Recolte"]) > 12.5 then
            return xPlayer.showNotification("Vous êtes trop loin de la Zone de Récolte")
        end

        if (not HarvestTimeout[xPlayer.identifier] or GetGameTimer() - HarvestTimeout[xPlayer.identifier] > 1000) then
            HarvestTimeout[xPlayer.identifier] = GetGameTimer()

            if (xPlayer.canCarryItem(Config[label]["RecolteItem"], 2)) then
                xPlayer.addInventoryItem(Config[label]["RecolteItem"], 1)
                xPlayer.showNotification(("Vous avez reçu (x1) de %s"):format(label))
                xPlayer.addXP(20)
            else
                xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
            end
        else
            return xPlayer.showNotification("Veuillez attendre 1 seconde avant de récolter")
        end

    end
end)

Shared.Events:OnNet(Enums.Drugs.Process, function(xPlayer, label)
    if (type(xPlayer) == "table") then
        local playerPed = GetPlayerPed(xPlayer.source)
        local playerPos = GetEntityCoords(playerPed)
        local label = tostring(label)

        if #(playerPos - Config[label]["Traitement"]) > 12.5 then
            return xPlayer.showNotification("Vous êtes trop loin de la Zone de Traitement")
        end

        if (not ProcessTimeout[xPlayer.identifier] or GetGameTimer() - ProcessTimeout[xPlayer.identifier] > 1000) then
            ProcessTimeout[xPlayer.identifier] = GetGameTimer()

            if (xPlayer.canCarryItem(Config[label]["TraitementItem"], 1)) then
                local hasRecolteItem = xPlayer.getInventoryItem(Config[label]["RecolteItem"])

                if (hasRecolteItem and hasRecolteItem.quantity >= 2) then
                    xPlayer.removeInventoryItem(Config[label]["RecolteItem"], 2)
                    xPlayer.addInventoryItem(Config[label]["TraitementItem"], 1)
                    xPlayer.addXP(20)
                else
                    xPlayer.showNotification(("Vous n'avez pas assez de %s pour traiter il vous en faut minimum 5"):format(label))
                end
            else
                xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
            end
        else
            return xPlayer.showNotification("Veuillez attendre 1 seconde avant de traiter")
        end
    end
end)

Shared.Events:OnNet(Enums.Drugs.Sell, function(xPlayer, drugs)
    if (type(xPlayer) == "table") then
        local playerPed = GetPlayerPed(xPlayer.source)
        local playerPos = GetEntityCoords(playerPed)
        local label = "Not Defined"
        local price = nil
        local required = nil

        if (drugs == "weed_bag_og") then
            label = "Weed"
            required = 1
        elseif (drugs == "meth_pooch") then
            label = "Meth"
            required = 1
        elseif (drugs == "coke_pooch") then
            label = "Coke"
            required = 1
        elseif (drugs == "fentanyl_pooch") then
            label = "Fentanyl"
            required = 1
        end

        local withinDistance = false
        for _, drug in ipairs(Config["Drugs"]["Resell"]) do
            price = drug.reward
            if #(playerPos - drug.pedPos) <= 15 then
                withinDistance = true
                break
            end
        end        

        if (not withinDistance) then
            return xPlayer.showNotification("Vous etes trop loin de la Zone de Vente")
        end

        if (not ReseelTimeout[xPlayer.identifier] or GetGameTimer() - ReseelTimeout[xPlayer.identifier] > 250) then
            ReseelTimeout[xPlayer.identifier] = GetGameTimer()

            local hasPooch = xPlayer.getInventoryItem(drugs)

            if (hasPooch and hasPooch.quantity >= required) then
                xPlayer.removeInventoryItem(drugs, required)
                xPlayer.addAccountMoney("dirtycash", price)
                xPlayer.showNotification(("Vous avez vendu %s Pochon de %s et vous avez reçu %s$"):format(required, label, price))
                xPlayer.addXP(20)
            else
                xPlayer.showNotification(("Vous n'avez pas de Pochon de %s (%s Requis)"):format(label, required))
            end
        else
            return
        end

    end
end)