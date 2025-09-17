RegisterNetEvent('OneLife:Society:RequestGrades')
AddEventHandler('OneLife:Society:RequestGrades', function(societyName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            TriggerClientEvent('OneLife:Society:ReceiveGrades', xPlayer.source, society:GetGrades())
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end
end)