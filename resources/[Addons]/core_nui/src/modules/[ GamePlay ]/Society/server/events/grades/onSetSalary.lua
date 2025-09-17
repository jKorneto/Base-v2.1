RegisterNetEvent('OneLife:Society:SetSalary')
AddEventHandler('OneLife:Society:SetSalary', function(societyName, gradeLevel, newSalary)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            society:SetSalary(gradeLevel, tonumber(newSalary))

            society:UpdateBossEvent("OneLife:Society:ReceiveGrades", society:GetGrades())
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end
end)