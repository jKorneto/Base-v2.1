local playerDead = {}
local playerHasCall = {}

local function removeByIdentifier(tbl, identifier)
    for i = #tbl, 1, -1 do
        if tbl[i].player == identifier then
            local xPlayers = ESX.GetPlayers()
            table.remove(playerHasCall, i)
            for i = 1, #xPlayers, 1 do
                local player = ESX.GetPlayerFromId(xPlayers[i])

                if (player and player.job.name == "ambulance") then
                    TriggerClientEvent("fowlmas:player:receiveCall", player.source, playerHasCall, false)
                end
            end
        end
    end
end

AddEventHandler("OneLife:Player:playerRevived", function(src)

    local player = ESX.GetPlayerFromId(src)

    if (player) then

        if (playerDead[player.identifier] ~= nil) then

            if (playerDead[player.identifier].canRevive) then
                playerDead[player.identifier] = nil
                removeByIdentifier(playerHasCall, player.identifier)
                player.setDead(false)
                TriggerClientEvent("fowlmas:player:DeadMenu", src, false)
            end

        end

    end

end)

local ReasonType = {
    ["melee"] = {"murdered", "torched", "knifed"},
    ["weapon"] = {"pistoled", "riddled", "rifled", "machine gunned", "pulverized", "sniped", "obliterated", "shredded", "bombed"},
    ["other"] = {"a carkill", "a tuer"}
}

local function getCategoryFromDead(deathReason)
    for category, reasons in pairs(ReasonType) do
        for _, reason in ipairs(reasons) do
            if reason == deathReason then
                return category
            end
        end
    end

    return "other"
end

RegisterNetEvent('playerDied')
AddEventHandler('playerDied', function(id, player, killer, DeathReason, Weapon)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (xPlayer) then
        local category = getCategoryFromDead(DeathReason)
        playerDead[xPlayer.identifier].deadReason = category
    end
end)

AddEventHandler("OneLife:Player:playerDied", function(src)

    local player = ESX.GetPlayerFromId(src)

    if (player) then

        if (playerDead[player.identifier] == nil) then
            playerDead[player.identifier] = {}
            playerDead[player.identifier].timer = GetGameTimer()
            playerDead[player.identifier].isDead = true
            playerDead[player.identifier].canRevive = false
            player.setDead(true)
            TriggerClientEvent("fowlmas:player:DeadMenu", src, true)

        end

    end

end)

