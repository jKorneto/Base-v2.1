RegisterNetEvent('OneLife:GangBuilder:RequestGrades')
AddEventHandler('OneLife:GangBuilder:RequestGrades', function(gangId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Gang = MOD_GangBuilder:getGangById(gangId)

    if (Gang) then
        if (Gang:DoesPlayerExist(xPlayer)) then
            TriggerClientEvent('OneLife:GangBuilder:ReceiveGrades', xPlayer.source, Gang:GetAllGrades())
        end
    end
end)