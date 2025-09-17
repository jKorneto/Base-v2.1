RegisterNetEvent('OneLife:Society:recruitEmploye')
AddEventHandler('OneLife:Society:recruitEmploye', function(societyName, employeeId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(employeeId)
    local society = MOD_Society:getSocietyByName(societyName)

    if (xPlayer and xTarget) then
        if (society and society:IsPlayerBoss(xPlayer)) then
            TriggerClient("OneLife:Society:recruitEmploye", xPlayer.source, xPlayer.job.name, xTarget.source, "recruit")
            --TriggerEvent('OneLife:Society:SetGrade', xPlayer.job.name, xTarget.source, "recruit")
        end
    end

end)