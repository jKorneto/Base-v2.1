RegisterNetEvent('OneLife:Society:ReceiveDirtyMoney')
AddEventHandler('OneLife:Society:ReceiveDirtyMoney', function(number)
    MOD_Society:SetDirtyMoney(number)
end)