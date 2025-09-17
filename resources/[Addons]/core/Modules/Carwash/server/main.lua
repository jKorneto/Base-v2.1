RegisterNetEvent("iZeyy:Carwash:CheckMoney", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local WithinDistance = false
        for _, Pos in ipairs(Config["Carwash"]["Pos"]) do
            if #(Coords - Pos) <= 15 then
                WithinDistance = true
                break
            end
        end

        if (WithinDistance) then
            local Price = Config["Carwash"]["Price"]
            local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Carwash", "server")
            if Bill then
                xPlayer.removeAccountMoney("cash", Price)
                xPlayer.showNotification(("Vous avez payé (%s$)"):format(Price))
                TriggerClientEvent("iZeyy:Carwash:Task", xPlayer.source)
            else
                xPlayer.showNotification("Vous avez refusé la facture")
            end
        else
            return xPlayer.ban(0, "(iZeyy:Carwash:CheckMoney)")
        end

    end
end)