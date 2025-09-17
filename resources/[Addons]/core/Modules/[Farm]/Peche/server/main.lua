local RecolteTimeout = {}
local SellTimeout = {}
local DailyEarnings = {}

RegisterNetEvent("iZeyy:Fishing:Recolte", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if (xPlayer) then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        if #(PlayerPos - Config["Fishing"]["RecoltePos"]) > 50.0 then
            xPlayer.ban(0, "Tentative de triche (iZeyy:Fishing) Code: 0x0001")
            return
        end

        if (not RecolteTimeout[xPlayer.identifier] or GetGameTimer() - RecolteTimeout[xPlayer.identifier] > 7000) then
            RecolteTimeout[xPlayer.identifier] = GetGameTimer()
            if xPlayer.canCarryItem(Config["Fishing"]["Items"], 2) then
                xPlayer.addInventoryItem(Config["Fishing"]["Items"], 1)
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

RegisterNetEvent("iZeyy:Fishing:Sell", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        if #(PlayerPos - Config["Fishing"]["SellPos"]) > 20.0 then
            xPlayer.ban(0, "Tentative de triche (iZeyy:Fishing) Code: 0x0003")
            return
        end

        if not SellTimeout[xPlayer.identifier] or GetGameTimer() - SellTimeout[xPlayer.identifier] > 1000 then
            SellTimeout[xPlayer.identifier] = GetGameTimer()
            local HasFish = xPlayer.getInventoryItem(Config["Fishing"]["Items"])

            if not DailyEarnings[xPlayer.identifier] then
                DailyEarnings[xPlayer.identifier] = 0
            end
            
            local dailyLimit = xPlayer.GetVIP() and Config["Fishing"]["VIPLimit"] or Config["Fishing"]["Limit"]
            
            if HasFish and HasFish.quantity > 0 then
                local reward = Config["Fishing"]["Reward"]

                if (DailyEarnings[xPlayer.identifier]) < dailyLimit then
                    xPlayer.removeInventoryItem(Config["Fishing"]["Items"], 1)
                    xPlayer.addAccountMoney(Config["Fishing"]["RewardType"], reward)
                    xPlayer.addXP(20)
                    DailyEarnings[xPlayer.identifier] = DailyEarnings[xPlayer.identifier] + reward
                    xPlayer.showNotification("1 poisson de vendu")
                    CoreSendLogs(
                        "Activité de Farm",
                        "OneLife | Activité de Farm",
                        ("Le Joueur %s (***%s***) a vendu (***1 x %s***) pour (***%s$***)"):format(
                            xPlayer.getName(),
                            xPlayer.identifier,
                            Config["Fishing"]["Items"],
                            reward
                        ),
                        Config["Log"]["Other"]["FarmActivity"]
                    )
                else
                    xPlayer.showNotification("Vous avez atteint la limite de vente de poisson quotidienne")
                end
            else
                xPlayer.showNotification("Vous n'avez plus de poisson à vendre.")
            end
        else
            return
        end
    end
end)
