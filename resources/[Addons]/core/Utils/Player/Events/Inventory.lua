Shared.Events:OnNet(Enums.ESX.Player.Inventory.Client.addItem(), function(item)
    Client.Player:AddInventoryItem(item, item.count);
end);

Shared.Events:OnNet(Enums.ESX.Player.Inventory.Client.removeItem(), function(item)
    Client.Player:RemoveInventoryItem(item);
end);

Shared.Events:OnNet(Enums.ESX.Player.Inventory.Client.updateItemCount(), function(itemName, count)
    while Client.Player == nil do
        Wait(0);
    end
    
    Client.Player:UpdateItemAmount(itemName, count);
end);

Shared.Events:OnNet(Enums.ESX.Player.Inventory.Client.setAccountMoney(), function(account)
    while Client.Player == nil do
        Wait(0);
    end

    Client.Player:SetAccount(account);
end);