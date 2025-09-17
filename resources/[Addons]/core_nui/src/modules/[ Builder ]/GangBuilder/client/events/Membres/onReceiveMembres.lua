RegisterNetEvent('OneLife:GangBuilder:ReceiveMembres')
AddEventHandler('OneLife:GangBuilder:ReceiveMembres', function(membres)
    MOD_GangBuilder:SetMembres(membres)
end)