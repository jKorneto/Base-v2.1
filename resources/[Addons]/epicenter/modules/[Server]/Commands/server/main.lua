--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

TriggerEvent(Config.Get.ESX, function(obj) ESX = obj end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(target, command, param)
	local xPlayer, xPlayerTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if command == "group" then
		if xPlayerTarget == nil then
			xPlayer.showNotification("Joueur introuvable")
		else
			ESX.GroupCanTarget(xPlayer.getGroup(), param, function(canTarget)
				if canTarget then
					TriggerEvent('esx:customDiscordLog', xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") a modifié le groupe de permission de " .. xPlayerTarget.name .. " [" .. xPlayerTarget.source .. "] (" .. xPlayerTarget.identifier .. ") - Ancien : " .. xPlayer.getGroup() .. " / Nouveau : " .. param)
					
					xPlayerTarget.setGroup(param)
					ESX.SavePlayer(xPlayerTarget, function() end)
					xPlayer.showNotification("Mise a jours du group de "..xPlayerTarget.getName().." a etait changer en "..param)
				else
					xPlayer.showNotification("Groupe invalide ou groupe insuffisant")
				end
			end)
		end
	elseif command == "level" then
		if xPlayerTarget == nil then
			xPlayer.showNotification("Joueur introuvable")
		else
			param = tonumber(param)
			if param ~= nil and param >= 0 then
				if xPlayer.getLevel() >= param then
					TriggerEvent('esx:customDiscordLog', xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") a modifié le niveau de permission de " .. xPlayerTarget.name .. " [" .. xPlayerTarget.source .. "] (" .. xPlayerTarget.identifier .. ") - Ancien : " .. xPlayer.getLevel() .. " / Nouveau : " .. param)
					xPlayerTarget.setLevel(param)
					xPlayer.showNotification("Mise a jours du group de "..xPlayerTarget.getName().." a etait changer en "..tostring(param))
				else
					xPlayer.showNotification("Niveau insuffisant")
				end
			else
				xPlayer.showNotification("Groupe invalide ou groupe insuffisant")
			end
		end
	end
end)

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setlevel' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tonumber(args[2]) ~= nil and tonumber(args[2]) >= 0) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				Rconprint("Player not ingame\n")
				CancelEvent()
				return
			end

			TriggerEvent('esx:customDiscordLog', "CONSOLE a modifié le niveau de permission de " .. xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") - Ancien : " .. xPlayer.getLevel() .. " / Nouveau : " .. tostring(args[2]))
			xPlayer.setLevel(tonumber(args[2]))
		else
			Rconprint("Usage: setlevel [user-id] [level]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	elseif commandName == 'setgroup' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tostring(args[2]) ~= nil) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				Rconprint("Player not ingame\n")
				CancelEvent()
				return
			end

			TriggerEvent('esx:customDiscordLog', "CONSOLE a modifié le groupe de permission de " .. xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") - Ancien : " .. xPlayer.getGroup() .. " / Nouveau : " .. tostring(args[2]))
			xPlayer.setGroup(tostring(args[2]))
		else
			Rconprint("Usage: setgroup [user-id] [group]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	end
end)

-- Announce
ESX.AddGroupCommand('announce', "admin", function(source, args, user)
	TriggerClientEvent('chatMessage', -1, "🎓 Annonce ", {255, 0, 0}, table.concat(args, " "))
end, {help = "Announce a message to the entire server", params = { {name = "announcement", help = "The message to announce"} }})

-- Kick
ESX.AddGroupCommand('kick', "moderateur", function(source, args, user)
	if args[1] then
		if GetPlayerName(tonumber(args[1])) then
			local target = tonumber(args[1])
			local reason = args
			local xPlayer = ESX.GetPlayerFromId(source);
			local tPlayer = ESX.GetPlayerFromId(args[1]);
			table.remove(reason, 1)

			if #reason == 0 then
				reason = "Kick: Vous avez été exclu du serveur."
			else
				reason = "Kick: " .. table.concat(reason, " ")
			end

			xPlayer.showNotification("Le joueur ("..GetPlayerName(target)..") a etait kick pour la raison ("..reason..")")
			DropPlayer(target, reason)
			SendLogs("Staff", "OneLife | Kick", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de kick le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) pour la raison [**"..reason.."**]", "https://discord.com/api/webhooks/1310482784070144000/uNi8Vt1G8QgM-YkD_yipWE90-hjvcY-VHfHq8x4tTKtPPhY6bFD0y5ryKaW8P4lNBZ_M")
		else
			xPlayer.showNotification("Id Introuvable")
		end
	else
		xPlayer.showNotification("Id Introuvable")
	end
end, {help = "Kick a user with the specified reason or no reason", params = { {name = "userid", help = "The ID of the player"}, {name = "reason", help = "The reason as to why you kick this player"} }})

-- ESX.AddGroupCommand('setgroup', "gerant", function(source, args, user)
-- 	local xPlayer = ESX.GetPlayerFromId(source);

-- 	if (args[1]) then
-- 		local target = tonumber(args[1])
-- 		local xTarget = ESX.GetPlayerFromId(target)

-- 		if (type(xTarget) == "table") then
-- 			if (ESX.DoesGroupExist(args[2])) then
-- 				if (xTarget.getGroup() ~= args[2]) then
-- 					if (type(xPlayer) == "table" and type(xTarget) == "table") then
-- 						if (xPlayer.source == 0 or xPlayer.getGroup() ~= "user") then
-- 							local log = "**Console** a modifié le groupe de permission de **" .. xTarget.name .. "** [**" .. xTarget.source .. "**] (**" .. xTarget.identifier .. "**)  (**".. xTarget.getGroup() .."** > **".. args[2] .."**)";
-- 							SendLogs("setgroup", "OneLife | SetGroup", log, "https://discord.com/api/webhooks/1310482911434375198/BnWxOLVZu___TQPBnUEfbCwsb3Q2NLd3hHKztAeKkF-hCes3CQXQV-QZHg9uoG55GCic")
-- 							TriggerEvent("sAdmin:updateStaff", xTarget, xTarget.getGroup(), args[2])
-- 							xTarget.setGroup(args[2]);

-- 							if (xPlayer.source ~= 0) then
-- 								xPlayer.showNotification("Mise a jours du group de "..xTarget.getName().." a etait changer en "..args[2])
-- 							else
-- 								print("Group of " .. xTarget.getName() .. " has been set to " .. args[2]);
-- 							end
-- 						end
-- 					else
-- 						if (xPlayer.source ~= 0) then
-- 							xPlayer.showNotification("Joueur introuvable")
-- 						else
-- 							print("^1Joueur introuvable");
-- 						end
-- 					end
-- 				else
-- 					if (xPlayer.source ~= 0) then
-- 						xPlayer.showNotification("Le joueur posséde deja ce groupe")
-- 					else
-- 						print("This player has already this group");
-- 					end
-- 				end
-- 			else
-- 				if (xPlayer.source ~= 0) then
-- 					xPlayer.showNotification(string.format("Le groupe %s n'existe pas", args[2]))
-- 				else
-- 					print(string.format("the group %s not exist", args[2]));
-- 				end
-- 			end
-- 		end
-- 	else
-- 		if (source ~= 0) then
-- 			xPlayer.showNotification("Joueur introuvable")
-- 		else
-- 			print("Incorrect player ID!")
-- 		end
-- 	end
-- end, {
-- 	help = "Set a new group to a player", 
-- 	params = { 
-- 		{
-- 			name = "userid", 
-- 			help = "The ID of the player"
-- 		}, 
-- 		{
-- 			name = "reason", help = "The group to put"
-- 		} 
-- 	}
-- });