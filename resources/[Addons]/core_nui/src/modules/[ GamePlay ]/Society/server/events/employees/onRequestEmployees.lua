RegisterNetEvent('OneLife:Society:RequestEmployees')
AddEventHandler('OneLife:Society:RequestEmployees', function(societyName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            TriggerClientEvent('OneLife:Society:ReceiveEmployees', xPlayer.source, society:GetEmployees())
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end
end)