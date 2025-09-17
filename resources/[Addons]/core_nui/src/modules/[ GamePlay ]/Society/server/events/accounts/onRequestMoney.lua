RegisterNetEvent('OneLife:Society:RequestMoney')
AddEventHandler('OneLife:Society:RequestMoney', function(societyName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            TriggerClientEvent('OneLife:Society:ReceiveMoney', xPlayer.source, society:GetMoney())
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end

end)