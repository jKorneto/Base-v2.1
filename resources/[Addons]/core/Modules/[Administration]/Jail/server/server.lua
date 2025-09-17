local playerInJail = {}
local rateLimitCallback = {}

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM jail", {}, function(allPlayerJail)
        for k, v in pairs(allPlayerJail) do
            if (tonumber(v.tasks) > 0) then
                playerInJail[v.identifier] = {}
                playerInJail[v.identifier].task = v.tasks
                playerInJail[v.identifier].reason = v.reason
                playerInJail[v.identifier].staffname = v.staffname
            else
                MySQL.Async.execute("DELETE FROM jail WHERE identifier = @identifier", {
                    ["@identifier"] = v.identifier,
                })
            end
        end
    end)
end)

RegisterNetEvent("core:jail:sendPlayer", function(target, task, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    local targetPed = GetPlayerPed(target)

    if (xPlayer and xTarget) then
        if xPlayer.getGroup() ~= "user" then
            playerInJail[xTarget.identifier] = {}
            playerInJail[xTarget.identifier].task = task
            playerInJail[xTarget.identifier].reason = reason
            playerInJail[xTarget.identifier].staffname = xPlayer.name
            MySQL.Async.execute("INSERT INTO jail (identifier, tasks, reason, staffname) VALUES (@identifier, @tasks, @reason, @staffname)", {
                ['@identifier'] = xTarget.identifier,
                ['@tasks'] = task,
                ['@reason'] = reason,
                ['@staffname'] = xPlayer.name,
            })
            local sanctionDate = os.date("%Y-%m-%d %H:%M:%S")
            insertPlayerSanction(xTarget.identifier, 'jail', 'Jail', task, nil, reason, sanctionDate)
            SetEntityCoords(targetPed, Config["Jail"]["EnterPosition"])
            exports["Framework"]:SetPlayerRoutingBucket(xTarget.source, 1337)
            TriggerClientEvent("iZeyy:JailSys:SendPlayer", xTarget.source)
            TriggerClientEvent("core:jail:receiveSanction", target, task, reason, xPlayer.name)
            xPlayer.showNotification(("Vous avez envoyé le joueur %s en prison"):format(xTarget.name))
            xTarget.showNotification("Vous avez été envoyer en prison suite à votre mauvais comportement")
            CoreSendLogs(
                "Jail",
                "OneLife | Jail",
                ("Le Staff **%s** (***%s***) a mit le joueurs ***%s*** (***%s***) en Jail pour la raison (***%s***) taches a faire (***%s***)"):format(
                    xPlayer.getName(),
                    xPlayer.identifier,
                    xTarget.getName(),
                    xTarget.identifier,
                    reason,
                    task
                ),
                Config["Log"]["Staff"]["Jail"]
            )
        else
            xPlayer.ban(0, "(core:jail:sendPlayer)")
        end
    end
end)

RegisterNetEvent("core:jail:deco_reco", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerPed = GetPlayerPed(source)

    local task = 30
    local reason = "Deco en etant Mort"

    if (xPlayer) then
        MySQL.Async.fetchScalar("SELECT COUNT(*) FROM jail WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result > 0 then
                return
            else
                playerInJail[xPlayer.identifier] = {}
                playerInJail[xPlayer.identifier].task = task
                playerInJail[xPlayer.identifier].reason = reason
                playerInJail[xPlayer.identifier].staffname = "Serveur"
                
                MySQL.Async.execute("INSERT INTO jail (identifier, tasks, reason, staffname) VALUES (@identifier, @tasks, @reason, @staffname)", {
                    ['@identifier'] = xPlayer.identifier,
                    ['@tasks'] = task,
                    ['@reason'] = reason,
                    ['@staffname'] = "Serveur",
                })

                MySQL.Sync.execute('UPDATE users SET isDead = @isDead WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@isDead'] = 0
                })

                local sanctionDate = os.date("%Y-%m-%d %H:%M:%S")
                insertPlayerSanction(xPlayer.identifier, 'jail', 'Jail', task, nil, reason, sanctionDate)

                SetEntityCoords(PlayerPed, Config["Jail"]["EnterPosition"])
                exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 1337)
                TriggerClientEvent("iZeyy:JailSys:SendPlayer", xPlayer.source)
                TriggerClientEvent("core:jail:receiveSanction", xPlayer.source, task, reason, "Serveur")
                xPlayer.showNotification("Vous avez été envoyé en Jail pour avoir déco réco en étant mort")
                
                CoreSendLogs(
                    "Jail",
                    "OneLife | Jail",
                    ("Le Joueur **%s** (***%s***) a été mis en Jail pour la raison (***%s***) tâches à faire (***%s***)"):format(
                        xPlayer.getName(),
                        xPlayer.identifier,
                        reason,
                        task
                    ),
                    Config["Log"]["Staff"]["Jail"]
                )
            end
        end)
    end
