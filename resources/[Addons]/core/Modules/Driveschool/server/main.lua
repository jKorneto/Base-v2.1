local rateLimit = {}
local RATE_LIMIT_TIME = 10
local MAX_ACTIONS = 3

local function checkRateLimit(playerIdentifier)
    local currentTime = os.time()

    if not rateLimit[playerIdentifier] then
        rateLimit[playerIdentifier] = {}
    end

    for i = #rateLimit[playerIdentifier], 1, -1 do
        if rateLimit[playerIdentifier][i] < currentTime - RATE_LIMIT_TIME then
            table.remove(rateLimit[playerIdentifier], i)
        end
    end

    if #rateLimit[playerIdentifier] >= MAX_ACTIONS then
        return false
    end

    table.insert(rateLimit[playerIdentifier], currentTime)
    return true
end

RegisterNetEvent("iZeyy:DrivingSchool:HasMoney", function(PriceType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        if #(Coords - Config["DriveSchool"]["Pos"]) > 15 then
            return xPlayer.ban(0, "(iZeyy:DrivingSchool:HasMoneyPos)")
        end

        local playerIdentifier = xPlayer.identifier
        if not checkRateLimit(playerIdentifier) then
            return xPlayer.showNotification("Vous avez atteint le nombre maximum d'actions autorisées. Veuillez attendre un moment.")
        end

        local Prices = {
            code = 750,
            permis = 2000
        }

        local Price = Prices[PriceType]

        if not Price then
            return xPlayer.showNotification("Type de prix invalide.")
        end

        local licenseTypes = {
            code = "code",
            permis = "drive"
        }

        MySQL.Async.fetchAll("SELECT * FROM user_licenses WHERE owner = @identifier AND type IN (@type1, @type2)", {
            ["@identifier"] = xPlayer.identifier,
            ["@type1"] = licenseTypes.code,
            ["@type2"] = licenseTypes.permis
        }, function(result)
            local hasCode = false
            local hasPermis = false

            for _, row in ipairs(result) do
                if row.type == licenseTypes.code then
                    hasCode = true
                elseif row.type == licenseTypes.permis then
                    hasPermis = true
                end
            end

            if PriceType == "code" and hasCode then
                return xPlayer.showNotification("Vous avez déjà le code de la route.")
            elseif PriceType == "permis" and hasPermis then
                return xPlayer.showNotification("Vous avez déjà le permis de conduire.")
            end
            
            local Bill = ESX.CreateBill(0, xPlayer.source, Price, "AutoEcole", "server")

            if Bill then
                if PriceType == "permis" then
                    if (IsSpawnPointClear(Config["DriveSchool"]["StartExamPos"], 5)) then
                        ESX.SpawnVehicle(Config["DriveSchool"]["VehModel"], Config["DriveSchool"]["StartExamPos"], Config["DriveSchool"]["StartExamHeading"], nil, false, xPlayer, nil, function(vehicle)
                            --TaskWarpPedIntoVehicle(player, vehicle, -1)
                            SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
                        end)
                        TriggerClientEvent("iZeyy:DrivingSchool:GoDrive", xPlayer.source)
                    else
                        xPlayer.showNotification("Il y'a déja un véhicule a cette position")
                    end
                else
                    TriggerClientEvent("iZeyy:DrivingSchool:OpenMenu", xPlayer.source)
                end
            else
                xPlayer.showNotification("Vous n'avez pas assez d'argent pour payer.")
            end
        end)
    end
end)

RegisterNetEvent("iZeyy:DrivingSchool:AddDmv", function(dmv)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        if #(Coords - Config["DriveSchool"]["Pos"]) > 15 then
            return xPlayer.ban(0, "(iZeyy:DrivingSchool:AddDmv - Invalid Position)")
        end

        local playerIdentifier = xPlayer.identifier
        if not checkRateLimit(playerIdentifier) then
            return xPlayer.showNotification("Vous avez atteint le nombre maximum d'actions autorisées. Veuillez attendre un moment.")
        end

        MySQL.Async.fetchAll("SELECT * FROM user_licenses WHERE owner = @identifier AND type = @type", {
            ["@identifier"] = xPlayer.identifier,
            ["@type"] = dmv
        }, function(result)
            if result[1] then
                return xPlayer.showNotification("Vous avez déjà ce permis.")
            else
                MySQL.Async.execute("INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)", {
                    ["@type"] = dmv,
                    ["@owner"] = xPlayer.identifier
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        xPlayer.showNotification("Vous avez obtenu votre code de la route")
                    else
                        print("Erreur lors de l'ajout de la license: Code de la route dans le SQL")
                        xPlayer.showNotification("Erreur lors de l'ajout de votre permis, veuillez réessayer.")
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("iZeyy:DrivingSchool:AddDriverLicense", function(drive)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        if #(Coords - Config["DriveSchool"]["EndExamPos"]) > 15 then
            return xPlayer.ban(0, "(iZeyy:DrivingSchool:AddDriverLicense - Invalid Position)")
        end

        local playerIdentifier = xPlayer.identifier
        if not checkRateLimit(playerIdentifier) then
            return xPlayer.showNotification("Vous avez atteint le nombre maximum d'actions autorisées. Veuillez attendre un moment.")
        end

        MySQL.Async.fetchAll("SELECT * FROM user_licenses WHERE owner = @identifier AND type = @type", {
            ["@identifier"] = xPlayer.identifier,
            ["@type"] = drive
        }, function(result)
            if result[1] then
                return xPlayer.showNotification("Vous avez déjà ce permis.")
            else
                MySQL.Async.execute("INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)", {
                    ["@type"] = drive,
                    ["@owner"] = xPlayer.identifier
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        xPlayer.showNotification("Vous avez obtenu votre permis")
                        xPlayer.addInventoryItem("drive", 1)
                    else
                        xPlayer.showNotification("Erreur lors de l'ajout de votre permis, veuillez réessayer.")
                    end
                end)
            end
        end)
    end
end)
