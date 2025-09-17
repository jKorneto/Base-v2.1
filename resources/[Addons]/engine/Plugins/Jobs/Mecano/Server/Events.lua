Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.startCustom, function(xPlayer, props, customZone, jobName)
    if (type(xPlayer) == "table" and type(props) == "table" and type(customZone) == "vector3" and type(jobName) == "string") then
        local zones = Engine["Config"]["Mecano"]["Zones"]

        if (zones[xPlayer.job.name] ~= nil) then
            local ped = GetPlayerPed(xPlayer.source)
            local vehicle = GetVehiclePedIsIn(ped, false)
            Engine.Mecano:saveDefaultCustomisation(vehicle, props, customZone, jobName, xPlayer.identifier)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.resetCustom, function(xPlayer, plate)
    if (type(xPlayer) == "table") then
        if (Engine.Mecano:isPlayerInCustom(xPlayer.identifier)) then
            if (Engine.Mecano:doesDefaultCustomisationExist(plate)) then
                local properties = Engine.Mecano:getDefaultProps(plate)
                local networkId = Engine.Mecano:getNetworkId(plate)
                
                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Vehicles.Events.SetProperties, plate, networkId, properties)
                Engine.Mecano:removeDefaultCustomisation(plate, xPlayer.identifier)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.receiveProperties, function(xPlayer, props)
    if (type(xPlayer) == "table" and type(props) == "table") then
        local plate = props.plate

        if (Engine.Mecano:isPlayerInCustom(xPlayer.identifier)) then
            if (Engine.Mecano:doesDefaultCustomisationExist(plate)) then
                if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
                    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE @plate = plate", {
                        ["@plate"] = plate
                    }, function(result)
                        if (result[1] ~= nil) then
                            MySQL.Async.execute("UPDATE owned_vehicles SET vehicle = @props WHERE plate = @plate", {
                                ["@props"] = json.encode(props),
                                ["@plate"] = plate
                            })
                        end
                    end)

                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.changeBillState)
                    Engine.Mecano:removeDefaultCustomisation(plate, xPlayer.identifier)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.sendBill, function(xPlayer, targetID, price, plate)
    if (type(xPlayer) == "table" and type(targetID) == "number" and type(price) == "number" and type(plate) == "string") then
        if (Engine.Mecano:isPlayerInCustom(xPlayer.identifier)) then
            if (Engine.Mecano:doesDefaultCustomisationExist(plate)) then
                local ped = GetPlayerPed(xPlayer.source)
                local playerCoords = GetEntityCoords(ped)
                local xTarget = ESX.GetPlayerFromId(targetID)
                local targetPed = GetPlayerPed(xTarget.source)
                local targetCoords = GetEntityCoords(targetPed)
                local targetDistance = #(playerCoords - targetCoords)
                local customZone = Engine.Mecano:getcustomZone(plate)
                local jobName = Engine.Mecano:getjobName(plate)
                local customZoneDistance = #(playerCoords - customZone)

                if (jobName == xPlayer.job.name) then
                    if (customZoneDistance <= 10.0) then
                        if (targetDistance <= 20.0) then
                            local finalPrice = price + (price * Engine.Mecano:getPercentage(jobName) / 100)
                            local bill = ESX.CreateBill(xPlayer.source, xTarget.source, finalPrice, "Customisation Vehicle", "society", jobName)

                            if (bill) then
                                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.requestProperties)
                            else
                                local props = Engine.Mecano:getDefaultProps(plate)
                                local networkId = Engine.Mecano:getNetworkId(plate)

                                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Vehicles.Events.SetProperties, plate, networkId, props)
                                Engine.Mecano:removeDefaultCustomisation(plate, xPlayer.identifier)
                                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.changeBillState)
                                Server:showNotification(xPlayer.source, "La facture de %s ~g~$~s~ n'a pas été payée", false, finalPrice)
                            end
                        end
                    end
                end
            end
        end
    end
end)

