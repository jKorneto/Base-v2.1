RegisterNetEvent("iZeyy:Admin:ResetReport")
AddEventHandler("iZeyy:Admin:ResetReport", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer.getGroup() == "gerantstaff" or xPlayer.getGroup() == "fondateur") then
        local staff = MySQL.query.await("SELECT * FROM staff")
        if staff and #staff > 0 then
            for _, v in ipairs(staff) do
                local license = v.license
                local reportCount = tonumber(v.report) or 0
                local coinsToAdd = math.floor(reportCount / 3)
    
                if coinsToAdd > 0 then
                    MySQL.update.await("UPDATE users SET coins = coins + ? WHERE identifier = ?", {coinsToAdd, license})
                    MySQL.update.await("UPDATE staff SET report = 0 WHERE license = ?", {license})
                end
            end
            Shared.Log:Success("Les reports ont été réinitialisés pour tous les membres du staff et les coins ont été ajoutés.")
            xPlayer.showNotification("Les reports ont été réinitialisés pour tous les membres du staff et les coins ont été ajoutés.")
        end
    else
        xPlayer.showNotification("Vous n'avez pas les permissions nécessaires pour utiliser cette commande.")
    end
end)