RegisterNetEvent("fowlmas:ambulance:heal", function(target, healType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    local price = Config["AmbulanceJob"]["Price"][healType]
    local targetPed = GetPlayerPed(target)
	local targetMaxHealth = GetEntityMaxHealth(targetPed)
	local targetHealth = GetEntityHealth(targetPed)
    local deadReason = "other"

    if (xPlayer and xTarget) then

        if (xPlayer.job.name ~= "ambulance") then
            xPlayer.ban(0, "(fowlmas:ambulance:heal)")
            return
        end

        if #(GetEntityCoords(GetPlayerPed(xPlayer.source)) - GetEntityCoords(GetPlayerPed(xTarget.source))) < 10.0 then

            if (healType == "resuscitation") then

                if (playerDead[xTarget.identifier] ~= nil) then
                    if (playerDead[xTarget.identifier].isDead) then
                        playerDead[xTarget.identifier].canRevive = true
                        deadReason = playerDead[xTarget.identifier].deadReason

                        MySQL.Sync.execute('UPDATE users SET isDead = @isDead WHERE identifier = @identifier', {
                            ['@identifier'] = xTarget.identifier,
                            ['@isDead'] = 0
                        })
                    end
                else
                    xPlayer.showNotification("La personne n'est pas morte")
                    return
                end

            elseif (healType == "small" or healType == "big") then

                if (targetHealth >= targetMaxHealth) then
                    xPlayer.showNotification("La personne n'a pas besoin de soin")
                    return
                end

            end

            for k, v in pairs(Config["AmbulanceJob"]["PharmacyShop"]) do

                if (v.utility == healType) then
                    local hasItems = xPlayer.getInventoryItem(v.item)
                    local currentItemCount = hasItems and hasItems.quantity or 0
            
                    if currentItemCount > 0 then
                        xPlayer.removeInventoryItem(v.item, 1)
                        break
                    else
                        xPlayer.showNotification(("Vous ne possédez pas de %s~s~ sur vous"):format(v.label))
                        return
                    end
                end
            
            end

            TriggerClientEvent("fowlmas:player:playAnimation", xPlayer.source, healType)

            SetTimeout(10000, function()
                xTarget.removeAccountMoney("bank", price)
                ESX.AddSocietyMoney("ambulance", price)
                xTarget.showNotification(("Vous avez payé %s ~g~$~s~ pour le soin"):format(price))
                xPlayer.showNotification(("Vous avez fait une facture de %s ~g~$~s~ pour le soin effectuer"):format(price))
                TriggerClientEvent("fowlmas:player:heal", target, healType)
                if (healType == "resuscitation" or healType == "big") then
                    xTarget.setHurt(true, Config["AmbulanceJob"]["ATA"][deadReason]*60)
                    TriggerClientEvent("fowlmas:player:receiveATA", target, Config["AmbulanceJob"]["ATA"][deadReason], true)
                end
                CoreSendLogs("Heal", "OneLife | Heal", ("%s %s (***%s***) vient d'éffectuer un soin pour **%s** $"):format(xPlayer.getLastName(), xPlayer.getFirstName(), xPlayer.identifier, price), Config["Log"]["Job"]["ambulance"]["heal_player"])
            end)

        end 

    end

end)

RegisterNetEvent("fowlmas:ambulance:check", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (playerDead[xPlayer.identifier] ~= nil) then

            if (not playerDead[xPlayer.identifier].canRevive) then
                xPlayer.ban(0, "(fowlmas:ambulance:check)")
            end

        end

    end

end)

callTimeOut = {}

RegisterNetEvent("fowlmas:ambulance:callEmergency", function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if (xPlayer and xPlayers) then
        if (not callTimeOut[xPlayer.identifier] or GetGameTimer() - callTimeOut[xPlayer.identifier] > Config["AmbulanceJob"]["RespawnTime"]*1000) then
            callTimeOut[xPlayer.identifier] = GetGameTimer()
            if (playerDead[xPlayer.identifier] ~= nil) then
                if (playerDead[xPlayer.identifier].isDead) then
                    table.insert(playerHasCall, {coords = coords, player = xPlayer.identifier})
                    for i = 1, #xPlayers, 1 do
                        local player = ESX.GetPlayerFromId(xPlayers[i]);

                        if (player) then
                            if (player.job.name == "ambulance") then
                                if exports["core"]:GetPlayerInService(player.identifier) then
                                    TriggerClientEvent("fowlmas:player:receiveCall", player.source, playerHasCall, true)
                                end
                            end
                            xPlayer.showNotification("Votre appel a été envoyé")
                        end
                    end
                else
                    xPlayer.ban(0, "(fowlmas:ambulance:callEmergency)")
                end
            end
        else
            xPlayer.showNotification("Vous devez attendre avant de pouvoir appeler à nouveau")
        end
    end
end)

RegisterNetEvent("fowlmas:ambulance:respawn", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerPosition = GetEntityCoords(GetPlayerPed(source))
    local closestDistance = -1
    local closestPosition = nil

    if (xPlayer) then

        if (playerDead[xPlayer.identifier] ~= nil) then

            if (GetGameTimer() - playerDead[xPlayer.identifier].timer > Config["AmbulanceJob"]["RespawnTime"]* 1000) then
                playerDead[xPlayer.identifier].canRevive = true

                for i, respawnPosition in ipairs(Config["AmbulanceJob"]["RespawnPosition"]) do
                    local distance = #(playerPosition - vector3(respawnPosition.x, respawnPosition.y, respawnPosition.z))

                    if closestDistance == -1 or distance < closestDistance then
                        closestDistance = distance
                        closestPosition = respawnPosition
                    end

                end

                --@todo a reactivé apres avoir refait le onRevive
                xPlayer.onRevive()
                TriggerClientEvent("fowlmas:player:heal", source, "respawn", closestPosition)
            else
                xPlayer.ban(0, "(fowlmas:ambulance:respawn)")
            end

        end

    end
end)

RegisterNetEvent("fowlmas:ambulance:removeCall", function(number)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if (xPlayer and xPlayers) then
        for i = 1, #xPlayers, 1 do
            local player = ESX.GetPlayerFromId(xPlayers[i])

            if (player and player.job.name == "ambulance") then
                table.remove(playerHasCall, number)
                TriggerClientEvent("fowlmas:player:receiveCall", player.source, playerHasCall, false)
            end

        end
    end
end)

local carSpawnTimeout = {}

RegisterNetEvent("fowlmas:ambulance:spawnVehicle", function(model, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    local correctVehicle = false

    if xPlayer then

        if (not carSpawnTimeout[xPlayer.identifier] or GetGameTimer() - carSpawnTimeout[xPlayer.identifier] > 10000) then
            carSpawnTimeout[xPlayer.identifier] = GetGameTimer()

            if xPlayer.job.name ~= "ambulance" then
                xPlayer.ban(0, "(fowlmas:ambulance:spawnVehicle)")
                return
            end

            for k, v in pairs(Config["AmbulanceJob"]["GarageVehicle"] ) do
                if model == v.vehicle and label == v.label then
                    correctVehicle = true
                    break
                end
            end

            if correctVehicle then

                if #(coords - Config["AmbulanceJob"]["Garage"]) < 10 then
                    ESX.SpawnVehicle(model,  Config["AmbulanceJob"]["GarageSpawn"], Config["AmbulanceJob"]["GarageHeading"], nil, false, xPlayer, xPlayer.identifier, function(vehicle)
                        --TaskWarpPedIntoVehicle(player, vehicle, -1)
                        SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
                    end)
                else
                    xPlayer.ban(0, "(fowlmas:ambulance:spawnVehicle)")
                end

            else
                xPlayer.ban(0, "(fowlmas:ambulance:spawnVehicle)")
            end

        else
            xPlayer.showNotification("Vous devez attendre avant de spawn une nouvelle voiture")
        end

    end
end)

RegisterNetEvent("fowlmas:ambulance:buyItem", function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 0

    if (xPlayer) then

        if (xPlayer.job.name ~= "ambulance") then
            xPlayer.ban(0, "(fowlmas:ambulance:buyItem)")
            return
        end

        for i = 1, #Config["AmbulanceJob"]["PharmacyShop"] do

            if (Config["AmbulanceJob"]["PharmacyShop"][i].item == item) then
                price = Config["AmbulanceJob"]["PharmacyShop"][i].price
                price = price * count
                break
            end

        end

        if (price > 0) then

            local society = ESX.DoesSocietyExist("ambulance")

            if (society) then

                local societyMoney = ESX.GetSocietyMoney("ambulance")

                if (societyMoney >= price) then
                    if xPlayer.canCarryItem(item, count) then
                        ESX.RemoveSocietyMoney("ambulance", tonumber(price));
                        xPlayer.addInventoryItem(item, count)
                        xPlayer.showNotification(("L'entreprise a payé %s ~g~$~s~ pour l'achat de %s"):format(price, item))
                        CoreSendLogs("PharmacyShop", "OneLife | PharmacyShop", ("%s %s (***%s***) vient d'acheter **%s** pour **%s** $"):format(xPlayer.getLastName(), xPlayer.getFirstName(), xPlayer.identifier, item, price), Config["Log"]["Job"]["ambulance"]["buy_pharmacy"])
                    else
                        xPlayer.showNotification("Vous n'avez pas assez de place dans votre inventaire")
                    end
                else
                    xPlayer.showNotification("L'entreprise ne possède pas assez d'argent")
                end

            else
                xPlayer.showNotification("error_ambulance_242: veuillez contacter un administrateur")
            end

        else
            xPlayer.ban(0, "(fowlmas:ambulance:buyItem)")
        end

    end

end)

local callTimeoutNPC = {}

RegisterNetEvent("fowlmas:ambulance:buyNPC", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config["AmbulanceJob"]["Price"]["big"]
    local Ped = GetPlayerPed(source)
	local MaxHealth = GetEntityMaxHealth(Ped)
	local Health = GetEntityHealth(Ped)
    local deadReason = "other"
    local isDead = false

    if (xPlayer) then

        if (Health >= MaxHealth) then
            xPlayer.showNotification("Vous avez pas besoin de soin")
            return
        end

        if (not callTimeoutNPC[xPlayer.identifier] or GetGameTimer() - callTimeoutNPC[xPlayer.identifier] > Config["AmbulanceJob"]["RespawnTime"]*1000) then
            callTimeoutNPC[xPlayer.identifier] = GetGameTimer()

            for k, v in pairs(Config["AmbulanceJob"]["DoctorPed"]) do
                
                local PedPos = v.pos

                if #(GetEntityCoords(GetPlayerPed(source)) - PedPos) < 10.0 then

                    if (playerDead[xPlayer.identifier]) then
    
                        if (playerDead[xPlayer.identifier].isDead) then
                            playerDead[xPlayer.identifier].canRevive = true
                            isDead = true
                            price = Config["AmbulanceJob"]["Price"]["resuscitation"]
                        end
    
                    end
    
                    if xPlayer.getAccount('bank').money >= price then
    
                        if isDead then
                            TriggerClientEvent("fowlmas:player:heal", source, "respawn", PedPos)
                            xPlayer.setHurt(true, Config["AmbulanceJob"]["ATA"][deadReason]*60)
                            TriggerClientEvent("fowlmas:player:receiveATA", xPlayer.source, Config["AmbulanceJob"]["ATA"][deadReason], true)
                        else
                            TriggerClientEvent("fowlmas:player:heal", source, "big")
                            xPlayer.setHurt(true, Config["AmbulanceJob"]["ATA"][deadReason]*60)
                            TriggerClientEvent("fowlmas:player:receiveATA", xPlayer.source, Config["AmbulanceJob"]["ATA"][deadReason], true)
                        end
    
                        xPlayer.removeAccountMoney('bank', price)
                        xPlayer.showNotification(("Vous avez payer %s ~g~$~s~ pour le soin"):format(price))
    
                    else
                        xPlayer.showNotification("Vous n'avez pas assez d'argent sur vous")
                    end
    
                end

            end

        else
            xPlayer.showNotification("Vous devez attendre avant de pouvoir appeler à nouveau")
        end

    end
end)

RegisterNetEvent("fowlmas:ambulance:removeATA", function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)

    if (xPlayer and xTarget) then
        
        if (xTarget.isHurt()) then

            xTarget.setHurt(false)
            TriggerClientEvent("fowlmas:player:receiveATA", xTarget.source, 0, false)
            if xPlayer.source ~= xTarget.source then
                xPlayer.showNotification("Le joueur a été soigné")
            end
            
        else
            if xPlayer.source ~= xTarget.source then
                xPlayer.showNotification("Le joueur n'est pas blessé")
            end
        end

    end
end)

local TimeoutJail = {}

RegisterNetEvent("fowlmas:ambulance:jailRevive", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (not TimeoutJail[xPlayer.identifier] or GetGameTimer() - TimeoutJail[xPlayer.identifier] > 60000) then
            TimeoutJail[xPlayer.identifier] = GetGameTimer()

            if #(GetEntityCoords(GetPlayerPed(source)) - vector3(-2167.4724, 5191.0288, 16.2657)) < 700.0 then

                if (playerDead[xPlayer.identifier] ~= nil) then

                    if (playerDead[xPlayer.identifier].isDead) then
                        playerDead[xPlayer.identifier].canRevive = true
                        TriggerClientEvent("fowlmas:player:heal", source, "resuscitation")
                    end

                end

            else
                xPlayer.ban(0, '(fowlmas:ambulance:jailRevive)')
            end

        else
            xPlayer.showNotification("Veuillez attendre avant d'utiliser cette fonction à nouveau")
        end

    end

end)

AddEventHandler("playerDropped", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (playerDead[xPlayer.identifier] ~= nil) then
            removeByIdentifier(playerHasCall, xPlayer.identifier)
            playerDead[xPlayer.identifier] = nil
        end

    end
end)

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then

		xPlayer.removeInventoryItem('medikit', 1)
        TriggerClientEvent("fowlmas:player:heal", source, "big")
		xPlayer.showNotification("Vous avez été soigné")

	end

end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then

		xPlayer.removeInventoryItem('bandage', 1)
        TriggerClientEvent("fowlmas:player:heal", source, "small")
        xPlayer.showNotification("Vous avez été soigné")

	end

end)

