RegisterNetEvent("iZeyy:BurgerShot:SendAnnoucement", function(announcementType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.job.name ~= "burgershot") then
            xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:BurgerShot:SendAnnoucement)")
            return
        end

        local jobLabel = xPlayer.job.name_label
        local announcementCategory = announcementType == 1 and "open" or announcementType == 2 and "close" or "recruitment"
        local announcementContent = Config["Burgershot"]["Annoucement"][announcementCategory]

        showSocietyNotify(xPlayer, xPlayer.job.name, "BurgerShot", announcementContent, "Informations", 10)
    end
end)

RegisterNetEvent("iZeyy:BurgerShot:Coking", function(Items)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (xPlayer.job.name ~= "burgershot") then
            xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:BurgerShot:CokingJob)")
            return
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerCoords = GetEntityCoords(Player)
        local BurgerPos = Config["Burgershot"]["BurgerPos"]

        local Distance = #(PlayerCoords - BurgerPos)
        if (Distance < 15) then
            if (Items == "burger") then
                if (xPlayer.canCarryItem("burger", 1)) then
                    xPlayer.addInventoryItem("burger", 1)
                    ESX.RemoveSocietyMoney("burgershot", Config["Burgershot"]["BurgerPrice"])
                else
                    xPlayer.showNotification("Vous n'avez pas de place sur vous")
                end
            elseif (Items == "fries") then
                if (xPlayer.canCarryItem("frites", 1)) then
                    xPlayer.addInventoryItem("frites", 1)
                    ESX.RemoveSocietyMoney("burgershot", Config["Burgershot"]["FriesPrice"])
                else
                    xPlayer.showNotification("Vous n'avez pas de place sur vous")
                end
            elseif (Items == "drink") then
                if (xPlayer.canCarryItem("fanta", 1)) then
                    xPlayer.addInventoryItem("fanta", 1)
                    ESX.RemoveSocietyMoney("burgershot", Config["Burgershot"]["DrinkPrice"])
                else
                    xPlayer.showNotification("Vous n'avez pas de place sur vous")
                end
            else
                xPlayer.ban(0, "Tentative de triche detectée (iZeyy:BurgerShot:CokingItems)")
            end
        else
            DropPlayer(source, "Veuillez vous reconnectez Erreur : (iZeyy:BurgerShot:CokingPos)")
        end
    end
end)

RegisterNetEvent("iZeyy:Burgershot:Sell", function(Target, Price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(Target)

    if (xPlayer) then
        if (xTarget) then
            if (xPlayer.job.name ~= "burgershot") then
                xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:BurgerShot:Sell) #1")
                return
            end

            local PlayerPed = GetPlayerPed(xPlayer.source)
            local TargetPed = GetPlayerPed(xTarget.source)
            local PlayerPos = GetEntityCoords(PlayerPed)
            local TargetPos = GetEntityCoords(TargetPed)

            local WithinDistance = false
            for _, position in ipairs(Config["Burgershot"]["CounterPos"]) do
                if #(PlayerPos - position) <= 15 then
                    WithinDistance = true
                    break
                end
            end
        
            if not WithinDistance then
                return DropPlayer(source, "Veuillez vous reconnectez Erreur : (iZeyy:Burgershot:Sell) #2")
            end
            
            local NearbyPlayers = false
            if (#(PlayerPos - TargetPos) <= 10) then
                NearbyPlayers = true
            end

            if not NearbyPlayers then
                return xPlayer.showNotification("Aucun joueurs a coté de vous")
            end

            local Burger = xPlayer.getInventoryItem("burger")
            local Frites = xPlayer.getInventoryItem("frites")
            local Fanta = xPlayer.getInventoryItem("fanta")

            if Burger and Frites and Fanta and Burger.quantity > 0 and Frites.quantity > 0 and Fanta.quantity > 0 then
                if (xTarget.canCarryItem("burger", 1) and xTarget.canCarryItem("frites", 1) and xTarget.canCarryItem("fanta", 1)) then
                    local Bill = ESX.CreateBill(xPlayer.source, xTarget.source, Price, "BurgerShot", "society", "burgershot")
                    if Bill then
                        xPlayer.removeInventoryItem("burger", 1)
                        xPlayer.removeInventoryItem("frites", 1)
                        xPlayer.removeInventoryItem("fanta", 1)
                        xTarget.addInventoryItem("burger", 1)
                        xTarget.addInventoryItem("frites", 1)
                        xTarget.addInventoryItem("fanta", 1)
                    else
                        xPlayer.showNotification("Le joueur a refusé la facture")
                    end
                else
                    xPlayer.showNotification("Le joueur n'a pas assez de place sur lui")
                end
            else
                xPlayer.showNotification("Vous n'avez pas de quoi vendre un menu sur vous")
            end
        end
    end
end)

local SpawnTimeout = {}

RegisterNetEvent("iZeyy:Burgershot:SpawnCar", function(label, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)

    if (xPlayer) then
        if (xPlayer.job.name ~= "burgershot") then
            return xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:BurgerShot:SpawnCar) #1")
        end

        if (not SpawnTimeout[xPlayer.identifier] or GetGameTimer() - SpawnTimeout[xPlayer.identifier] > 10000) then
            SpawnTimeout[xPlayer.identifier] = GetGameTimer()

            local correctVehicle = false
            for k, v in pairs(Config["Burgershot"]["Garage"]) do
                if label == v.label and model == v.model then
                    correctVehicle = true
                    break
                end
            end

            if #(coords - Config["Burgershot"]["GaragePos"]) < 15 then
                ESX.SpawnVehicle(model, Config["Burgershot"]["SpawnPos"], Config["Burgershot"]["SpawnHeading"], nil, false, xPlayer, xPlayer.identifier, function(vehicle) end)
            else
                return
            end
        else
            xPlayer.showNotification("Veuillez attendre de refaire spawn un véhicule")
        end
    end
end)

RegisterNetEvent("izeyy:burgershot:sendAnnouncement", function(announcement)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        
        if (xPlayer.job.name ~= "burgershot") then
            return
        end

        if (xPlayer.job.grade == 4) then
            local jobLabel = "BurgerShot"
            showSocietyNotify(xPlayer, xPlayer.job.name, jobLabel, announcement, "Entreprise", 10)
        else
            return
        end

    end
end)

-- Items
ESX.RegisterUsableItem("burger", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('burger', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'hunger', 300000)
    TriggerClientEvent('esx_basicneeds:onsandwich', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un Burger")
end)

ESX.RegisterUsableItem("frites", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('frites', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'hunger', 300000)
    TriggerClientEvent('esx_basicneeds:onsandwich', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé des frites")
end)

ESX.RegisterUsableItem("fanta", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('fanta', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 600000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un fanta")
end)