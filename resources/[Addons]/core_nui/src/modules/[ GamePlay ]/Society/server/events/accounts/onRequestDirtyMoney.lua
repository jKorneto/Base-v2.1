RegisterNetEvent('OneLife:Society:RequestDirtyMoney')
AddEventHandler('OneLife:Society:RequestDirtyMoney', function(societyName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            TriggerClientEvent('OneLife:Society:ReceiveDirtyMoney', xPlayer.source, society:GetDirtyMoney())
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end

end)