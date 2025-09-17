Shared.Events:OnNet(Engine["Enums"].Bill.Events.refuseBill, function(xPlayer)
    if (type(xPlayer) == "table") then
        Engine.Bill:refuseBill(xPlayer.identifier)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Bill.Events.acceptBill, function(xPlayer, paymentType)
    if (type(xPlayer) == "table" and type(paymentType) == "string") then
        Engine.Bill:acceptBill(xPlayer.identifier, paymentType)
    end
end)

exports("CreateBill", function(source, target, price, reason, billType, societyName)
    return Engine.Bill:sendBill(source, target, price, reason, billType, societyName)
end)