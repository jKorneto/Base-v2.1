RegisterNetEvent('OneLife:Society:ReceiveMoney')
AddEventHandler('OneLife:Society:ReceiveMoney', function(number)
    MOD_Society:SetMoney(number)
end)