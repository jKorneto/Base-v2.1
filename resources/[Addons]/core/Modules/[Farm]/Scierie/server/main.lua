local InService = {}
local HaveWood = {}
local SellTimeout = {}
local DailyEarnings = {}

RegisterNetEvent("iZeyy:Sawmill:Service", function(ServiceType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        if #(PlayerPos - Config["Scierie"]["PedPos"]) > 10.0 then
            xPlayer.ban(0, "Tentative de triche (iZeyy:Sawmill:Service) Code: 0x0001")
            return
        end

        if (ServiceType == true) then
            if (InService[xPlayer.identifier] == nil) then
                InService[xPlayer.identifier] = true
                xPlayer.showNotification("Debut de votre Session de Scierie")
                TriggerClientEvent("iZeyy:Sawmill:ShowPos", xPlayer.source)
                CoreSendLogs(
                    "Activité de Farm",
                    "OneLife | Activité de Farm",
                    ("Le Joueur %s (***%s***) a prise son service de (***Scierie***)"):format(
                        xPlayer.getName(),
                        xPlayer.identifier
                    ),
                    Config["Log"]["Other"]["FarmActivity"]
                )
            else
                return xPlayer.showNotification("Vous etes déja en Service")
            end
        elseif (ServiceType == false) then
            if (InService[xPlayer.identifier] == true) then
                InService[xPlayer.identifier] = nil
                xPlayer.showNotification("Fin de votre Session de Scierie")
                TriggerClientEvent("iZeyy:Sawmill:DisiblePos", xPlayer.source)
                CoreSendLogs(
                    "Activité de Farm",
                    "OneLife | Activité de Farm",
                    ("Le Joueur %s (***%s***) a quitté son service de (***Scierie***)"):format(
                        xPlayer.getName(),
                        xPlayer.identifier
                    ),
                    Config["Log"]["Other"]["FarmActivity"]
                )
            else
                return xPlayer.showNotification("Vous etes déja hors service")
            end
        end
    end
end)

RegisterNetEvent("iZeyy:Sawmill:HandWood", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local WithinDistance = false
        for _, Pos in ipairs(Config["Scierie"]["TreesPos"]) do
            if #(Coords - Pos) <= 15 then
                WithinDistance = true
                break
            end
        end

        if (not WithinDistance) then
            return xPlayer.ban(0, "Tentative de triche (iZeyy:Sawmill:HandWood) Code: 0x0001")
        end

        if (WithinDistance) then
            if (HaveWood[xPlayer.identifier] == nil) then
                HaveWood[xPlayer.identifier] = true
                TriggerClientEvent("iZeyy:Sawmill:HandWood", xPlayer.source)
                xPlayer.addXP(20)
            end
        end
    end
end)

RegisterNetEvent("iZeyy:Sawmill:Sell", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local PlayerPed = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(PlayerPed)

        if #(PlayerPos - Config["Scierie"]["SellPedPos"]) > 10.0 then
            xPlayer.ban(0, "Tentative de triche (iZeyy:Sawmill:Sell) Code: 0x0001")
            return
        end

        if not DailyEarnings[xPlayer.identifier] then
            DailyEarnings[xPlayer.identifier] = 0
        end
        
        local dailyLimit = xPlayer.GetVIP() and Config["Scierie"]["VIPLimit"] or Config["Scierie"]["Limit"]

        if (InService[xPlayer.identifier] == true) then
            if (not SellTimeout[xPlayer.identifier] or GetGameTimer() - SellTimeout[xPlayer.identifier] > 60000) then
                if (HaveWood[xPlayer.identifier] == true) then

                    if (DailyEarnings[xPlayer.identifier]) < dailyLimit then

                        SellTimeout[xPlayer.identifier] = GetGameTimer()
                        xPlayer.addAccountMoney("cash", Config["Scierie"]["Reward"])
                        DailyEarnings[xPlayer.identifier] = DailyEarnings[xPlayer.identifier] + Config["Scierie"]["Reward"]
                        xPlayer.addXP(20)
                        xPlayer.showNotification(("Vous avez recu %s$ pour cette tache"):format(Config["Scierie"]["Reward"]))
                        TriggerClientEvent("iZeyy:Sawmill:StopAnim", xPlayer.source)
                        CoreSendLogs(
                            "Activité de Farm",
                            "OneLife | Activité de Farm",
                            ("Le Joueur %s (***%s***) a vendu du bois pour (***%s$***)"):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                Config["Scierie"]["Reward"]
                            ),
                            Config["Log"]["Other"]["FarmActivity"]
                        )
                        HaveWood[xPlayer.identifier] = nil
                    else
                        xPlayer.showNotification("Vous avez atteint la limite de vente de bois quotidienne")
                    end
                else
                    xPlayer.ban(0, "Tentative de triche (iZeyy:Sawmill:Sell) Code: 0x0002")
                end
            else
                xPlayer.showNotification("Attend que je finisse de traitez le bois que tu ma donné il y'a 1 min")
            end
        else
            xPlayer.ban(0, "Tentative de triche (iZeyy:Sawmill:Sell) Code: 0x0003")
        end
    end
end)

AddEventHandler("playerDropped", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (InService[xPlayer.identifier] == true) then
            InService[xPlayer.identifier] = nil
        end
    end
end)
