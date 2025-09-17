RegisterNUICallback("refuseBill", function()
	if (Client.Bill:isInBillPrompt()) then
		Client.Bill:refuseBill()
	end
end)

RegisterNUICallback("payCashBill", function()
	if (Client.Bill:isInBillPrompt()) then
		Client.Bill:acceptBill("cash")
	end
end)

RegisterNUICallback("payBankBill", function()
	if (Client.Bill:isInBillPrompt()) then
		Client.Bill:acceptBill("bank")
	end
end)

Shared.Events:OnNet(Engine["Enums"].Bill.Events.receiveBill, function(state)
	if (type(state) == "boolean") then
		Client.Bill:setInBillPrompt(state)
	end
end)

Shared.Events:OnNet(Engine["Enums"].Bill.Events.openBill, function(price, playerMoney, playerBank)
	exports["engine_nui"]:SendNUIMessage({
		type = "showBillPrompt",
		showBillPrompt = true,
		billPrice = price,
		playerCash = playerMoney,
		playerBank = playerBank
	}, "/bill", true)
end)

Shared.Events:OnNet(Engine["Enums"].Bill.Events.closeBill, function()
	exports["engine_nui"]:SendNUIMessage({
		type = "hideBillPrompt",
	}, "/bill", false)

	Client.Bill:setInBillPrompt(false)
end)