ESX.AddGroupCommand("revive", "helpeur", function(source, args)
    local playerSelected = tonumber(args[1]) or source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerSelected)
    
    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (playerDead[xTarget.identifier] ~= nil) then
            if (playerDead[xTarget.identifier].isDead == true) then
                playerDead[xTarget.identifier].canRevive = true

                xTarget.triggerEvent("fowlmas:player:heal", "resuscitation")
                CoreSendLogs("Revive", "OneLife | Revive", ("Le Staff (***%s | %s***) vient de revive le joueurs (***%s***)"):format(((xPlayer ~= nil and xPlayer.getName()) or "Console"), xPlayer.getIdentifier(), xTarget.getName()), Config["Log"]["Staff"]["Revive"])

                xTarget.setHurt(false)
                xTarget.setDead(false)
                xPlayer.showNotification(("Vous avez revive le joueur %s~s~."):format(xTarget.getName()))
            else
                xPlayer.showNotification(("Le joueur %s~s~ n'est pas mort."):format(xTarget.getName()))
            end
        else
            xPlayer.showNotification(("Le joueur %s~s~ n'est pas mort."):format(xTarget.getName()))
        end
    end
end, {help = "revive", params = {
    {name = "ID du joueur", help = "L'ID du joueur à réanimer (laisser vide pour vous réanimer vous-même)"}
}})

