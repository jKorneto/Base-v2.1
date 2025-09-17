RegisterNetEvent('OneLife:GangBuilder:ReceiveGrades')
AddEventHandler('OneLife:GangBuilder:ReceiveGrades', function(grades)
    MOD_GangBuilder:SetGrades(grades)
end)