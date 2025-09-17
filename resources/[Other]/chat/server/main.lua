local playerStaff = {}
local ESX = exports["Framework"]:getSharedObject()

RegisterServerEvent('__cfx_internal:commandFallback')
AddEventHandler('__cfx_internal:commandFallback', function(command)
	local _source = source
	local name = GetPlayerName(_source)
	TriggerEvent('chatMessage', _source, name, '/' .. command)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, {255, 255, 255}, '/' .. command)
	end

	CancelEvent()
end)

RegisterServerEvent('chat:messageEntered')
AddEventHandler('chat:messageEntered', function(author, color, message)
	local _source = source

	if not message or not author then
		return
	end

	TriggerEvent('chatMessage', _source, author, message)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, author, {255, 255, 255}, message)
	end

	print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('onServerResourceStart', function(resName)
	Citizen.Wait(500)
	local players = GetPlayers()

	for i = 1, #players, 1 do
		refreshCommands(players[i])
	end
end)

function refreshCommands(playerId)
	local registeredCommands = GetRegisteredCommands()
	local suggestions = {}

	for i = 1, #registeredCommands do
		if IsPlayerAceAllowed(playerId, ('command.%s'):format(registeredCommands[i].name)) then
			table.insert(suggestions, {
				name = '/' .. registeredCommands[i].name,
				help = ''
			})
		end
	end

	TriggerClientEvent('chat:addSuggestions', playerId, suggestions)
end

RegisterCommand('announce', function(source, args, rawCommand)
	if source == 0 then
		TriggerClientEvent('chatMessage', -1, '📢 ANNONCE SERVEUR ', {255, 0, 0}, rawCommand:sub(9))
	end
end, true)

AddEventHandler("esx:playerLoaded", function(src)
	local xPlayer = ESX.GetPlayerFromId(src)

	if (xPlayer) then
		if (xPlayer.getGroup() ~= "user") then
			playerStaff[xPlayer.source] = xPlayer.name
		end
	end
end)

AddEventHandler("admin:update:group", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then
		if (xPlayer.getGroup() ~= "user") then
			playerStaff[xPlayer.source] = xPlayer.name
		else
			if (playerStaff[xPlayer.source] ~= nil) then
				playerStaff[xPlayer.source] = nil
			end
		end
	end
end)

AddEventHandler("playerDropped", function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then
		if (xPlayer.getGroup() ~= "user") then
			if (playerStaff[xPlayer.source]) then
				playerStaff[xPlayer.source] = nil
			end
		end
	end
end)

RegisterCommand("sc", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer) then
		if (xPlayer.getGroup() ~= "user") then
			for k, v in pairs(playerStaff) do
				TriggerClientEvent('chatMessage', k, string.format("📢 [STAFF] %s", xPlayer.name), {255, 0, 0}, rawCommand:sub(4))
			end
		end
	end
end)