ESX.AddGroupCommand("heal", "helpeur", function(source, args)
    local playerSelected = tonumber(args[1]) or source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerSelected)
    
    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (playerDead[xTarget.identifier] == nil) then
            xTarget.triggerEvent("fowlmas:player:heal", "big")
            xTarget.setHurt(false)
            CoreSendLogs("Heal", "OneLife | Heal", "Le Staff (***"..((xPlayer ~= nil and xPlayer.getName()) or "Console").." | "..xPlayer.getIdentifier().."***) vient de heal le joueur (***"..xTarget.getName().."***)", Config["Log"]["Staff"]["Heal"])
            xTarget.showNotification("Vous avez été soigné")
            xPlayer.showNotification(("Vous avez soigné %s~s~."):format(playerSelectedData.getName()))
        else
            xPlayer.showNotification(("Le joueur %s~s~ est mort."):format(xTarget.getName()))
        end
    end
end, {help = "heal", params = {
    {name = "ID du joueur", help = "L'ID du joueur à soigner (laisser vide pour vous soigner vous-même)"}
}})

ESX.AddGroupCommand("revivezone", "moderateur", function(source, args)
    local players = GetPlayers()
    local count = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    args[1] = args[1] ~= nil and tonumber(args[1]) or 10

    if (xPlayer) then
        if (tonumber(args[1]) <= 500 and tonumber(args[1]) >= 0) then
            for i = 1, #players do
                local targetPlayers = ESX.GetPlayerFromId(players[i])

                if (targetPlayers) then
                    local coords = GetEntityCoords(GetPlayerPed(players[i]))
					local distance = #(coords - xPlayer.getCoords())

                    if (distance <= tonumber(args[1])) then
                        if (playerDead[targetPlayers.identifier] ~= nil) then
                            if (playerDead[targetPlayers.identifier].isDead == true) then
                                playerDead[targetPlayers.identifier].canRevive = true
                                count = count + 1
                                targetPlayers.triggerEvent("fowlmas:player:heal", "resuscitation")
                                targetPlayers.setHurt(false)
                            end
                        end
                    end
                end
            end

            if (count > 0) then
                xPlayer.showNotification(("Vous venez de revive (%s) joueur(s) dans ce rayon"):format(count))
				CoreSendLogs("ReviveZone", "OneLife | ReviveZone", "Le Staff (***"..xPlayer.getName().." | "..xPlayer.getIdentifier().."***) viens de revive (**"..count.."**) joueurs dans une zone de (**"..args[1].."**) mètres", Config["Log"]["Staff"]["ReviveZone"])
            end
        else
			xPlayer.showNotification("Veuillez saisir un nombre entre 0 et 500");
		end
    end

end, {
    help = "revivezone", 
    params = {
        {name = "radius", help = "Rayon dans lequel cette action va s'effectuer"}
    }
}) 