Server:OnPlayerDropped(function (xPlayer)
    if (type(xPlayer) == "table") then
        if (Engine.Mecano:isPlayerInCustom(xPlayer.identifier)) then
            local ped = GetPlayerPed(xPlayer.source)
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(vehicle)

            if (vehicle ~= nil and plate ~= nil) then
                if (Engine.Mecano:doesDefaultCustomisationExist(plate)) then
                    local players = GetPlayers()
                    local pedCoords = GetEntityCoords(ped)
                    local defaultProps = Engine.Mecano:getDefaultProps(plate)
                    local networkId = Engine.Mecano:getNetworkId(plate)
                    local findPlayer = false

                    for i = 1, #players do
                        local targetPed = GetPlayerPed(players[i])

                        if (targetPed ~= ped) then
                            local targetCoords = GetEntityCoords(targetPed)
                            local targetDistance = #(pedCoords - targetCoords)

                            if (targetDistance and targetDistance <= 50.0 and not findPlayer) then
                                Shared.Events:ToClient(tonumber(players[i]), Engine["Enums"].Vehicles.Events.SetProperties, plate, networkId, defaultProps)
                                Engine.Mecano:removeDefaultCustomisation(plate, xPlayer.identifier)
                                findPlayer = true
                                break
                            end
                        end
                    end

                    if (not findPlayer) then
                        Engine.Mecano:removeDefaultCustomisation(plate, xPlayer.identifier)
                        DeleteEntity(vehicle)
                    end
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.sendAnnouncement, function(xPlayer, announcementType)
    if (type(xPlayer) == "table" and type(announcementType) == "number") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            local jobLabel = Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name].jobLabel
            local announcementCategory = announcementType == 1 and "open" or announcementType == 2 and "close" or "recruitment"
            local announcementContent = Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name].announcements[announcementCategory]

            Server:showSocietyNotify(xPlayer, xPlayer.job.name, jobLabel, announcementContent, "Informations", 10)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.sendPersoAnnouncement, function(xPlayer, announcement)
    if (type(xPlayer) == "table" and type(announcement) == "string") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            if (xPlayer.job.grade == 4) then
                local jobLabel = Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name].jobLabel
                Server:showSocietyNotify(xPlayer, xPlayer.job.name, jobLabel, announcement, "Informations", 10)
            else
                Server:showNotification(xPlayer.source, "Vous devez etre patron pour faires des annonces Personnalisé", false)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.requestClean, function(xPlayer, targetID, networkID)
    if (type(xPlayer) == "table" and type(targetID) == "number" and type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)
        local xTarget = ESX.GetPlayerFromId(targetID)
        local cleanItem = Engine["Config"]["Mecano"]["Items"]["clean"]

        if (vehicle ~= 0 and DoesEntityExist(vehicle) and type(xTarget) == "table") then
            if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
                local playerItem = xPlayer.getInventoryItem(cleanItem)

                if (playerItem and tonumber(playerItem.quantity) >= 1) then
                    Server:showNotification(xPlayer.source, "Vous avez envoyé une facture", false)

                    local bill = ESX.CreateBill(xPlayer.source, xTarget.source, Engine["Config"]["Mecano"]["Prices"]["cleanVehicle"], "Nettoyage du véhicule", "society", xPlayer.job.name)

                    if (bill) then
                        xPlayer.removeInventoryItem(cleanItem, 1)
                        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receiveClean, networkID)
                    else
                        Server:showNotification(xPlayer.source, "La personne à refuser la facture")
                    end
                else
                    Server:showNotification(xPlayer.source, "Vous n'avez pas de kit de nettoyage sur vous", false)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.requestRepair, function(xPlayer, targetID, networkID)
    if (type(xPlayer) == "table" and type(targetID) == "number" and type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)
        local xTarget = ESX.GetPlayerFromId(targetID)
        local repairItem = Engine["Config"]["Mecano"]["Items"]["repair"]

        if (vehicle ~= 0 and DoesEntityExist(vehicle) and type(xTarget) == "table") then
            if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
                local playerItem = xPlayer.getInventoryItem(repairItem)

                if (playerItem and tonumber(playerItem.quantity) >= 1) then
                    Server:showNotification(xPlayer.source, "Vous avez envoyé une facture", false)

                    local bill = ESX.CreateBill(xPlayer.source, xTarget.source, Engine["Config"]["Mecano"]["Prices"]["repairVehicle"], "Réparation du véhicule", "society", xPlayer.job.name)

                    if (bill) then
                        xPlayer.removeInventoryItem(repairItem, 1)
                        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receiveRepair, networkID)
                    else
                        Server:showNotification(xPlayer.source, "La personne à refuser la facture")
                    end
                else
                    Server:showNotification(xPlayer.source, "Vous n'avez pas de kit de réparation sur vous", false)
                end
            end
        end
    end
