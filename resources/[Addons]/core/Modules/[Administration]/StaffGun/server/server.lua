RegisterNetEvent("izey:requestVictimInfo", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(id)
    local playerInfo = {}

    if xPlayer and xTarget then
        playerInfo = {
            job = xTarget.getJob().label,
            grade = xTarget.getJob().grade_label,
            faction = xTarget.getJob2().label,
            grade2 = xTarget.getJob2().grade_label,
        }
        TriggerClientEvent("izey:receiveVictimInfo", xPlayer.source, playerInfo)
    end
end)