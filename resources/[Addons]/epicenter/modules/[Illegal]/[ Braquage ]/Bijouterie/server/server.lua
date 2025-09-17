PlayersCrafting    = {}
local CopsConnected  = 0
local rob = false
local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'bcso' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

RegisterServerEvent('esx_vangelico_robbery:toofar')
AddEventHandler('esx_vangelico_robbery:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
            xPlayer.showNotification("Braquage de Bijouterie annulé")
			TriggerClientEvent('esx_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if (robbers[source]) then
		TriggerClientEvent('esx_vangelico_robbery:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, "Braquage annulé")
	end
end)

RegisterServerEvent('esx_vangelico_robbery:endrob')
AddEventHandler('esx_vangelico_robbery:endrob', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	-- for i=1, #xPlayers, 1 do
 	-- 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 	-- 	if xPlayer and xPlayer.job.name == 'police' or xPlayer.job.name == 'bcso' then
	-- 		TriggerClientEvent('esx:showNotification', xPlayers[i], "")
	-- 		TriggerClientEvent('esx_vangelico_robbery:killblip', xPlayers[i])
	-- 	end
	-- end
	if(robbers[source])then
		TriggerClientEvent('esx_vangelico_robbery:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, "Braquage terminé")
	end
end)

RegisterServerEvent('esx_vangelico_robbery:rob')
AddEventHandler('esx_vangelico_robbery:rob', function(robb)

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < ConfigBraco.SecBetwNextRob and store.lastrobbed ~= 0 then

            TriggerClientEvent('esx_vangelico_robbery:togliblip', source)
			TriggerClientEvent('esx:showNotification', source, "La Bijouterie a déja etait braqué revenez dans (" .. (ConfigBraco.SecBetwNextRob - (os.time() - store.lastrobbed)) .. ") secondes")
			return
		end

		if rob == false then
			rob = true
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer and xPlayer.job.name == 'police' then
					TriggerClientEvent('esx:showNotification', xPlayers[i], "Braquage en cours a la Bijouterie")
					TriggerClientEvent('esx_vangelico_robbery:setblip', xPlayers[i], Stores[robb].position)
				end
			end
			TriggerClientEvent('esx:showNotification', source, "Votre braquagé à débuté prenez les bijoux dans les vitrines et attendez la Police")
			TriggerClientEvent('esx_vangelico_robbery:currentlyrobbing', source, robb)
            CancelEvent()
			Stores[robb].lastrobbed = os.time()
		else
			TriggerClientEvent('esx:showNotification', source, "Un braquage est déjà en cours")
		end
	end
end)

RegisterServerEvent('esx_vangelico_robbery:gioielli')
AddEventHandler('esx_vangelico_robbery:gioielli', function()

	local xPlayer = ESX.GetPlayerFromId(source)
	local coords = GetEntityCoords(GetPlayerPed(source))
	RobBijoux = vector3(-622.566, -230.183, 38.057)
	ZoneSize = 300
	if rob == true then
		if #(coords - RobBijoux) < ZoneSize / 2 then
			local random = math.random(ConfigBraco.MinJewels, ConfigBraco.MaxJewels)
			
			if (xPlayer.canCarryItem('jewels', random)) then
				xPlayer.addInventoryItem('jewels', random)
                xPlayer.addXP(100)
			else
				xPlayer.showNotification("Vous n'avez pas de place sur vous")
			end
		else
			xPlayer.ban(0, '(esx_vangelico_robbery:gioielli)');
		end
	else
		xPlayer.ban(0, '(esx_vangelico_robbery:gioielli');
	end
end)

RegisterNetEvent('lester:vendita', function()

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local reward = math.floor(ConfigBraco.PriceForOneJewel * ConfigBraco.MaxJewelsSell)
	SellBijoux = vector3(-1164.7128, -2022.2787, 13.1605)
	ZoneSize2 = 30

	if #(coords - SellBijoux) < ZoneSize2 / 2 then
		if xPlayer.getInventoryItem('jewels').quantity >= ConfigBraco.MaxJewelsSell then
			xPlayer.removeInventoryItem('jewels', ConfigBraco.MaxJewelsSell)
			xPlayer.addAccountMoney('cash', reward)
            xPlayer.addXP(250)
		end
	else
		xPlayer.ban(0, '(lester:vendita');
	end
end)

ESX.RegisterServerCallback('esx_vangelico_robbery:conteggio', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(CopsConnected)
end)

RegisterNetEvent("JustGod:ClaquetteChausette", function()
	local ptitePute = source;
	local xPlayer = ESX.GetPlayerFromId(ptitePute);
	local item = xPlayer.getInventoryItem('jewels');

	if (xPlayer) then
		if (CopsConnected >= ConfigBraco.RequiredCopsSell) then
            local ped = GetPlayerPed(ptitePute);
            local coords = GetEntityCoords(ped);
            FreezeEntityPosition(ped, true);
            SetTimeout(1000, function()
                FreezeEntityPosition(ped, false);
                xPlayer.triggerEvent("JustGod:ClaquetteChausetteV2");
            end);
            if (item) then
                local reward = math.floor(ConfigBraco.PriceForOneJewel * ConfigBraco.MaxJewelsSell)
                local SellBijoux = vector3(ConfigBraco.SellPos);
                if #(coords - SellBijoux) < 15 then
                    if item.quantity >= ConfigBraco.MaxJewelsSell then
                        xPlayer.removeInventoryItem('jewels', ConfigBraco.MaxJewelsSell);
                        xPlayer.addAccountMoney('dirtycash', reward);
                        xPlayer.showNotification("Vous avez vendu "..ConfigBraco.MaxJewelsSell.." Bijoux pour "..reward.."$")
                    else
                        FreezeEntityPosition(ped, false);
                        xPlayer.showNotification("Vous n'avez pas assez de bijoux sur vous (Min: 20)");
                    end
                else
                    xPlayer.ban(0, '(JustGod:ClaquetteChausette)');
                end
            else
                xPlayer.showNotification("Vous n'avez pas bijoux sur vous");
            end
		else
			xPlayer.triggerEvent("JustGod:ClaquetteChausetteV2");
			xPlayer.showNotification("Lester n'est pas disponible pour le moment.");
		end
	end
end);