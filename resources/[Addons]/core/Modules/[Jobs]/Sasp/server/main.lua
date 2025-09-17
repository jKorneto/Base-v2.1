RegisterNetEvent("iZeyy:police:handcuff", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "police" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:police:player:handcuff", target)
                    TriggerClientEvent("iZeyy:police:cop:handcuff", source)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:police:handcuff)")
        end
    end
end)

RegisterNetEvent("iZeyy:police:unhandcuff", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then
        if xPlayer.job.name == "police" then
            if target ~= -1 and xTarget then
                local policeCoords = GetEntityCoords(GetPlayerPed(source))
                local targetCoords = GetEntityCoords(GetPlayerPed(target))

                if #(policeCoords - targetCoords) < 10.0 then
                    TriggerClientEvent("iZeyy:police:player:unhandcuff", target)

                    xPlayer.showNotification("Vous avez démenotté le joueur.")
                    xTarget.showNotification("Vous avez été démenotté.")
                else
                    xPlayer.showNotification("Aucun joueurs n'est a proximité")
                end
            end
        else
            xPlayer.ban(0, "(iZeyy:police:unhandcuff) Tentative de démenotter sans permission.")
        end
    end
end)


RegisterNetEvent("iZeyy:police:escort", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "police" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:police:player:escort", target, source)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:police:escort)")
        end
    end
end)

RegisterNetEvent("iZeyy:police:putInVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "police" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:police:player:putInVehicle", target)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:police:putInVehicule)")
        end
    end
end)

RegisterNetEvent("iZeyy:police:putOutVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "police" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:police:player:putOutVehicle", target)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:police:putInVehicule)")
        end
    end
end)

RegisterNetEvent("iZeyy:police:sendFine", function(target, type)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)
	local price = 0

    if (not xPlayer) then return; end
    if (not xTarget) then return; end

    if xPlayer.job.name ~= "police" then
        xPlayer.ban(0, "(iZeyy:police:sendFine)")
        return
    end

    local society = ESX.DoesSocietyExist("police")

    if (not society) then return; end

    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then

        for k, v in pairs(Config["PoliceJob"]["Fine"]) do
            if v.label == type then
                price = v.price
                break
            end
        end

        xTarget.removeAccountMoney("bank", price)
        ESX.AddSocietyMoney("police", price / 2)
        ESX.AddSocietyMoney("gouv", price / 2)
        xTarget.showNotification("Votre compte en banque à été réduit de "..price.."~g~$~s~.")
        xPlayer.showNotification("Vous avez donné une amende de "..price.."~g~$~s~")
        CoreSendLogs("Bill", "OneLife | Bill", xPlayer.getLastName().." "..xPlayer.getFirstName().." (***"..xPlayer.identifier.."***) vient d'envoyer une amende de **"..price.."** $ à "..xTarget.getLastName().." "..xTarget.getFirstName().." (***"..xTarget.identifier.."***)", Config["Log"]["Job"]["police"]["send_bill"])
        return;
    end
    xPlayer.showNotification("Une erreur est survenue, lors de l'envoi de l'amende veuillez refaire la requête")
end)

RegisterNetEvent("iZeyy:police:requestVehicleInfo", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:requestVehicleInfo)")
            return
        end

        MySQL.Async.fetchAll("SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate", {
            ["@plate"] = plate
        }, function(result)
            local requestVehicleInfo = {
                plate = plate,
                owner = nil,
                vehicle = nil
            }
            if result[1] then
                MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
                    ["@identifier"] = result[1].owner
                }, function(result2)
                    if result2[1] then
                        requestVehicleInfo.owner = result2[1].firstname .. " " .. result2[1].lastname
                        requestVehicleInfo.vehicle = json.decode(result[1].vehicle)
                        TriggerClientEvent("iZeyy:police:player:receiveVehicleInfo", xPlayer.source, requestVehicleInfo.plate, requestVehicleInfo.owner, requestVehicleInfo.vehicle)
                    end
                end)
            else
                TriggerClientEvent("iZeyy:police:player:receiveVehicleInfo", xPlayer.source, requestVehicleInfo.plate, requestVehicleInfo.owner, requestVehicleInfo.vehicle)
            end            

        end)

    end
