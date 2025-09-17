ESX.AddGroupCommand("giveweapon", "responsable", function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
    local TargetName = xPlayer.getName()

    local xAdmin = ESX.GetPlayerFromId(source)
    local GiveurName = xAdmin ~= nil and xAdmin.getName() or "Console"

    if (xPlayer) then
        local weaponName = args[2]

        if (not weaponName:lower():find("^weapon_")) then
            weaponName = "weapon_" .. weaponName
        end

        local isFounder = xPlayer.getGroup() == "fondateur"

        if (not isFounder) then
            if (ESX.GetWeapon(weaponName)) then
                for _, blacklistedWeapon in ipairs(Config["BlacklistWeapon"]["HashKey"]) do
                    if (string.lower(weaponName) == string.lower(blacklistedWeapon)) then
                        xPlayer.showNotification("Cette arme est interdite")
                        return
                    end
                end
                
                local CorrectWeapon = false
                for k, v in pairs(Config["AllowedWeapon"]["HashKey"]) do
                    if (string.lower(weaponName) == string.lower(v)) then
                        CorrectWeapon = true
                        break
                    end
                end

                if (CorrectWeapon) then
                    xPlayer.addWeapon(weaponName, 1)
                    xPlayer.showNotification(("Vous venez de recevoir (~b~%s~s~) dans votre inventaire de la part du staff (~b~%s~s~)"):format(weaponName, xAdmin.getName()))

                    if (xAdmin) then
                        xAdmin.showNotification(("Le joueur (~b~%s~s~ | ~b~%s~s~) vient de recevoir (~b~%s~s~) dans son inventaire"):format(args[1], TargetName, weaponName))
                        CoreSendLogs("Staff", "OneLife | Give", "**" .. GiveurName .. "** vient de donner **" .. weaponName .. "** à **" .. TargetName .. "**", Config["Log"]["Staff"]["GiveArmes"])
                    end
                else
                    xPlayer.showNotification(("Vous n'etes pas autorisé a give cette armes (%s)"):format(weaponName))
                end
            else
                ESX.ChatMessage(source, "Le nom de l'arme est invalide")
            end
        else
            if (ESX.GetWeapon(weaponName)) then
                xPlayer.addWeapon(weaponName, 1)
                xPlayer.showNotification(("Vous venez de recevoir (~b~%s~s~) dans votre inventaire de la part du staff (~b~%s~s~)"):format(weaponName, xAdmin.getName()))

                if (xAdmin) then
                    xAdmin.showNotification(("Le joueur (~b~%s~s~ | ~b~%s~s~) vient de recevoir (~b~%s~s~) dans son inventaire"):format(args[1], TargetName, weaponName))
                    CoreSendLogs("Staff", "OneLife | Give", "**" .. GiveurName .. "** vient de donner **" .. weaponName .. "** à **" .. TargetName .. "**", Config["Log"]["Staff"]["GiveArmes"])
                end
            else
                ESX.ChatMessage(source, "Le nom de l'arme est invalide")
            end
        end
    else
        ESX.ChatMessage(source, "Le joueur n'est pas en ligne")
    end
end, {help = "Donner l'arme", params = {
    {name = "playerId", help = "Id du joueur"},
    {name = "weaponName", help = "Nom de l'arme"},
}})
