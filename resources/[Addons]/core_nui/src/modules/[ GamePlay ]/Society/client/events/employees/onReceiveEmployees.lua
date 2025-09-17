RegisterNetEvent('OneLife:Society:ReceiveEmployees')
AddEventHandler('OneLife:Society:ReceiveEmployees', function(employees)
    MOD_Society:SetEmployees(employees)
end)