end)

local poundTimeout = {}
RegisterNetEvent("iZeyy:police:putInPound", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:putInPound)")
            return
        end

        if (not poundTimeout[xPlayer.identifier] or GetGameTimer() - poundTimeout[xPlayer.identifier] > 10000) then
            poundTimeout[xPlayer.identifier] = GetGameTimer()

            local playerCoord = GetEntityCoords(GetPlayerPed(source))
            local vehicle = {}

            for k,v in pairs(GetAllVehicles()) do
                local entityCoord = GetEntityCoords(v)
                local dist = #(playerCoord - entityCoord)

                if vehicle.dist == nil and DoesEntityExist(v) then
                    vehicle.dist = dist
                    vehicle.entity = v
                end

                if DoesEntityExist(v) and vehicle.dist > dist then
                    vehicle.dist = dist
                    vehicle.entity = v
                end
            end

            if vehicle.dist < 5 then
                DeleteEntity(vehicle.entity)
            end

        else
            xPlayer.showNotification("Vous devez attendre 10 secondes avant de faire appel à une dépanneuse à nouveau")
        end
    end
end)

local backupTimeout = {}
RegisterNetEvent("iZeyy:police:callBackup", function(coords, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if xPlayer and xPlayers then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:callBackup)")
            return
        end

        if (not backupTimeout[xPlayer.identifier] or GetGameTimer() - backupTimeout[xPlayer.identifier] > 15000) then
            backupTimeout[xPlayer.identifier] = GetGameTimer()

            for i = 1, #xPlayers, 1 do
                local player = ESX.GetPlayerFromId(xPlayers[i]);
                if (player) then
                    if player.job.name == "police" then
                        TriggerClientEvent("iZeyy:police:player:receiveBackupAlert", player.source, coords, type);
                    end
                end
            end
        else
            xPlayer.showNotification("Vous devez attendre 60 secondes avant de faire une demande à nouveau")
        end
    end
end)

RegisterNetEvent("iZeyy:police:takeArmoryWeapon")
AddEventHandler("iZeyy:police:takeArmoryWeapon", function(weapon, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)
    local correctWeapon = false

    if xPlayer then
        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:takeArmoryWeapon) (job)")
            return
        end

        for k, v in pairs(Config["PoliceJob"]["ArmoryWeapon"]) do
            if weapon == v.weapon and label == v.label then
                correctWeapon = true
                break
            end
        end

        if correctWeapon then
            if #(coords - Config["PoliceJob"]["Armory"]) < 15 then
                local weaponItem = xPlayer.getInventoryItem(weapon)
                local currentWeaponCount = weaponItem and weaponItem.quantity or 0

                if currentWeaponCount < 1 then
                    if (xPlayer.canCarryItem(string.lower(weapon), 1)) then
                        xPlayer.addWeapon(weapon, 1)
                        xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                        CoreSendLogs(
                            "Armurerie",
                            "OneLife | Armurerie",
                            ("Le Joueur %s (***%s***) viens de prendre (***%s***) de la societé (***%s***)"):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                weapon,
                                xPlayer.getJob().label
                            ),
                            Config["Log"]["Job"]["police"]["take_wepaon"]
                        )
                    else
                        xPlayer.showNotification("Vous n'avez pas de place sur vous")
                    end
                else
                    xPlayer.showNotification("Vous ne pouvez pas prendre plus d'armes.")
                end
            else
                xPlayer.ban(0, "(iZeyy:police:takeArmoryWeapon) (coords)")
            end
        else
            xPlayer.ban(0, "(iZeyy:police:takeArmoryWeapon) (correctWeapon)")
        end
    end
end)

