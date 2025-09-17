RegisterNetEvent('OneLife:GangBuilder:UpdateGang')
AddEventHandler('OneLife:GangBuilder:UpdateGang', function(type, data)
    MOD_GangBuilder.data[type] = data
end)