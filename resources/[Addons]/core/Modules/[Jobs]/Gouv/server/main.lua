local SpawnTimeout = {}
local CheckDataTimeout = {}

RegisterNetEvent("iZeyy:gouv:handcuff", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "gouv" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:gouv:player:handcuff", target)
                    TriggerClientEvent("iZeyy:gouv:cop:handcuff", source)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:gouv:handcuff)")
        end
    end
end)

RegisterNetEvent("iZeyy:gouv:unhandcuff", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then
        if xPlayer.job.name == "gouv" then
            if target ~= -1 and xTarget then
                local gouvCoords = GetEntityCoords(GetPlayerPed(source))
                local targetCoords = GetEntityCoords(GetPlayerPed(target))

                if #(gouvCoords - targetCoords) < 10.0 then
                    TriggerClientEvent("iZeyy:gouv:player:unhandcuff", target)

                    xPlayer.showNotification("Vous avez démenotté le joueur.")
                    xTarget.showNotification("Vous avez été démenotté.")
                else
                    xPlayer.showNotification("Aucun joueurs n'est a proximité")
                end
            end
        else
            xPlayer.ban(0, "(iZeyy:gouv:unhandcuff) Tentative de démenotter sans permission.")
        end
    end
end)


RegisterNetEvent("iZeyy:gouv:escort", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "gouv" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:gouv:player:escort", target, source)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:gouv:escort)")
        end
    end
end)

RegisterNetEvent("iZeyy:gouv:putInVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "gouv" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:gouv:player:putInVehicle", target)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:gouv:putInVehicule)")
        end
    end
end)

RegisterNetEvent("iZeyy:gouv:putOutVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer and xTarget then

        if xPlayer.job.name == "gouv" then

            if (target ~= -1 and xTarget) then

                if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 10.0 then
                    TriggerClientEvent("iZeyy:gouv:player:putOutVehicle", target)
                end

            end

        else
            xPlayer.ban(0, "(iZeyy:gouv:putInVehicule)")
        end
    end
end)

RegisterNetEvent("iZeyy:gouv:takeArmoryWeapon")
AddEventHandler("iZeyy:gouv:takeArmoryWeapon", function(weapon, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)
    local correctWeapon = false

    if xPlayer then
        if xPlayer.job.name ~= "gouv" then
            xPlayer.ban(0, "(iZeyy:gouv:takeArmoryWeapon) (job)")
            return
        end

        for k, v in pairs(Config["Gouv"]["ArmoryWeapon"]) do
            if weapon == v.weapon and label == v.label then
                correctWeapon = true
                break
            end
        end

        if correctWeapon then
            if #(coords - Config["Gouv"]["Armory"]) < 15 then
                local weaponItem = xPlayer.getInventoryItem(weapon)
                local currentWeaponCount = weaponItem and weaponItem.count or 0

                if currentWeaponCount < 1 then
                    if (xPlayer.canCarryItem(string.lower(weapon), 1)) then
                        xPlayer.addWeapon(weapon, 1)
                        xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                    else
                        xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                    end
                else
                    xPlayer.showNotification("Vous ne pouvez pas prendre plus d'armes.")
                end
            else
                xPlayer.ban(0, "(iZeyy:gouv:takeArmoryWeapon) (coords)")
            end
        else
            xPlayer.ban(0, "(iZeyy:gouv:takeArmoryWeapon) (correctWeapon)")
        end
    end
end)

RegisterNetEvent("iZeyy:gouv:buyKevlar", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then
        if xPlayer.job.name ~= "gouv" then
            xPlayer.ban(0, "(iZeyy:gouv:buyKevlar) (job)")
            return
        end

        if #(coords - Config["Gouv"]["Armory"]) < 15 then
            local hasItem = xPlayer.getInventoryItem(weapon)
            local currentItemCount = hasItem and hasItem.count or 0

            if currentItemCount < 1 then
                if (xPlayer.canCarryItem("kevlar", 1)) then
                    xPlayer.addInventoryItem("kevlar", 1)
                    xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                else
                    xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                end
            else
                xPlayer.showNotification("Vous ne pouvez pas prendre plus de kevlar.")
            end
        else
            xPlayer.ban(0, "(iZeyy:gouv:buyKevlar) (coords)")
        end

    end
end)