RegisterNetEvent("iZeyy:police:takeArmoryItems", function(items, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)
    local correctItems = false

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:takeArmoryItems) (job)")
            return
        end

        for k, v in pairs(Config["PoliceJob"]["ArmoryItems"]) do
            if items == v.items and label == v.label then
                correctItems = true
                break
            end
        end

        if correctItems then
            if #(coords - Config["PoliceJob"]["Armory"]) < 15 then
                local hasItems = xPlayer.getInventoryItem(items)
                local currentItemCount = hasItems and hasItems.quantity or 0

                if currentItemCount < 3 then
                    if (xPlayer.canCarryItem(items, 1)) then
                        xPlayer.addInventoryItem(items, 1)
                        xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                        CoreSendLogs(
                            "Equipements",
                            "OneLife | Equipements",
                            ("Le Joueur %s (***%s***) viens de prendre (***%s***) de la societé (***%s***)"):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                items,
                                xPlayer.getJob().label
                            ),
                            Config["Log"]["Job"]["police"]["take_wepaon"]
                        )
                    else
                        xPlayer.showNotification("Vous n'avez pas de place sur vous")
                    end
                else
                    xPlayer.showNotification("Vous ne pouvez pas prendre plus d'items que ce vous avez deja sur vous")
                end
            else
                xPlayer.ban(0, "(iZeyy:police:takeArmoryItems) (correctItems)")
            end
        else
            xPlayer.ban(0, "(iZeyy:police:takeArmoryItems) (correctItems)")
        end

    end
end)

RegisterNetEvent("iZeyy:police:takeArmoryAmmo", function(items, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)
    local correctItems = false

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:takeArmoryAmmo) (job)")
            return
        end

        for k, v in pairs(Config["PoliceJob"]["ArmoryAmmo"]) do
            if items == v.items and label == v.label then
                correctItems = true
                break
            end
        end

        if correctItems then
            if #(coords - Config["PoliceJob"]["Armory"]) < 15 then
                local hasItems = xPlayer.getInventoryItem(items)
                local currentItemCount = hasItems and hasItems.quantity or 0

                if currentItemCount < 90 then
                    xPlayer.addInventoryItem(items, 30)
                    xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                    CoreSendLogs(
                        "Equipements",
                        "OneLife | Equipements",
                        ("Le Joueur %s (***%s***) viens de prendre (***%s***) de la societé (***%s***)"):format(
                            xPlayer.getName(),
                            xPlayer.identifier,
                            items,
                            xPlayer.getJob().label
                        ),
                        Config["Log"]["Job"]["police"]["take_wepaon"]
                    )
                else
                    xPlayer.showNotification("Vous ne pouvez pas prendre plus de chareur que ce vous avez deja sur vous")
                end
            else
                xPlayer.ban(0, "(iZeyy:police:takeArmoryAmmo) (correctItems)")
            end
        else
            xPlayer.ban(0, "(iZeyy:police:takeArmoryAmmo) (correctItems)")
        end

    end
end)

RegisterNetEvent("iZeyy:police:weaponService", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:takeArmoryItems) (job)")
            return
        end

        for _, weaponData in ipairs(Config["PoliceJob"]["ArmoryWeapon"]) do
            local weapon = weaponData.weapon

            if xPlayer.getInventoryItem(weapon) then
                xPlayer.removeWeapon(weapon)
            end
        end

        for _, itemsData in ipairs(Config["PoliceJob"]["ArmoryItems"]) do
            local item = itemsData.items

            if xPlayer.getInventoryItem(item) then
                xPlayer.removeInventoryItem(item, 3)
            end
        end

        xPlayer.showNotification("Vous avez rendu votre equipements de service")
    end
end)

SaspInService = {}

RegisterNetEvent("iZeyy:job:policeService", function(isInService)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:serviceJob)")
            return
        end

        if #(coords - Config["PoliceJob"]["Cloakroom"]) < 15 then
            if isInService == true then
                if (SaspInService[xPlayer.identifier] == nil) then
                    TriggerEvent('iZeyy:AddCountPoliceInService', xPlayer.source)
                    SaspInService[xPlayer.identifier] = xPlayer.source
                end
            elseif isInService == false then
                if (SaspInService[xPlayer.identifier]) then
                    TriggerEvent('iZeyy:RemoveCountPoliceInService', xPlayer.source)
                    SaspInService[xPlayer.identifier] = nil
                end
            end
        else
            xPlayer.ban(0, "(iZeyy:police:serviceZone)")
        end

    end
end)

exports("GetPoliceInService", SaspInService)