end)

RegisterNetEvent("core:jail:removeTask", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)

    if (xPlayer) then
        if (playerInJail[xPlayer.identifier] ~= nil) then
            numberTask = playerInJail[xPlayer.identifier].task
            playerInJail[xPlayer.identifier].task = numberTask - 1
            xPlayer.showNotification(("Vous avez etait Jail pour la raison (~b~%s~s~) il vous reste (~b~%s~s~) taches "):format(playerInJail[xPlayer.identifier].reason, playerInJail[xPlayer.identifier].task))
            if (tonumber(playerInJail[xPlayer.identifier].task) <= 0) then
                playerInJail[xPlayer.identifier] = nil
                MySQL.Async.execute("DELETE FROM jail WHERE identifier = @identifier", {
                    ["@identifier"] = xPlayer.identifier,
                })
                exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 0)
                SetEntityCoords(ped, Config["Jail"]["FinishPosition"])
                TriggerClientEvent("core:jail:finish", xPlayer.source)
                xPlayer.showNotification("Vous avez etait Unjail")
            end
        end
    end
end)


ESX.RegisterServerCallback('core:jail:checkPlayer', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (not rateLimitCallback[xPlayer.identifier] or GetGameTimer() - rateLimitCallback[xPlayer.identifier] > 5000) then
            rateLimitCallback[xPlayer.identifier] = GetGameTimer()

            if playerInJail[xPlayer.identifier] == nil or tonumber(playerInJail[xPlayer.identifier].task) <= 0 then
                cb(true)
            else
                cb(false)
                xPlayer.ban(0, "(core:jail:checkPlayer)")
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (playerInJail[xPlayer.identifier] ~= nil) then
            MySQL.Async.execute("UPDATE jail SET tasks = @tasks WHERE identifier = @identifier", {
                ["@identifier"] = xPlayer.identifier,
                ["@tasks"] = playerInJail[xPlayer.identifier].task
            })
        end
    end
end)

RegisterServerEvent("core:jail:onConnecting", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (playerInJail[xPlayer.identifier] ~= nil) then
            local task = playerInJail[xPlayer.identifier].task
            local reason = playerInJail[xPlayer.identifier].reason
            local staffname = playerInJail[xPlayer.identifier].staffname
            SetEntityCoords(targetPed, Config["Jail"]["EnterPosition"])
            exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 1337)
            TriggerClientEvent("core:jail:receiveSanction", xPlayer.source, task, reason, staffname)
        end
    end
end)

ESX.AddGroupCommand("jail", "helpeur", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])

    if (xTarget) then
        if (playerInJail[xTarget.identifier] == nil) then
            xPlayer.triggerEvent("core:jail:openMenu", xTarget.source)
        else
            xPlayer.showNotification(("Le Joueurs est déja en Jail"):format(xTarget.name))
        end
    else
        xPlayer.showNotification("Aucun joueur trouvé avec cette ID")
    end

end, {help = "Jail un joueur", params = {
    {name = "Id", help = "Id du joueurs"}
}})

ESX.AddGroupCommand("unjail", "helpeur", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])
    local ped = GetPlayerPed(xTarget.source)

    if (xTarget) then
        if playerInJail[xTarget.identifier] ~= nil then
            xPlayer.showNotification(("Le joueur %s a été libéré de prison (~b~%s~s~) tâches restantes"):format(xTarget.getName(), playerInJail[xTarget.identifier].task))
            playerInJail[xTarget.identifier] = nil
            MySQL.Async.execute("DELETE FROM jail WHERE identifier = @identifier", {
                ["@identifier"] = xTarget.identifier,
            })
            exports["Framework"]:SetPlayerRoutingBucket(xTarget.source, 0)
            SetEntityCoords(ped, Config["Jail"]["FinishPosition"])
            TriggerClientEvent("core:jail:finish", xTarget.source)
            CoreSendLogs(
                "Jail",
                "OneLife | Jail",
                ("Le Staff **%s** (***%s***) a unjail le joueurs ***%s*** (***%s***)"):format(
                    xPlayer.getName(),
                    xPlayer.identifier,
                    xTarget.getName(),
                    xTarget.identifier
                ),
                Config["Log"]["Staff"]["Jail"]
            )
        else
            xPlayer.showNotification("Le joueur n'est pas en prison")
        end
    else
        xPlayer.showNotification("Aucun joueur trouvé avec cette ID")
    end

end, {help = "Unjail un joueur", params = {
    {name = "Id", help = "Id du joueurs"}
}})

---@param identifier string
---@return boolean
exports("isPlayerInJail", function(identifier)
    return playerInJail[identifier] ~= nil
end)