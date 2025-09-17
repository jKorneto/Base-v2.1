--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX  = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(animationLib, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget)
	if targetSrc ~= -1 then
		TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget)
		TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
	else
        TriggerEvent("tF:Protect", source, '(cmg2_animations:sync)');
	end
end)

local adminBan = false;

ESX.AddGroupCommand("debugporter", "helpeur", function(src)
	
		local adminBan = not adminBan;
		xPlayer.showNotification("Debug Porter : "..tostring(adminBan));

end, {help = "Debug Porter"});

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc, needBan, z)

	local src = source;
	local coords = GetEntityCoords(GetPlayerPed(src));
	local targetPed = GetPlayerPed(targetSrc);
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc);

	if (needBan == 0) then

		local xPlayer = ESX.GetPlayerFromId(src)

		if (z) then
			SetEntityCoords(targetPed, coords.x, coords.y, z);
		end

		if (adminBan and xPlayer and xPlayer.getGroup() ~= "user") then

			ExecuteCommand(('ban %s 0 Exploit /porter (admin)'):format(xPlayer.source));
			return;

		end

		if (not xPlayer or xPlayer.getGroup() == "user") then

			ExecuteCommand(('ban %s 0 Exploit /porter'):format(source));
			
		end
		
	end
end)

RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(animationLib, animationLib2, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget, attachFlag)
	if targetSrc ~= -1 then
		TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget, attachFlag)
		TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
	else
        TriggerEvent("tF:Protect", source, '(cmg3_animations:sync)');
	end
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler("esx:playerLoaded", function(_, xPlayer)
    local xPlayer = xPlayer
    if (xPlayer) then  
		SendLogs("Connexion Joueur", "OneLife | Connexion", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de se connecter", "https://discord.com/api/webhooks/1093168834950746132/XNa9yr-PJdnxxRRxcTlomN0lgBfXLvRYwBaNEIguX5dcaEIdXer48QNBS1aV7itJ_ej2")
	end
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler("esx:playerLoaded", function(_, xPlayer)
    local xPlayer = xPlayer
    if (xPlayer) then  
		if (string.find(xPlayer.name, "<img src")) then
			DropPlayer(xPlayer.source, "Erreur lors du chargement de votre pseudo FiveM, veuillez changer ce dernier.")
		end
	end
end)

AddEventHandler("playerDropped", function(reason)
    local playerSrc = source
    local xPlayer = ESX.GetPlayerFromId(playerSrc)
    if (xPlayer) then 
		SendLogs("Déconnexion Joueur", "OneLife | Déconnexion", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de se déconnecter pour la raison (***"..reason.."***)", "https://discord.com/api/webhooks/1093168834950746132/XNa9yr-PJdnxxRRxcTlomN0lgBfXLvRYwBaNEIguX5dcaEIdXer48QNBS1aV7itJ_ej2")
	end
end)

function SendLogs(name, title, message, web)
    local local_date = os.date('%H:%M:%S', os.time())
  
	local embeds = {
		{
			["title"]= title,
			["description"]= message,
			["type"]= "rich",
            ["color"] = 1000849,
            ["footer"] =  {
              ["text"]= "Powered for OneLife ©   |  "..local_date.."",
              ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
            },
		}
	}
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(web, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end