ESX.AddGroupCommand("slay", "moderateur", function(source, args)
    local playerSelected = tonumber(args[1]) or source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerSelected)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (playerDead[xTarget.identifier] == nil) then
            xPlayer.showNotification(("Vous avez slay le joueur %s~s~"):format(xTarget.getName()))
            CoreSendLogs("Slay", "OneLife | Slay", "Le Staff (***"..xPlayer.getName().." | "..xPlayer.getIdentifier().."***) viens de slay le joueur (***"..xTarget.getName().."***)", Config["Log"]["Staff"]["Slay"])
            xTarget.triggerEvent("fowlmas:player:heal", "slay")
            MySQL.Sync.execute('UPDATE users SET isDead = @isDead WHERE identifier = @identifier', {
                ['@identifier'] = xTarget.identifier,
                ['@isDead'] = 1 
            })
            playerDead[xTarget.identifier] = {}
            playerDead[xTarget.identifier].isDead = true
            playerDead[xTarget.identifier].canRevive = false
            playerDead[xTarget.identifier].timer = GetGameTimer()
            TriggerClientEvent("fowlmas:player:DeadMenu", xTarget.source, true)
        else
            xPlayer.showNotification(("Le joueur %s~s~ est mort."):format(xTarget.getName()))
        end
    end

