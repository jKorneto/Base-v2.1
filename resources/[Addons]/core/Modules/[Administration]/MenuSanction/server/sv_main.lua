ESX.AddGroupCommand("ss", "helpeur", function(source, args)
    local playerSelected = tonumber(args[1])
    
    if (not playerSelected) then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.showNotification("Veuillez fournir un ID de joueur valide.")
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerSelected)
    
    if (not xTarget) then
        xPlayer.showNotification("Le joueur avec cet ID n'est pas connecté.")
        return
    end

    if type(xPlayer) == "table" and type(xTarget) == "table" then
        MySQL.Async.fetchAll('SELECT * FROM playersanctions WHERE player_license = @license', {
            ['@license'] = xTarget.identifier
        }, function(results)
            local sanctions = {}
            if #results > 0 then
                for _, sanction in ipairs(results) do
                    table.insert(sanctions, {
                        type = sanction.sanction_type,
                        name = sanction.sanction_name,
                        reason = sanction.reason,
                        sanction_date = sanction.sanction_date,
                        tasks = sanction.jail_tasks,
                        ban = sanction.ban_duration,
                    })
                end
            end
            Shared.Events:ToClient(xPlayer.source, "core:admin:openMenu", xTarget.getName(), sanctions)
        end)
    end

end, {help = "ss", params = {
    {name = "ID du joueur", help = "L'ID du joueur à sanctionner"}
}})

function insertPlayerSanction(playerLicense, sanctionType, sanctionName, jailTasks, banDuration, reason, sanctionDate)
    MySQL.Async.execute("INSERT INTO playersanctions (player_license, sanction_type, sanction_name, jail_tasks, ban_duration, reason, sanction_date) VALUES (@player_license, @sanction_type, @sanction_name, @jail_tasks, @ban_duration, @reason, @sanction_date)", {
        ['@player_license'] = playerLicense,
        ['@sanction_type'] = sanctionType,
        ['@sanction_name'] = sanctionName,
        ['@jail_tasks'] = jailTasks,
        ['@ban_duration'] = banDuration,
        ['@reason'] = reason,
        ['@sanction_date'] = sanctionDate,
    })
end

exports('insertPlayerSanction', insertPlayerSanction)