RegisterNetEvent("iZeyy:Trunk:destroyDirtyMoney", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then

        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:Trunk:destroyDirtyMoneyJob)")
            return
        end

        if #(coords - Config["PoliceJob"]["SeizedTrunk"]) < 15 then
            if count > 0 and xPlayer.getAccount("dirtycash").money >= count then
                xPlayer.removeAccountMoney("dirtycash", count)
                xPlayer.showNotification(("Vous avez detruit %d$"):format(count))
                CoreSendLogs(
                    "Destruction d'Argent",
                    "OneLife | Destruction d'Argent",
                    ("Le Joueur %s (***%s***) viens de detruire (***%s***$) d'argent sale avec le job (***%s***)"):format(
                        xPlayer.getName(),
                        xPlayer.identifier,
                        count,
                        xPlayer.getJob().label
                    ),
                    Config["Log"]["Job"]["police"]["destroy_dirtycash"]
                )
            else
                xPlayer.showNotification("Vous ne possedez pas cette sommes d'argents")
            end
        else
            xPlayer.ban(0, "(iZeyy:Trunk:destroyDirtyMoneyPos)")
        end

    end
end)

RegisterNetEvent("iZeyy:police:requestInventory", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if (xPlayer) then
        local player = GetPlayerPed(xPlayer.source)
        local coords = GetEntityCoords(player)

        if (xPlayer.job.name ~= "police") then
            return xPlayer.ban(0, "(iZeyy:police:requestInventoryJob)")
        end

        if #(coords - Config["PoliceJob"]["SeizedTrunk"]) > 15 then
            return xPlayer.ban(0, "(iZeyy:police:requestInventoryPos)")
        end

        local data = {}

        for i = 1, #xPlayer.getInventory() do
            local weapon = xPlayer.getInventory()[i]

            if (weapon ~= "empty" and weapon.type == "weapons") then
                table.insert(data, {
                    name = weapon.name,
                    label = weapon.label
                })
            end
        end

        TriggerClientEvent("iZeyy:police:receiveLoadout", xPlayer.source, data)
    end
end)