end, {
    help = "slay", 
    params = {
        {name = "ID du joueur", help = "L'ID du joueur à tuer (laisser vide pour vous tuer vous-même)"}
    }
})

ESX.AddGroupCommand("addeat", "helpeur", function(source, args)
    local playerSelected = tonumber(args[1]) or source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerSelected)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (playerDead[xTarget.identifier] == nil) then
            TriggerClientEvent("fowlmas:status:add", xTarget.source, "hunger", 10000000)
            TriggerClientEvent("fowlmas:status:add", xTarget.source, "thirst", 10000000)
            CoreSendLogs("Add Eat", "OneLife | AddEat", "Le Staff (***"..xPlayer.getName().." | "..xPlayer.getIdentifier().."***) viens de restauré la faim & la soif du joueur (***"..xTarget.getName().."***)", Config["Log"]["Staff"]["AddEat"])
            xPlayer.showNotification(("Vous avez restauré la faim et la soif du joueur %s"):format(xTarget.getName()))
            xTarget.showNotification("Votre faim et votre soif ont été restaurées")
        else
            xPlayer.showNotification(("Le joueur %s~s~ est mort."):format(xTarget.getName()))
        end
    end
end, {help = "addeat", params = {
    {name = "ID du joueur", help = "L'ID du joueur à donner de la faim & soif (laisser vide pour se restaurer soi-même)"}
}})