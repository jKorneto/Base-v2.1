AddEventHandler('chatMessage', function(_, _, message)
	if (message):find(Config.CommandPrefix) ~= 1 then
		return
	end
	CancelEvent();
end);

---@param commandName string
---@param source number
---@param commandArgs table
local function HandleCommand(commandName)
	local command = ESX.Commands[string.lower(commandName)];
	local msg = "^7[^1Command^7]^0 Commande executée ^7(^0id: ^1%s^0, command: ^1%s^0, args: ^1%s^7)^0";

	if (command) then
		RegisterCommand(commandName, function(source, commandArgs)
			local xPlayer = source ~= 0 and ESX.GetPlayerFromId(source) or false;

			if command.group ~= nil then
				if (xPlayer and ESX.Groups[xPlayer.getGroup()].level >= ESX.Groups[command.group].level or (not xPlayer and source == 0)) then
					if (command.arguments > -1) and (command.arguments ~= #commandArgs) then

						TriggerEvent("esx:incorrectAmountOfArguments", source, command.arguments, #commandArgs)

					else

						local success, exec = pcall(command.callback, source ~= nil and source or 0, #commandArgs > 0 and commandArgs or {}, xPlayer ~= nil and xPlayer or false);
						
						if (success) then

							if (source ~= 0) then

								print((#commandArgs > 0 and msg or "^7[^1Command^7]^0 Commande executée ^7(^0id: ^1%s^0, command: ^1%s^7)^0"):format(source, commandName, table.concat(commandArgs, " ")));
								-- print((#commandArgs > 0 and msg or "^7[^1Command^7]^0 Commande executée ^7(^0id: ^1%s^0, command: ^1%s^7)^0"):format(source, commandName, table.concat(commandArgs, " ")));

							end

						else

							print(string.format("Une erreur est survenue pendant l'exécution de la commande: ^4%s^0, Détails de l'erreur: ^1%s^0", commandName, exec ~= nil and exec or "Aucune information^0."));
							-- print(string.format("^8Une erreur est survenue pendant l'exécution de la commande: ^4%s^0, Détails de l'erreur: ^1%s^0", commandName, exec ~= nil and exec or "Aucune information^0."));

						end

					end
				else
					if (xPlayer) then
						xPlayer.showNotification("~r~Vous n'etes pas autorisé a faire cette comande")
					end
				end
			else
				if (command.arguments > -1) and (command.arguments ~= #commandArgs) then
					if (xPlayer) then
						TriggerEvent("esx:incorrectAmountOfArguments", source, command.arguments, #commandArgs)
					else
						print("^7[^1Command^7]^0 Incorrect amount of arguments for command " .. commandName .. " (expected " .. command.arguments .. ", got " .. #commandArgs .. ")")
						-- print("^7[^1Command^7]^0 ^8Incorrect amount of arguments for command " .. commandName .. " (expected " .. command.arguments .. ", got " .. #commandArgs .. ")")
					end
				else
					command.callback(source ~= nil and source or 0, #commandArgs > 0 and commandArgs or {}, xPlayer ~= nil and xPlayer or false);
				end
			end
		end);
	end
end

function ESX.AddCommand(command, callback, suggestion, arguments)
	ESX.Commands[string.lower(command)] = {};
	ESX.Commands[string.lower(command)].group = nil;
	ESX.Commands[string.lower(command)].callback = callback;
	ESX.Commands[string.lower(command)].arguments = arguments or -1;

	if type(suggestion) == 'table' then
		if type(suggestion.params) ~= 'table' then
			suggestion.params = {}
		end

		if type(suggestion.help) ~= 'string' then
			suggestion.help = ''
		end

		table.insert(ESX.CommandsSuggestions, {name = ('%s%s'):format(Config.CommandPrefix, command), help = suggestion.help, params = suggestion.params})
	end
end

function ESX.AddGroupCommand(command, group, callback, suggestion, arguments)
	ESX.Commands[string.lower(command)] = {}
	ESX.Commands[string.lower(command)].group = group
	ESX.Commands[string.lower(command)].callback = callback
	ESX.Commands[string.lower(command)].arguments = arguments or -1

	if type(suggestion) == 'table' then
		if type(suggestion.params) ~= 'table' then
			suggestion.params = {}
		end

		if type(suggestion.help) ~= 'string' then
			suggestion.help = ''
		end

		table.insert(ESX.CommandsSuggestions, {name = ('%s%s'):format(Config.CommandPrefix, string.lower(command)), help = suggestion.help, params = suggestion.params})
		HandleCommand(string.lower(command));
	end
end

-- SCRIPT --
ESX.AddGroupCommand('pos', 'admin', function(source, args, user)
	local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
	
	if x and y and z then
		TriggerClientEvent('esx:teleport', source, vector3(x, y, z))
	else
		ESX.ChatMessage(source, "Invalid coordinates!")
	end
end, {help = "Teleport to coordinates", params = {
	{name = "x", help = "X coords"},
	{name = "y", help = "Y coords"},
	{name = "z", help = "Z coords"}
}})

ESX.AddGroupCommand('setjob', 'admin', function(source, args, user)
	local source = source

	if (#args == 3) then
		if tonumber(args[1]) and args[2] and tonumber(args[3]) then
			local xPlayer = ESX.GetPlayerFromId(source)
			local tPlayer = ESX.GetPlayerFromId(args[1])

			if tPlayer then
				local KargetName = GetPlayerName(args[1])
				local SetjobeurName = source ~= 0 and GetPlayerName(source) or "Console"
				if ESX.DoesJobExist(args[2], args[3]) then
					tPlayer.setJob(args[2], args[3])
					xPlayer.showNotification("Vous avez setjob : "..KargetName.." "..args[2].." - "..args[3])
					--SendLogsCommande("Setjob", "OneLife | Setjob"," **"..SetjobeurName.."** vient de setjob **"..KargetName.."** en **"..args[2].."** "..args[3].." ", "https://discord.com/api/webhooks/1093165514714529843/1DOJeOOSSe_JovHzp6QijeBUHK7eWyGXD5_42RZgF6IXl74Sz8vLP1YxB_wsG6FbEz9R")
                    CoreSendLogs(
                        "Setjob Légal",
                        "OneLife | Setjob Légal",
                        ("le Staff (***%s | %s***) vient de setjob le joueurs (***%s***) en (***%s***) (***%s***)"):format(
                            xPlayer.getName(),
                            xPlayer.getIdentifier(),
                            tPlayer.getName(),
                            args[2],
                            args[3]
                        ),
                        "https://discord.com/api/webhooks/1310450161914220605/mtIwBjFi1wAdch1DLf-95PirF7ECiO6LTU39en-IK2odxOomF4Bubyv4iErMbsEp4JMR"
                    )
                else
					ESX.ChatMessage(source, 'That job does not exist.')
				end
			else
				if (tPlayer) then
					ESX.ChatMessage(source, "Le joueur n'est pas en ligne.")
				else
					--print("^1Le joueur n'est pas en ligne.^0")
				end
			end
		else
			if (source ~= 0) then
				ESX.ChatMessage(source, "Invalid arguments.")
			else
				--print("^1Invalid arguments.^0")
			end
		end
	else
		if (source ~= 0) then
			ESX.ChatMessage(source, "Invalid arguments.")
		else
			--print("^1Invalid arguments.^0")
		end
	end
end, {help = _U('setjob'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "job", help = _U('setjob_param2')},
	{name = "grade_id", help = _U('setjob_param3')}
}})

ESX.AddGroupCommand('setjob2', 'admin', function(source, args, user)
	if (#args == 3) then
		if tonumber(args[1]) and args[2] and tonumber(args[3]) then
			local xPlayer = ESX.GetPlayerFromId(args[1])

			if xPlayer then
				local KargetName2 = GetPlayerName(args[1])
				local SetjobeurNam2 = source ~= 0 and GetPlayerName(source) or "Console"
				if ESX.DoesJobExist(args[2], args[3]) then
					xPlayer.setJob2(args[2], args[3])
                    xPlayer.showNotification("Vous avez setjob2 : "..KargetName2.." "..args[2].." - "..args[3])
                    CoreSendLogs(
                        "Setjob Illégal",
                        "OneLife | Setjob Illégal",
                        ("le Staff (***%s | %s***) vient de setjob2 le joueurs (***%s***) en (***%s***) (***%s***)"):format(
                            xPlayer.getName(),
                            xPlayer.getIdentifier(),
                            KargetName2,
                            args[2],
                            args[3]
                        ),
                        "https://discord.com/api/webhooks/1310450161914220605/mtIwBjFi1wAdch1DLf-95PirF7ECiO6LTU39en-IK2odxOomF4Bubyv4iErMbsEp4JMR"
                    )
				else
					ESX.ChatMessage(source, 'That job does not exist.')
				end
			else
				if (xPlayer) then
					ESX.ChatMessage(source, "Le joueur n'est pas en ligne.")
				else
					--print("^1Le joueur n'est pas en ligne.^0")
				end
			end
		else
			if (source ~= 0) then
				ESX.ChatMessage(source, "Invalid arguments.")
			else
				--print("^1Invalid arguments.^0")
			end
		end
	else
		if (source ~= 0) then
			ESX.ChatMessage(source, "Invalid arguments.")
		else
			--print("^1Invalid arguments.^0")
		end
	end
end, {help = _U('setjob'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "job2", help = _U('setjob_param2')},
	{name = "grade_id", help = _U('setjob_param3')}
}})

ESX.AddGroupCommand('giveitem', 'responsable', function(source, args, user)
	local xTarget = ESX.GetPlayerFromId(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
	local XargetName = GetPlayerName(args[1]) or 'CONSOLE'
	local ItemeurName = source ~= 0 and GetPlayerName(source) or "Console"

	if xTarget then
		local item = args[2]
		local count = tonumber(args[3])

		if (count) then

			xTarget.addInventoryItem(item, count, nil, true)
			xTarget.showNotification('Vous venez de recevoir x~s~'..count..' '..item..'~s~ dans vottre inventaire.')

			if (xPlayer) then
				xPlayer.showNotification('Le joueurs (~s~'..args[1]..' ~s~- ~s~'..XargetName..'~s~) viens de recevoir x~s~'..count..' '..item..'~s~ dans son inventaire.')
			end

            if args[2] == "cash" or args[2] == "dirtycash" then
                --SendLogsCommande("Staff", "OneLife | Give", "**"..ItemeurName.."** vient de donner "..count.." **"..item.."** a **"..XargetName.."**", "https://discord.com/api/webhooks/1140394112068100196/mVJRGwnotkwbeh66GIzCERyIuw1EhkRCswylNKLQbQuBiO0n9hmfUsJ0QBE-YnGQx6k8")
                CoreSendLogs(
                    "Give Money",
                    "OneLife | Give Money",
                    ("le Staff (***%s | %s***) vient de donner (***%sx | %s***) a (***%s | %s***)"):format(
                        xPlayer.getName(),
                        xPlayer.getIdentifier(),
                        count,
                        item,
                        xTarget.getName(),
                        xTarget.getIdentifier()
                    ),
                    "https://discord.com/api/webhooks/1310452076307812394/aEzl5nRkrSzpJ8ifz1skNcdCJ-EF1WpBlv-ODZS8qqSfznyAhxVQ2-oVX3dzsWVB8kn2"
                )
            else
                --SendLogsCommande("Staff", "OneLife | Give", "**"..ItemeurName.."** vient de donner "..count.." **"..item.."** a **"..XargetName.."**", "https://discord.com/api/webhooks/1104575642495877163/6YnVADV_u1MD66MNTKDvR3-Hp6fg8TtXpYLE3V-qmzmAirqIDzMxfMy67vg8DxASwuRG")
                CoreSendLogs(
                    "Give Items",
                    "OneLife | Give Items",
                    ("le Staff (***%s | %s***) vient de donner (***%sx | %s***) a (***%s | %s***)"):format(
                        xPlayer.getName(),
                        xPlayer.getIdentifier(),
                        count,
                        item,
                        xTarget.getName(),
                        xTarget.getIdentifier()
                    ),
                    "https://discord.com/api/webhooks/1310452262270668852/GGEs0P_7R0cqNJYaWcjUZw8-tQukMzTLrGEPiZepn3n7P96CAN4fOMkrELpYXmtK9NXd"
                )
            end

		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		xPlayer.showNotification('Le joueur n\'est pas en ligne.')
	end
end, {help = _U('giveitem'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "item", help = _U('item')},
	{name = "amount", help = _U('amount')}
}})

ESX.AddGroupCommand('clearinventory', 'admin', function(source, args, user)

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(source)
		tPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
		tPlayer = ESX.GetPlayerFromId(source)
	end

	if tPlayer then
		tPlayer.clearInventoryItem()
		xPlayer.showNotification('Vous avez clear l\'inventaire de : '..tPlayer.name)
		--SendLogsCommande("Clear", "OneLife | Clear", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) a clear l'inventaire de **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1093165514714529843/1DOJeOOSSe_JovHzp6QijeBUHK7eWyGXD5_42RZgF6IXl74Sz8vLP1YxB_wsG6FbEz9R")
        CoreSendLogs(
            "Clear Inventory",
            "OneLife | Clear Inventory",
            ("le Staff (***%s | %s***) a clear l'inventaire du joueurs (***%s | %s***)"):format(
                xPlayer.getName(),
                xPlayer.getIdentifier(),
                tPlayer.getName(),
                tPlayer.getIdentifier()
            ),
            "https://discord.com/api/webhooks/1310452861897019392/AOKESIILSgMBXKlotOzQZo81lyAPzRCBT1sw-b9zc3eDTKMI9AsMQX29JNlLcAcXj6_R"
        )
    else
		ESX.ChatMessage(source, "Le joueur n'est pas en ligne.")
	end
end, {help = _U('command_clearinventory'), params = {
	{name = "playerId", help = _U('command_playerid_param')}
}})

ESX.AddGroupCommand('clearallloadout', 'admin', function(source, args, user)

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(source)
		tPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
		tPlayer = ESX.GetPlayerFromId(source)
	end

	if (tPlayer) then
		tPlayer.clearAllInventoryWeapons(true);
        xPlayer.showNotification('Vous avez clear les armes de : '..tPlayer.name)
		--SendLogsCommande("Clear", "OneLife | Clear (PermaWeapon)", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) a clear les armes de **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1093165514714529843/1DOJeOOSSe_JovHzp6QijeBUHK7eWyGXD5_42RZgF6IXl74Sz8vLP1YxB_wsG6FbEz9R")
        CoreSendLogs(
            "Clear Weapon Perm",
            "OneLife | Weapon Perm",
            ("le Staff (***%s | %s***) a clear les armes perm du joueurs (***%s | %s***)"):format(
                xPlayer.getName(),
                xPlayer.getIdentifier(),
                tPlayer.getName(),
                tPlayer.getIdentifier()
            ),
            "https://discord.com/api/webhooks/1310453384758951996/61m9Mf3_uXgJX6GMbmd3KrzFD8SUsZNofyTyW677cQhUHn2IupOidCteMUJUSUKMaNmB"
        )
    else
		ESX.ChatMessage(source, "Le joueur n'est pas en ligne.")
	end
	
end, {help = _U('command_clearloadout'), params = {
	{name = "playerId", help = _U('command_playerid_param')}
}})

ESX.AddGroupCommand('clearloadout', 'admin', function(source, args, user)

    if args[1] then
        xPlayer = ESX.GetPlayerFromId(source)
        tPlayer = ESX.GetPlayerFromId(args[1])
    else
        xPlayer = ESX.GetPlayerFromId(source)
        tPlayer = ESX.GetPlayerFromId(source)
    end
	
	if (tPlayer) then
		tPlayer.clearAllInventoryWeapons(false);
        xPlayer.showNotification('Vous avez clear les armes de : '..tPlayer.name)
		--SendLogsCommande("Clear", "OneLife | Clear", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) a clear les armes de **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1093165514714529843/1DOJeOOSSe_JovHzp6QijeBUHK7eWyGXD5_42RZgF6IXl74Sz8vLP1YxB_wsG6FbEz9R")
        CoreSendLogs(
            "Clear Weapon",
            "OneLife | Weapon",
            ("le Staff (***%s | %s***) a clear les armes du joueurs (***%s | %s***)"):format(
                xPlayer.getName(),
                xPlayer.getIdentifier(),
                tPlayer.getName(),
                tPlayer.getIdentifier()
            ),
            "https://discord.com/api/webhooks/1310453384758951996/61m9Mf3_uXgJX6GMbmd3KrzFD8SUsZNofyTyW677cQhUHn2IupOidCteMUJUSUKMaNmB"
        )
    else
		ESX.ChatMessage(source, "Le joueur n'est pas en ligne.")
	end
    
end, {help = _U('command_clearloadout'), params = {
    {name = "playerId", help = _U('command_playerid_param')}
}})

ESX.AddGroupCommand('saveall', 'fondateur', function(source, args, user)
	ESX.SavePlayers();
end, {help = "Sauvegarder tout les joueurs dans la base de données.", params = {}});

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if (eventData.secondsRemaining == 60) then
		SetTimeout(30000)
		ESX.SavePlayers()
		print("Sauvegarder tout les joueurs dans la base de données.");
		-- print("Sauvegarder tout les joueurs dans la base de données.");
	end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	ESX.SavePlayers()
	print("Sauvegarder tout les joueurs dans la base de données.");
	-- print("Sauvegarder tout les joueurs dans la base de données.");
end)

ESX.AddGroupCommand('debugplayer', 'fondateur', function(source, args, user)

	if (args[1]) then

		local player;

		if (args[1]:find("license:")) then

			player = ESX.GetPlayerFromIdentifier(args[1]);

		else
			player = ESX.GetPlayerFromId(tonumber(args[1]));
		end
		if (player) then
			TriggerEvent('esx:playerDropped', player.source, xPlayer, reason)
			ESX.Players[player.source] = nil;
		end
	else
		if (source > 0) then
			ESX.GetPlayerFromId(source).showNotification("~s~Vous devez entrer une license ou un id valide.");
		else
			print("^1Vous devez entrer une license ou un id valide.");
			-- print("^1Vous devez entrer une license ou un id valide.");
		end
	end
end, {help = "Debug un joueur hors ligne", params = {
	{name = "playerInfo", help = "ID/license du joueur"}
}});

-- function SendLogsCommande(name, title, message, web)
-- 	local local_date = os.date('%H:%M:%S', os.time())
-- 	local content = {
-- 		{
-- 			["title"] = title,
-- 			["description"] = message,
-- 			["type"]  = "rich",
-- 			["color"] = 16776960,
-- 			["footer"] =  {
-- 			["text"] = "Powered by OneLife ©   |  "..local_date,
-- 			},
-- 		}
-- 	}
-- 	PerformHttpRequest(web, function(err, text, headers) 
-- 	end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
-- end

function CoreSendLogs(name, title, message, web)
    local local_date = os.date('%H:%M:%S', os.time())
  
	local embeds = {
		{
			["title"]= title,
			["description"]= message,
			["type"]= "rich",
			["color"] = 1000849,
			["footer"]= {
			    ["text"]= "Made for OneLife ©   |  "..local_date.."",
				["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
			},
		}
	}
  
    if message == nil or message == '' then return false end
    PerformHttpRequest(web, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end