
RegisterNetEvent("iZeyy:Washmoney:CheckMoney", function(Amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        for k, v in pairs(Config["MoneyWash"]["Job"]) do
            if (xPlayer.job.name == v) then
                xPlayer.ban(0, "Tentative de triche detectée (BlanchimentPoliceJob)")
                return
            end
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerCoords = GetEntityCoords(Player)
        local WashMoneyPos = Config["MoneyWash"]["Pos"]

        local Distance = #(PlayerCoords - WashMoneyPos)
        if (Distance < 15) then
            local PlayerMoney = xPlayer.getAccount("dirtycash").money

            if (PlayerMoney >= Amount) then
                if (Amount < Config["MoneyWash"]["Min"]) then
                    xPlayer.showNotification("Vous n'avez pas assez d'argent pour blanchir minimum 250.000$")
                    return
                end

                local MoneyAfterTax = Amount * 0.80
                xPlayer.removeAccountMoney("dirtycash", Amount)
                xPlayer.addAccountMoney("cash", MoneyAfterTax)
                xPlayer.showNotification(("Blanchiment effectué, vous avez recu %s"):format(MoneyAfterTax))
                CoreSendLogs("WashMoney", "OneLife | WashMoney", 
                ("%s (***%s***) vient de blanchir **%s$** et a recu **%s$**"):format(xPlayer.getName(), xPlayer.identifier, Amount, MoneyAfterTax), 
                Config["Log"]["Other"]["WashMoney"])
            else
                xPlayer.showNotification("Vous n'avez pas assez d'argent sale.")
            end
        end
    end
end)