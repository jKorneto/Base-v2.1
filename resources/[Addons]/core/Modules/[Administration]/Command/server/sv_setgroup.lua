local function DeleteStaff(xTarget)
    local query = [[
        DELETE FROM staff WHERE license = ?
    ]]

    MySQL.Async.execute(query, { xTarget }, function(affectedRows) end)
end

ESX.AddGroupCommand("setgroup", "gerantstaff", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
    local group = args[2]

    if (not args[1]) then

        if (source ~= 0) then
            xPlayer.showNotification("Utilisation: /setgroup <id> <group>")
        else
            Shared.Log:Info("Utilisation: /setgroup <id> <group>")
        end

    end

    if (not args[2]) then

        if (source ~= 0) then
            xPlayer.showNotification("Utilisation: /setgroup <id> <group>")
        else
            Shared.Log:Info("Utilisation: /setgroup <id> <group>")
        end

    end

    if (type(xTarget) == "table") then

        if (ESX.DoesGroupExist(group)) then

            if (xTarget.getGroup() ~= group) then
                if (type(xPlayer) == "table" and type(xTarget) == "table") then
                 
                    if (xPlayer.source == 0 or xPlayer.getGroup() ~= "user") then
                        TriggerEvent("sAdmin:updateStaff", xTarget.source, xTarget.getGroup(), group)
                        xTarget.setGroup(group)

                        if (source ~= 0) then
                            local Content1 = "Le Staff " .. xPlayer.getName() .. " ***(" .. xPlayer.getIdentifier() .. ")*** a mis a jour le group du joueur " .. xTarget.getName() .. " ***(" .. xTarget.getIdentifier() .. ")*** en (***" .. group .. "***)"
                            xPlayer.showNotification("Le joueur " .. xTarget.identifier .. " a recu le groupe " .. group)
                            CoreSendLogs("SetGroup", "OneLife | SetGroup", Content1, "https://discord.com/api/webhooks/1310482911434375198/BnWxOLVZu___TQPBnUEfbCwsb3Q2NLd3hHKztAeKkF-hCes3CQXQV-QZHg9uoG55GCic")
                        else
                            local Content2 = "La console a mis a jour le group du joueur " .. xTarget.getName() .. " ***(" .. xTarget.getIdentifier() .. ")*** en (***" .. group .. "***)"
                            Shared.Log:Info("Le joueur " .. xTarget.identifier .. " a recu le groupe " .. group)
                            CoreSendLogs("SetGroup", "OneLife | SetGroup", Content2, "https://discord.com/api/webhooks/1310482911434375198/BnWxOLVZu___TQPBnUEfbCwsb3Q2NLd3hHKztAeKkF-hCes3CQXQV-QZHg9uoG55GCic")
                        end

                        if (group == "user") then
                            DeleteStaff(xTarget.getIdentifier())
                        end
                    end
                end
            else
                if (source ~= 0) then
                    xPlayer.showNotification("Le joueur " .. xTarget.identifier .. " possède déjà le groupe " .. group)
                else
                    Shared.Log:Info("Le joueur " .. xTarget.identifier .. " possède déjà le groupe " .. group)
                end
            end

        else
            if (source ~= 0) then
                xPlayer.showNotification("Le groupe " .. group .. " n'existe pas")
            else
                Shared.Log:Info("Le groupe " .. group .. " n'existe pas")
            end
        end

    end

end, {help = "Changer les permissions d'un joueur", params = {
    {name = "Id", help = "ID du joueur"},
    {name = "Group", help = "Groupe à donner"}
}})


ESX.AddGroupCommand("setgroupoff", "gerantstaff", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = args[1]
    local group = args[2]

    if (not xTarget) then
        xPlayer.showNotification("Utilisation: /setgroupoff <license> <group>")
        return
    end

    if (not group) then
        xPlayer.showNotification("Utilisation: /setgroupoff <license> <group>")
        return
    end

    if (ESX.DoesGroupExist(group)) then

        if (xPlayer.source == 0 or xPlayer.getGroup() ~= "user") then

            MySQL.Async.execute('UPDATE users SET `permission_group` = @permission_group WHERE `identifier` = @identifier', {
                ['@permission_group'] = group,
                ['@identifier'] = xTarget            
            }, function(rowsChanged)
                if (rowsChanged > 0) then
                    if (source ~= 0) then
                        xPlayer.showNotification("Le groupe de l'utilisateur a été mis à jour avec succès.")
                    else
                        Shared.Log:Info("Le groupe de l'utilisateur a été mis à jour avec succès.")
                    end
                else
                    if (source ~= 0) then
                        xPlayer.showNotification("Aucun utilisateur trouvé avec cette licence.")
                    else
                        Shared.Log:Info("Aucun utilisateur trouvé avec cette licence.")
                    end
                end
            end)

            if (source ~= 0) then
                local Content1 = "Le Staff " .. xPlayer.getName() .. " ***(" .. xPlayer.getIdentifier() .. "***) a mis a jour le groupe de l'utilisateur (***" .. xTarget .. "***) en group (***" .. group .. "***)"
                CoreSendLogs("SetGroup Offline", "OneLife | SetGroup", Content1, "https://discord.com/api/webhooks/1310482911434375198/BnWxOLVZu___TQPBnUEfbCwsb3Q2NLd3hHKztAeKkF-hCes3CQXQV-QZHg9uoG55GCic")
            else
                local Content2 = "La console a mis a jour le groupe de l'utilisateur (***" .. xTarget .. "***) en group (***" .. group .. "***)"
                CoreSendLogs("SetGroup Offline", "OneLife | SetGroup", Content2, "https://discord.com/api/webhooks/1310482911434375198/BnWxOLVZu___TQPBnUEfbCwsb3Q2NLd3hHKztAeKkF-hCes3CQXQV-QZHg9uoG55GCic")
            end

            if (group == "user") then
                DeleteStaff(xTarget)
            end

        else
            xPlayer.showNotification("Vous n'avez pas les permissions pour utiliser cette commande.")
        end
    else
        xPlayer.showNotification("Le groupe spécifié n'existe pas.")
    end
end, {help = "Changer les permissions d'un joueur pas connecté", params = {
    {name = "License", help = "License du joueurs"},
    {name = "Group", help = "Groupe à donner"}
}})