RegisterNetEvent("iZeyy:gouv:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.job.name ~= "gouv") then
            return xPlayer.ban(0, "(iZeyy:gouv:frisk)")
        end

        local player = GetPlayerPed(xPlayer.source)
        local target = GetPlayerPed(xTarget.source)
        local playerCoords = GetEntityCoords(player)
        local targetCoords = GetEntityCoords(target)

        if #(playerCoords - targetCoords) > 15 then
            return xPlayer.ban(0, "(iZeyy:gouv:frisk) #2")
        end

        exports["inventory"]:FriskTarget(xPlayer.source, xTarget.source)
    end
end)

RegisterNetEvent("iZeyy:gouv:close:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (xPlayer.job.name ~= "gouv") then
            return xPlayer.ban(0, "(iZeyy:gouv:frisk)")
        end

        exports["inventory"]:CloseFrisk(xPlayer.source, xTarget.source)
    end
end)

RegisterNetEvent("iZeyy:gouv:removeWeapon", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then

        if #(coords - Config["Gouv"]["Armory"]) < 15 then

            if xPlayer.job.name ~= "gouv" then
                xPlayer.ban(0, "(iZeyy:gouv:takeArmoryItems) (job)")
                return
            end

            for _, weaponData in ipairs(Config["Gouv"]["ArmoryWeapon"]) do
                local weapon = weaponData.weapon

                if xPlayer.getInventoryItem(weapon) then
                    xPlayer.removeWeapon(weapon)
                    xPlayer.showNotification("Vous avez rendu vos armes de services")
                end
            end
        else
            xPlayer.ban(0, "(iZeyy:gouv:takeArmoryItems) (pos)")
        end
    end
end)

RegisterNetEvent("iZeyy:Gouv:SpawnVehicle", function(Model, Label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    local correctVehicle = false

    if xPlayer then
        if xPlayer.job.name ~= "gouv" then
            xPlayer.ban(0, "(iZeyy:Gouv:SpawnVehicle) (job)")
            return
        end

        if (not SpawnTimeout[xPlayer.identifier] or GetGameTimer() - SpawnTimeout[xPlayer.identifier] > 10000) then
            SpawnTimeout[xPlayer.identifier] = GetGameTimer()

            for k, v in pairs(Config["Gouv"]["VehList"]) do
                if Model == v.model and Label == v.label then
                    correctVehicle = true
                    break
                end
            end

            if not (correctVehicle) then
                return
            end

            if #(coords - Config["Gouv"]["Garage"]) < 15 then
                local spawnPos = Config["Gouv"]["SpawnCarPos"]
                ESX.SpawnVehicle(Model, spawnPos, 0, nil, false, xPlayer, xPlayer.identifier, function(handle)
                    --TaskWarpPedIntoVehicle(ped, handle, -1);
                    SetPedIntoVehicle(GetPlayerPed(xPlayer.source), handle:GetHandle(), -1)
                end);
            else
                xPlayer.ban(0, "(iZeyy:Gouv:SpawnVehicle) (coords)")
            end

        else
            xPlayer.showNotification("Veuillez attendre 10 seconde avant de refaire appel a un véhicule")
        end
    end
end)

RegisterNetEvent("iZeyy:Gouv:GetSociety", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)

    if xPlayer then
        if xPlayer.job.name ~= "gouv" then
            xPlayer.ban(0, "(iZeyy:Gouv:GetSociety) (job)")
            return
        end

        if (not CheckDataTimeout[xPlayer.identifier] or GetGameTimer() - CheckDataTimeout[xPlayer.identifier] > 3600000) then
            CheckDataTimeout[xPlayer.identifier] = GetGameTimer()

            if #(coords - Config["Gouv"]["OfficePos"]) < 15 then
                local allowedJobs = {
                    ["police"] = true,
                    ["ambulance"] = true,
                    ["gouv"] = true,
                    ["avocat"] = true,
                    ["cardealer"] = true,
                    ["boatseller"] = true,
                    ["planeseller"] = true,
                    ["mecano"] = true,
                    ["mecano2"] = true
                }

                MySQL.Async.fetchAll("SELECT name, label, money FROM societies_storage", {}, function(societies)
                    local societiesData = {}

                    for _, society in ipairs(societies) do
                        if allowedJobs[society.name] then
                            table.insert(societiesData, {
                                label = society.label,
                                money = society.money
                            })
                        end
                    end

                    table.sort(societiesData, function(a, b)
                        return a.money > b.money
                    end)
                    TriggerClientEvent("iZeyy:Gouv:ReceiveSocietyData", xPlayer.source, societiesData)
                end)
            else
                xPlayer.ban(0, "(iZeyy:Gouv:SpawnVehicle) (coords)")
            end
        else
            xPlayer.showNotification("Vous avez regardé les coffres il y a moins de 1h, mise à jour des coffres dans 1h.")
        end
    end
end)

