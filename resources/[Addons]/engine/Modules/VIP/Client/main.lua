Shared.Events:OnNet(Engine["Enums"].Vip.Events.ReceiveData, function(data)
    if (type(data) == "table") then
        while (not Client.Vip) do
            Wait(100)
        end

        Client.Vip:setVipData(data)
    end
end)

exports("isPlayerVip", function()
    return Client.Vip:isPlayerVip()
end)

exports("getVipExpiration", function()
    return Client.Vip:getExpiration()
end)

exports("getVipBuyDate", function()
    return Client.Vip:getBuyDate()
end)
