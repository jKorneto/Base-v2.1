Categories = {}
Vehicles = {}

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM vehicle_categories", {}, function(results)
        if results and #results > 0 then
            for _, row in ipairs(results) do
                Categories[row.name] = {
                    label = row.label,
                    society = row.society
                }
            end
        end
    end)
    MySQL.Async.fetchAll("SELECT * FROM vehicles", {}, function(results)
        if results and #results > 0 then
            for _, row in ipairs(results) do
                Vehicles[row.model] = {
                    name = row.name,
                    price = row.price,
                    category = row.category
                }
            end
        end
    end)
end)

RegisterNetEvent("Core:Cardealer:GetCat", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then

        if #(coords - Config["Cardealer"]["Office"]) < 50 then
            local SocietyCategories = {}
            for name, category in pairs(Categories) do
                if category.society == "carshop" then
                    SocietyCategories[name] = category
                end
            end

            TriggerClientEvent("Core:Cardealer:ReceiveCat", xPlayer.source, SocietyCategories)
        else
            return
        end
    end
end)

RegisterNetEvent("Core:Cardealer:GetVehForCat", function(CategoryName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then
        if #(coords - Config["Cardealer"]["Office"]) < 50 then
            local VehCategories = {}
            
            for model, Veh in pairs(Vehicles) do
                if Veh.category == CategoryName then
                    VehCategories[model] = Veh
                end
            end
            TriggerClientEvent("Core:Cardealer:ReceiveVehForCat", xPlayer.source, VehCategories)
        else
            return
        end
    end
end)

RegisterNetEvent("Core:Cardealer:SendBill", function(Target, Model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(Target)

    if (xPlayer.job.name ~= "cardealer") then
        return DropPlayer(source, "Veuillez vous reconnecter. Erreur : (Core:Cardealer:SendBill) #1")
    end

    local PlayerPed = GetPlayerPed(xPlayer.source)
    local TargetPed = GetPlayerPed(xTarget.source)
    local PCoords = GetEntityCoords(PlayerPed)
    local TCoords = GetEntityCoords(TargetPed)

    local WithinDistance = false
    if #(PCoords - Config["Cardealer"]["Office"]) <= 15 then
        WithinDistance = true
    end

    if not WithinDistance then
        return
    end

    local NearbyPlayers = false
    if (#(PCoords - TCoords) <= 10) then
        NearbyPlayers = true
    end

    if not NearbyPlayers then
        return
    end

    local VehiclePrice = nil
    local BillPrice = nil
    if Vehicles and Vehicles[Model] then
        VehiclePrice = Vehicles[Model].price
        BillPrice = Vehicles[Model].price * 2
    else
        return Shared.Log:Error(("Erreur avec le Prix du Vehicule suivant (%s) de la societé (%s) #1"):format(Model, xPlayer.getJob().label))
    end

    if VehiclePrice then
        local Bill = ESX.CreateBill(xPlayer.source, xTarget.source, BillPrice, "Achat de Véhicule en Concession", "society", "cardealer")
        xPlayer.showNotification("Vous avez envoyez une facture")
        if Bill then
            generateUniquePlate(function(UniquePlate)
                MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, state, boutique, stored) VALUES (@owner, @plate, @vehicle, @type, @state, @boutique, @stored)', {
                    ["@owner"] = xTarget.identifier,
                    ["@plate"] = UniquePlate,
                    ["@vehicle"] = json.encode({
                        model = Model,
                        plate = UniquePlate,
                    }),
                    ["@state"] = 1,
                    ["@boutique"] = 0,
                    ["@stored"] = 0,
                    ["@type"] = "car",
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        ESX.RemoveSocietyMoney("cardealer", VehiclePrice)
                        xTarget.showNotification(("Vous avez recu un véhicule avec la plaque suivante [~b~%s~s~]"):format(UniquePlate))
                        ESX.SpawnVehicle(Model, Config["Cardealer"]["SpawnPos"], Config["Cardealer"]["SpawnHeading"], UniquePlate, true, xTarget, xTarget.identifier, function(vehicle) end)
                        CoreSendLogs(
                            "Cardealer",
                            "OneLife | Cardealer",
                            ("Le Joueur %s (***%s***) viens de vendre un(e) (***%s | %s***) au joueurs %s (***%s***) pour (***%s$***)"):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                Model,
                                UniquePlate,
                                xTarget.getName(),
                                xTarget.identifier,
                                BillPrice
                            ),
                            Config["Log"]["Job"]["cardealer"]["sell_vehicle"]
                        )
                    else
                        StartGift[PlayerId] = nil
                        RewardClaimed[PlayerId] = nil
                    end
                end)
            end)
        else
            xPlayer.showNotification("Le clients a refusé la facture")
            xTarget.showNotification("Vous avez refusé la facture")
        end
    else
        return Shared.Log:Error(("Erreur avec le Prix du Vehicule suivant (%s) de la societé (%s) #2"):format(Model, xPlayer.getJob().label))
    end
end)

RegisterNetEvent("iZeyy:Cardealer:SendAnnoucement", function(announcementType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.job.name ~= "cardealer") then
            xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:Cardealer:SendAnnoucement)")
            return
        end

        local jobLabel = xPlayer.job.name_label
        local announcementCategory = announcementType == 1 and "open" or announcementType == 2 and "close" or "recruitment"
        local announcementContent = Config["Cardealer"]["Annoucement"][announcementCategory]

        showSocietyNotify(xPlayer, xPlayer.job.name, "Concessionaire Véhicule", announcementContent, "Informations", 10)
    end  
end)