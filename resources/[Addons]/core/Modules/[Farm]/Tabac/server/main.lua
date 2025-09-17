local RecolteTimeout = {}
local SellTimeout = {}
local DailyEarnings = {}

RegisterNetEvent("iZeyy:Tabac:Recolte", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if (xPlayer) then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        for k, v in pairs(Config["Tabac"]["RecoltePos"]) do
            local RecoltePos = v.pos
            if #(PlayerPos - RecoltePos) > 50.0 then
                xPlayer.ban(0, "Tentative de triche (iZeyy:Tabac) Code: 0x0001")
                return
            end
        end

        if (not RecolteTimeout[xPlayer.identifier] or GetGameTimer() - RecolteTimeout[xPlayer.identifier] > 1000) then
            RecolteTimeout[xPlayer.identifier] = GetGameTimer()
            if xPlayer.canCarryItem(Config["Tabac"]["Items"], 2) then
                xPlayer.addInventoryItem(Config["Tabac"]["Items"], 1)
                xPlayer.showNotification("Vous avez reçu (x1) Tabac")
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

RegisterNetEvent("iZeyy:Tabac:Sell", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        if #(PlayerPos - Config["Tabac"]["SellPos"]) > 20.0 then
            xPlayer.ban(0, "Tentative de triche (iZeyy:Tabac) Code: 0x0003")
            return
        end

        if not SellTimeout[xPlayer.identifier] or GetGameTimer() - SellTimeout[xPlayer.identifier] > 1000 then
            SellTimeout[xPlayer.identifier] = GetGameTimer()
            local HasTabac = xPlayer.getInventoryItem(Config["Tabac"]["Items"])

            if not DailyEarnings[xPlayer.identifier] then
                DailyEarnings[xPlayer.identifier] = 0
            end
            
            local dailyLimit = xPlayer.GetVIP() and Config["Tabac"]["VIPLimit"] or Config["Tabac"]["Limit"]
            
            if HasTabac and HasTabac.quantity > 0 then
                local reward = Config["Tabac"]["Reward"]

                if (DailyEarnings[xPlayer.identifier]) < dailyLimit then
                    xPlayer.removeInventoryItem(Config["Tabac"]["Items"], 1)
                    xPlayer.addAccountMoney(Config["Tabac"]["RewardType"], reward)
                    xPlayer.addXP(20)
                    DailyEarnings[xPlayer.identifier] = DailyEarnings[xPlayer.identifier] + reward
                    xPlayer.showNotification("1 Tabac de vendu pour "..reward.."$")
                    CoreSendLogs(
                        "Activité de Farm",
                        "OneLife | Activité de Farm",
                        ("Le Joueur %s (***%s***) a vendu 1 x (***%s***) pour (***%s$***)"):format(
                            xPlayer.getName(),
                            xPlayer.identifier,
                            Config["Tabac"]["Items"],
                            reward
                        ),
                        Config["Log"]["Other"]["FarmActivity"]
                    )
                else
                    xPlayer.showNotification("Vous avez atteint la limite de vente de Tabac quotidienne")
                end
            else
                xPlayer.showNotification("Vous n'avez plus de tabac à vendre.")
            end
        else
            return
        end
    end
end)
