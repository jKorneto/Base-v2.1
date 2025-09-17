local RecolteTimeout = {}
local SellTimeout = {}
local DailyEarnings = {}

RegisterNetEvent("iZeyy:Tomates:Recolte", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if (xPlayer) then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        for k, v in pairs(Config["Tomates"]["RecoltePos"]) do
            local RecoltePos = v.pos
            if #(PlayerPos - RecoltePos) > 50.0 then
                xPlayer.ban(0, "Tentative de triche (iZeyy:Tomates) Code: 0x0001")
                return
            end
        end

        if (not RecolteTimeout[xPlayer.identifier] or GetGameTimer() - RecolteTimeout[xPlayer.identifier] > 1000) then
            RecolteTimeout[xPlayer.identifier] = GetGameTimer()
            if xPlayer.canCarryItem(Config["Tomates"]["Items"], 2) then
                xPlayer.addInventoryItem(Config["Tomates"]["Items"], 1)
                RecolteTimeout[xPlayer.identifier] = GetGameTimer()
                xPlayer.addXP(20)
            else
                xPlayer.showNotification("Vous n'avez plus de place sur vous.")
            end
        else
            return
        end
    end
end)

RegisterNetEvent("iZeyy:Tomates:Sell", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        if #(PlayerPos - Config["Tomates"]["SellPos"]) > 20.0 then
            xPlayer.ban(0, "Tentative de triche (iZeyy:Tomates) Code: 0x0003")
            return
        end

        if not SellTimeout[xPlayer.identifier] or GetGameTimer() - SellTimeout[xPlayer.identifier] > 1000 then
            SellTimeout[xPlayer.identifier] = GetGameTimer()
            local HasTomate = xPlayer.getInventoryItem(Config["Tomates"]["Items"])

            if not DailyEarnings[xPlayer.identifier] then
                DailyEarnings[xPlayer.identifier] = 0
            end
            
            local dailyLimit = xPlayer.GetVIP() and Config["Tomates"]["VIPLimit"] or Config["Tomates"]["Limit"]
            
            if HasTomate and HasTomate.quantity > 0 then
                local reward = Config["Tomates"]["Reward"]

                if (DailyEarnings[xPlayer.identifier]) < dailyLimit then
                    xPlayer.removeInventoryItem(Config["Tomates"]["Items"], 1)
                    xPlayer.addAccountMoney(Config["Tomates"]["RewardType"], reward)
                    xPlayer.addXP(20)
                    DailyEarnings[xPlayer.identifier] = DailyEarnings[xPlayer.identifier] + reward
                    xPlayer.showNotification("1 Tomate de vendu pour ".. Config["Tomates"]["RewardType"])
                    CoreSendLogs(
                        "Activité de Farm",
                        "OneLife | Activité de Farm",
                        ("Le Joueur %s (***%s***) a vendu du 1 x (***%s***) pour (***%s$***)"):format(
                            xPlayer.getName(),
                            xPlayer.identifier,
                            Config["Tomates"]["Items"],
                            reward
                        ),
                        Config["Log"]["Other"]["FarmActivity"]
                    )
                else
                    xPlayer.showNotification("Vous avez atteint la limite de vente de Tomates quotidienne")
                end
            else
                xPlayer.showNotification("Vous n'avez plus de tomates à vendre.")
            end
        else
            return
        end
    end
end)

