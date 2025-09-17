RegisterNetEvent('OneLife:GangBuilder:AddNewGrade')
AddEventHandler('OneLife:GangBuilder:AddNewGrade', function(gradeName, gangId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Gang = MOD_GangBuilder:getGangById(gangId)

    if (Gang) then
        if (Gang:DoesPlayerExist(xPlayer)) then

            if (not Gang:GetPlayerGradeByLicense(xPlayer.identifier, "BossAddGrade")) then return end

            Gang:AddGrade(gradeName)

        end
    end
end)