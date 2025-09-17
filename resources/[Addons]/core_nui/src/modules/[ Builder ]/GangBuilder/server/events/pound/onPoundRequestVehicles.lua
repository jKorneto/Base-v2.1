RegisterNetEvent('OneLife:GangBuilder:PoundRequestVehicles')
AddEventHandler('OneLife:GangBuilder:PoundRequestVehicles', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        local playerGang = xPlayer.job2.name

        if (playerGang ~= "unemployed2") then
            local Gang = MOD_GangBuilder:getGangByName(playerGang)

            if (Gang) then
                if (Gang:DoesPlayerExist(xPlayer)) then
                    TriggerClientEvent('OneLife:GangBuilder:PoundReceiveVehicles', xPlayer.source, Gang:GetVehiclesTemplate())
                end
            end
        end
    end
end)