end)


Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.requestUnlockVehicle, function(xPlayer, networkID)
    if (type(xPlayer) == "table" and type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)
        local unlockItem = Engine["Config"]["Mecano"]["Items"]["unlock"]

        if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
            if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
                if (GetVehicleDoorLockStatus(vehicle) == 2) then
                    local playerItem = xPlayer.getInventoryItem(unlockItem)

                    if (playerItem and tonumber(playerItem.quantity) >= 1) then
                        xPlayer.removeInventoryItem(unlockItem, 1)
                        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receiveUnlockVehicle, networkID)
                    else
                        Server:showNotification(xPlayer.source, "Vous n'avez pas de kit de crochetage sur vous", false)
                    end
                else
                    Server:showNotification(xPlayer.source, "Le véhicule est déjà déverrouillé", false)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.requestSyncUnlockVehicle, function(xPlayer, networkID)
    if (type(xPlayer) == "table" and type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)

        if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
            if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
                SetVehicleDoorsLocked(vehicle, 1)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.sendCustomBill, function(xPlayer, targetID, amount, reason)
    if (type(xPlayer) == "table" and type(targetID) == "number" and type(amount) == "number" and type(reason) == "string") then
        local xTarget = ESX.GetPlayerFromId(targetID)

        if (type(xTarget) == "table") then
            if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
                local bill = ESX.CreateBill(xPlayer.source, xTarget.source, amount, reason, "society", xPlayer.job.name)

                if (not bill) then
                    Server:showNotification(xPlayer.source, "La facture a été refusée", false)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.setPercentage, function(xPlayer, percentage)
    if (type(xPlayer) == "table" and type(percentage) == "number") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            if (xPlayer.job.grade_name == "boss") then
                local minimum = Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name].minPercentage
                local maximum = Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name].maxPercentage

                if (tonumber(percentage) >= minimum and tonumber(percentage) <= maximum) then
                    local society = ESX.DoesSocietyExist(xPlayer.job.name)

                    if (society) then
                        Engine.Mecano:setPercentage(xPlayer.job.name, percentage)
                        Server:showNotification(xPlayer.source, "Vous avez defini le pourcentage de vente à %s%%", false, percentage)
                    end
                else
                    Server:showNotification(xPlayer.source, "Veuillez entrer un pourcentage entre %s%% et %s%%", false, minimum, maximum)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.requestPercentage, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            local percentage = Engine.Mecano:getPercentage(xPlayer.job.name)

            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receivePercentage, percentage)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.requestClothes, function(xPlayer, sex)
    if (type(xPlayer) == "table") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            local clothes = Engine.Mecano:getClothes(xPlayer.job.name, sex)

            if (clothes) then
                local data = {}

                for k, v in pairs(clothes) do
                    data[k] = {}
                end

                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receiveClothes, data)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.addClothes, function(xPlayer, name, sex, clothes)
    if (type(xPlayer) == "table" and type(name) == "string" and type(sex) == "string" and type(clothes) == "table") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            if ((Engine.Mecano:getClothesCount(xPlayer.job.name, sex) + 1) <= 10) then
                if (not Engine.Mecano:doesClothesNameExist(xPlayer.job.name, sex, name)) then
                    if (Engine.Mecano:addClothes(xPlayer.job.name, name, sex, clothes)) then
                        Server:showNotification(xPlayer.source, "La tenue %s%s~s~ a été ajoutée", false, "~b~", name)
                    end
                else
                    Server:showNotification(xPlayer.source, "Ce nom de tenue existe déjà", false)
                end
            else
                Server:showNotification(xPlayer.source, "Vous avez atteint le nombre maximum de tenues", false)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.removeClothes, function(xPlayer, name, sex)
    if (type(xPlayer) == "table" and type(name) == "string" and type(sex) == "string") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            if (Engine.Mecano:doesClothesNameExist(xPlayer.job.name, sex, name)) then
                if (Engine.Mecano:removeClothes(xPlayer.job.name, sex, name)) then
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receiveRemoveClothes, name)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.takeOutfit, function(xPlayer, sex, name)
    if (type(xPlayer) == "table" and type(sex) == "string" and type(name) == "string") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            local outfit = Engine.Mecano:getOutfit(xPlayer.job.name, sex, name)

            if (outfit) then
                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.receiveOutfit, outfit)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.craftItem, function(xPlayer, index, amount)
    if (type(xPlayer) == "table" and type(index) == "number" and type(amount) == "number") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            if (not Engine.Mecano:isPlayerInCraft(xPlayer.identifier)) then
                local craftItem = Engine["Config"]["Mecano"]["CraftItems"][index]

                if (craftItem) then
                    if (xPlayer.canCarryItem(craftItem.item, amount)) then
                        local price = craftItem.price * amount
                        local society = ESX.DoesSocietyExist(xPlayer.job.name)

                        if (society) then
                            ESX.RemoveSocietyMoney(xPlayer.job.name, price)
                            Engine.Mecano:setPlayerInCraft(xPlayer.identifier, craftItem.item, craftItem.label, amount)
                            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Mecano.Events.startCraftAnimation, (craftItem.time * amount))
                        end
                    else
                        Server:showNotification(xPlayer.source, "Vous n'avez plus de place sur vous", false)
                    end
                end
            else
                Server:showNotification(xPlayer.source, "Vous êtes déjà en train de fabriquer un objet", false)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].Mecano.Events.receiveCraftItem, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (Engine["Config"]["Mecano"]["Zones"][xPlayer.job.name] ~= nil) then
            if (Engine.Mecano:isPlayerInCraft(xPlayer.identifier)) then
                local craftItem = Engine.Mecano:getPlayerCraftItem(xPlayer.identifier)

                if (craftItem) then
                    local item = craftItem.item
                    local label = craftItem.label
                    local amount = craftItem.amount

                    xPlayer.addInventoryItem(item, amount)
                    Engine.Mecano:removePlayerInCraft(xPlayer.identifier)
                    Server:showNotification(xPlayer.source, "Vous avez fabriqué %s %s", false, amount, label)
                end
            end
        end
    end
end)
