-- local InGoFast = {}
-- local Vehicle = nil
-- local VehPlate = nil

local GoFast = {}
local Timeout = nil

local function ResetValue()
    GoFast = {
        isActive = false,
        vehPlate = nil,
        vehicle = nil,
        vehicleLabel = nil,
        endpos = nil,
        user = nil,
    }
end

local function NotifyPolice(plate, modelName)
    local policePlayers = ESX.GetPlayers()
    
    for _, playerId in ipairs(policePlayers) do
        local xPolicePlayer = ESX.GetPlayerFromId(playerId)

        if xPolicePlayer.job.name == "police" then
            xPolicePlayer.showNotification(("Début de GoFast en cours nous recherchons une (~b~%s~s~) avec la plaque suivante [~b~%s~s~]"):format(modelName, plate))
        end
    end
end

RegisterNetEvent("OneLife:GoFast:Start", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        
        if (xPlayer.job.name == "police") then
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerCoords = GetEntityCoords(Player)
        local GoFastPos = Config["GoFast"]["Pos"]
        local Distance = #(PlayerCoords - GoFastPos)

        if (Distance < 15) then
            if (not Timeout or GetGameTimer() - Timeout > 1800000) then
                Timeout = GetGameTimer()
                math.randomseed(GetGameTimer())
                local RandomIndex = math.random(1, #Config["GoFast"]["Vehicle"])
                local RandomCar = Config["GoFast"]["Vehicle"][RandomIndex]
                local RandomPosIndex = math.random(1, #Config["GoFast"]["EndPos"])
                local Destination = Config["GoFast"]["EndPos"][RandomPosIndex]

                ESX.SpawnVehicle(RandomCar, Config["GoFast"]["VehicleSpawn"], Config["GoFast"]["VehicleHeading"], nil, false, xPlayer, nil, function(vehicle)
                    GoFast = {
                        isActive = true,
                        vehPlate = vehicle:GetPlate(),
                        vehicle = vehicle:GetHandle(),
                        vehicleLabel = RandomCar,
                        endpos = Destination,
                        user = xPlayer.identifier,
                    }
                    TriggerClientEvent("OneLife:GoFast:Start", xPlayer.source, {isActive = true, endpos = Destination})
                    NotifyPolice(GoFast.vehPlate, GoFast.vehicleLabel)
                    CoreSendLogs(
                        "GoFast",
                        "OneLife | Debut de GoFast",
                        ("Le Joueur %s (***%s***) viens de lancer un GoFast avec le véhicule (***%s | %s***)"):format(
                            xPlayer.getName(),
                            xPlayer.identifier,
                            GoFast.vehicleLabel,
                            GoFast.vehPlate
                        ),
                        Config["Log"]["Other"]["GoFast"]
                    )
                end)
            else
                xPlayer.showNotification("On a aucune mission actuellement reviens plus tard")
            end
        else
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end
    end
end)

RegisterNetEvent("OneLife:GoFast:End", function(Plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.job.name == "police") then
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end

        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerCoords = GetEntityCoords(Player)
        local Distance = #(PlayerCoords - GoFast.endpos)

        if (Distance < 15) then

            if (GoFast.isActive == true) then

                if (GoFast.vehPlate == Plate) then
                    local Reward = Config["GoFast"]["Reward"]

                    xPlayer.addAccountMoney("dirtycash", Reward)
                    xPlayer.showNotification(("Fin du GoFast vous avez gagné (%s$)"):format(Reward))

                    SetTimeout(2500, function()
                        DeleteEntity(GoFast.vehicle)
                        ResetValue()
                        CoreSendLogs(
                            "GoFast",
                            "OneLife | Fin de GoFast",
                            ("Le Joueur %s (***%s***) viens de finir un GoFast avec un vehicule plaqué [***%s***] et a reçu (***%s***$)"):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                Plate,
                                Reward
                            ),
                            Config["Log"]["Other"]["GoFast"]
                        )
                    end)

                else
                    xPlayer.showNotification("C'est quoi cette merde la ? c'est pas le véhicule du GoFast barre toi de la !")
                    ResetValue()
                end
            end
        end
    end

end)