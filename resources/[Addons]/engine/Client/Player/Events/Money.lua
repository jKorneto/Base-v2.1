RegisterNetEvent(Engine["Enums"].ESX.Player.Inventory.Client.setAccountMoney(), function(account)
    Client.Player:SetAccount(account)
end)