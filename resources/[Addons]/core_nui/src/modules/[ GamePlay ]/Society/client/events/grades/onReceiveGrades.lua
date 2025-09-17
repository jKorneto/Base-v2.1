RegisterNetEvent('OneLife:Society:ReceiveGrades')
AddEventHandler('OneLife:Society:ReceiveGrades', function(grades)
    MOD_Society:SetGrades(grades)
end)