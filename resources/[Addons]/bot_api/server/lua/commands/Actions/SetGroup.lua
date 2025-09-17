function _bot_api:SetGroup(license, group, cb)
    local xPlayer = ESX.GetPlayerFromIdentifier(license)

    if xPlayer ~= nil then
        xPlayer.setGroup(group);

        cb("Le joueur " ..xPlayer.name.. " a bien été setgroup "..group.." !")
    else
        MySQL.Async.execute("UPDATE users SET permission_group = @group WHERE identifier = @identifier", {
            ["@identifier"] = license,
            ["@group"] = group
        })
        
        cb("OFFLINE: Le joueur " ..license.. " a bien été setgroup "..group.." !")
    end
end