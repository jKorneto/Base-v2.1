local bypassJob = Config["Road_Radar"]["BypassJob"] and Config["Road_Radar"]["BypassJob"] or {}

RegisterNetEvent('fowlmas:radar:sendbill', function(playerSpeed, speedDif, speedLimit)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = ESX.DoesSocietyExist("police")
    local price = Config["Road_Radar"]["PriceL1"]

    if xPlayer then
        local job = xPlayer.getJob().name

        if (bypassJob[job] == nil) then
            if society then
                local bank = xPlayer.getAccount('bank')

                if bank and bank.money then

                    if speedDif < 20 then
                        price = Config["Road_Radar"]["PriceL1"]
                    elseif speedDif < 30 then
                        price = Config["Road_Radar"]["PriceL2"]
                    elseif speedDif < 50 then
                        price = Config["Road_Radar"]["PriceL3"]
                    else
                        price = Config["Road_Radar"]["PriceL4"]
                    end

                    xPlayer.removeAccountMoney('bank', price)
                    ESX.AddSocietyMoney("police", price / 2)
                    ESX.AddSocietyMoney("gouv", price / 2)
                    xPlayer.showNotification("Excès de vitesse: "..Shared:ServerColorCode()..""..playerSpeed.." Km/h au lieu de "..Shared:ServerColorCode()..""..speedLimit.." Km/h.")
                    xPlayer.showNotification("Votre compte en banque à été réduit de "..price.."~g~$~s~")
                end
            end
        else
            xPlayer.showNotification("Vous n'avez pas été débité car vous faites partie d'une entreprise du gouvernement")
        end
    end
end)