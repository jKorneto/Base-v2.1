RegisterCommand("vip", function(src)
    local xPlayer = ESX.GetPlayerFromId(src);

	if (xPlayer.GetVIP()) then
    	xPlayer.triggerEvent("iZeyy:VIPSys:openVIPMenu")
	else
		xPlayer.showNotification("Vous devez acheter le grade VIP dans la Boutique afin d'accéder à ce menu")
	end
end)

local SpawnTimeout = {}

RegisterNetEvent("iZeyy:VIP:SpwanCar", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if (xPlayer.GetVIP()) then
        local Player = GetPlayerPed(source)
        local Coords = GetEntityCoords(Player)
        local Heading = GetEntityHeading(Player)
        local Model = "Faggio"

        if (not SpawnTimeout[xPlayer.identifier] or GetGameTimer() - SpawnTimeout[xPlayer.identifier] > 600000) then
            SpawnTimeout[xPlayer.identifier] = GetGameTimer()
            exports['core_nui']:SpawnVehicle(Model, Coords, Heading, nil, false, xPlayer, xPlayer.identifier, function(vehicle) end)
        else
            xPlayer.showNotification("Vous devez attendre 10 minutes avant de pouvoir refaire appel a un Faggio")
        end
    else
        Shared.Log:Info("Tentative de Cheat (iZeyy:VIP:SpwanCar)")
    end
end)

-- VIP Items
ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer.GetVIP() then 
		xPlayer.removeInventoryItem('icetea', 1)
		TriggerClientEvent('fowlmas:status:add', source, 'thirst', 700000)
		TriggerClientEvent('esx_basicneeds:oncoffee', source)
		TriggerClientEvent('esx:showNotification', source, "Vous avez consommé de l'Ice Tea")
	else
		xPlayer.showNotification("Vous n'êtes pas VIP, vous ne pouvez pas manger ou boire ceci.")
	end 
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then
		xPlayer.removeInventoryItem('cola', 1)
		TriggerClientEvent('fowlmas:status:add', source, 'thirst', 700000)
		TriggerClientEvent('esx_basicneeds:oncoffee', source)
		TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un Cola")
	end
end)

ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then
		xPlayer.removeInventoryItem('chips', 1)
		TriggerClientEvent('fowlmas:status:add', source, 'hunger', 700000)
		TriggerClientEvent('esx_basicneeds:onsandwich', source)
		TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un paquet de Chips ")
	end
end)

ESX.RegisterUsableItem('burgerclassique', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then
		xPlayer.removeInventoryItem('burgerclassique', 1)
		TriggerClientEvent('fowlmas:status:add', source, 'hunger', 700000)
		TriggerClientEvent('esx_basicneeds:onsandwich', source)
		TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un Classique Burger")
	end
end)