RegisterNetEvent("iZeyy:police:deposeWeapon", function(index, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local player = GetPlayerPed(xPlayer.source)
        local coords = GetEntityCoords(player)

        if (xPlayer.job.name ~= "police") then
            return xPlayer.ban(0, "(iZeyy:police:requestInventoryJob)")
        end

        if #(coords - Config["PoliceJob"]["SeizedTrunk"]) > 15 then
            return xPlayer.ban(0, "(iZeyy:police:requestInventoryPos)")
        end
        
        if (type(weapon) == "table") then
            if (xPlayer.getInventoryItem(weapon.name)) then
                xPlayer.removeInventoryItem(weapon.name, 1)
                xPlayer.showNotification(("Vous avez deposé: %s"):format(weapon.label))
                CoreSendLogs(
                    "Destruction d'Armes",
                    "OneLife | Destruction d'Armes",
                    ("Le Joueur %s (***%s***) viens de detruire une arme (***%s***) avec le job (***%s***)"):format(
                        xPlayer.getName(),
                        xPlayer.identifier,
                        weapon.name,
                        xPlayer.getJob().label
                    ),
                    Config["Log"]["Job"]["police"]["destroy_weapon"]
                )
                TriggerClientEvent("iZeyy:police:removeWeapon", xPlayer.source, index)
            end
        end
    end
end)

RegisterNetEvent("iZeyy:police:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.job.name ~= "police") then
            return xPlayer.ban(0, "(iZeyy:police:frisk)")
        end

        local player = GetPlayerPed(xPlayer.source)
        local target = GetPlayerPed(xTarget.source)
        local playerCoords = GetEntityCoords(player)
        local targetCoords = GetEntityCoords(target)

        if #(playerCoords - targetCoords) > 15 then
            return xPlayer.ban(0, "(iZeyy:police:frisk) #2")
        end

        exports["inventory"]:FriskTarget(xPlayer.source, xTarget.source)
    end
end)

RegisterNetEvent("iZeyy:police:close:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.job.name ~= "police") then
            return xPlayer.ban(0, "(iZeyy:police:frisk)")
        end

        exports["inventory"]:CloseFrisk(xPlayer.source, xTarget.source)
    end
end)

AddEventHandler("playerDropped", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        for _, weaponInfo in pairs(Config["PoliceJob"]["ArmoryWeapon"]) do
            xPlayer.removeWeapon(weaponInfo.weapon)
        end
    end
end)

local spawnTimeout = {}
RegisterNetEvent("iZeyy:police:spawnVehicle", function(model, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    local correctVehicle = false

    if xPlayer then
        if xPlayer.job.name ~= "police" then
            xPlayer.ban(0, "(iZeyy:police:spawnVehicle) (job)")
            return
        end

        if (not spawnTimeout[xPlayer.identifier] or GetGameTimer() - spawnTimeout[xPlayer.identifier] > 10000) then
            spawnTimeout[xPlayer.identifier] = GetGameTimer()

            for k, v in pairs(Config["PoliceJob"]["GarageVehicle"]) do
                if model == v.vehicle and label == v.label then
                    correctVehicle = true
                    break
                end
            end

            if correctVehicle then

                if #(coords - Config["PoliceJob"]["Garage"]) < 15 then
                    local spawnPos = Config["PoliceJob"]["GarageSpawn"]
                    local garageHeading = Config["PoliceJob"]["GarageHeading"]
                    if (IsSpawnPointClear(spawnPos, 5)) then
                        ESX.SpawnVehicle(model, spawnPos, garageHeading, nil, false, xPlayer, xPlayer.identifier, function(handle)
                            --TaskWarpPedIntoVehicle(ped, handle, -1);
                            SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
                        end)
                    else
                        xPlayer.showNotification("La place est déja occupé par un véhicule")
                    end
                else
                    xPlayer.ban(0, "(iZeyy:police:spawnVehicle) (coords)")
                end

            else
                xPlayer.ban(0, "(iZeyy:police:spawnVehicle) (correctVehicle)")
            end

        else
            xPlayer.showNotification("Vous devez attendre 10 secondes avant de faire appel à un véhicule à nouveau")
        end

    end
end)

RegisterNetEvent("iZeyy:AmendeCar", function(Plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = Plate 

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		if result[1] then
            MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
                {
                    ['@identifier']  = result[1].owner,
                    ['@sender']      = "license:xxxxx",
                    ['@target_type'] = 'player',
                    ['@target']      = "police",
                    ['@label']       = "Stationnement",
                    ['@amount']      = 1000,
                }, function() 
            end)
            CoreSendLogs(
                "Bill Car",
                "OneLife | Bill Car",
                ("Le Joueur %s (***%s***) viens de mettre une amende au véhicule du joueurs (***%s***)"):format(
                    xPlayer.getName(),
                    xPlayer.identifier,
                    result[1].owner
                ),
                Config["Log"]["Job"]["police"]["send_bill"]
            )
		end
	end)
end)

RegisterNetEvent("iZeyy:SASP:ShowPoliceBadge", function(Target, Player)
    local xPlayer = ESX.GetPlayerFromId(Player)
    local xTarget = ESX.GetPlayerFromId(Target)
    
    if (xPlayer) then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local TargetPed = GetPlayerPed(xTarget.source)
        local PlayerCoords = GetEntityCoords(PlayerPed)
        local TargetCoords = GetEntityCoords(TargetPed)

        if (xPlayer.job.name ~= "police") then
            return xPlayer.ban(0, "(iZeyy:police:requestInventoryJob)")
        end

        if #(PlayerCoords - TargetCoords) < 10 then
            --@todo plus tard faire ce sys en UI la j'ai la flm y'a du boulot a faire
            local FirstName = xPlayer.get("firstname")
            local LastName = xPlayer.get("lastname")
            xTarget.showNotification("Badge de Police de l'agent ("..FirstName.." "..LastName..")")
        else
            xPlayer.showNotification("Acun joueurs a coté de vous.")
        end
    end
end)

RegisterNetEvent("izeyy:sasp:sendAnnouncement", function(announcement)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        
        if (xPlayer.job.name ~= "police") then
            return
        end

        if (xPlayer.job.grade == 14) then
            local jobLabel = "S.A.S.P"
            showSocietyNotify(xPlayer, xPlayer.job.name, jobLabel, announcement, "Gouvernement", 10)
        else
            return
        end

    end
end)