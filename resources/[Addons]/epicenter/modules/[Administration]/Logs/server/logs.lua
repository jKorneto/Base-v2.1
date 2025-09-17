--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]
AllLogs = true											-- Enable/Disable All Logs Channel
username = "OneLife" 							        -- Bot Username
avatar = "https://media.discordapp.net/attachments/956305044150562849/973681026910003240/OneLife-Logo.png?width=676&height=676"				-- Bot Avatar
communtiyName = "OneLife"					            -- Icon top of the Embed
communtiyLogo = "https://media.discordapp.net/attachments/956305044150562849/973681026910003240/OneLife-Logo.png?width=676&height=676"		-- Icon top of the Embed


weaponLog = true  			-- set to false to disable the shooting weapon logs
weaponLogDelay = 0		-- delay to wait after someone fired a weapon to check again in ms (put to 0 to disable) Best to keep this at atleast 1000

playerID = true				-- set to false to disable Player ID in the logs
steamID = true				-- set to false to disable Steam ID in the logs
steamURL = true				-- set to false to disable Steam URL in the logs
discordID = false			-- set to false to disable Discord ID in the logs


joinColor = "32767"
leaveColor = "32767"
chatColor = "32767"
shootingColor = "32767"
deathColor = "32767"
resourceColor = "32767"


webhooks = {
	all = "",
	chat = "",
	joins = "",
	leaving = "",
	deaths = "https://discord.com/api/webhooks/1310481178696089611/_oGfpq_rx-kfCFfNHiRGCaBLqRRjjMbyixsq6QacX4i_rAP6-0ulo4twRGn2x_ABk-j2",
	shooting = "",
	resources = "",
}


 --Debug shizzels :D
debug = false
versionCheck = "1.1.0"

function sanitize(string)
    return string:gsub('%@', '')
end
exports('sanitize', function(string)
    sanitize(string)
end)
RegisterNetEvent("discordLogs")
AddEventHandler("discordLogs", function(message, color, channel)
    discordLog(message, color, channel)
end)
-- Get exports from server side
exports('discord', function(message, id, id2, color, channel)
	local ids = ExtractIdentifiers(id)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	if discordID then 
		if ids.discord ~= "" then 
			_discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" 
		else 
			_discordID = "\n**Discord ID:** N/A" 
		end 
	else 
		_discordID = ""
	end

	if steamID then 
		if ids.steam ~= "" then 
			_steamID ="\n**Steam ID:** " ..ids.steam.."" 
		else 
			_steamID = "\n**Steam ID:** N/A" 
		end 
	else 
		_steamID = ""
	end
	if steamURL then  
		if ids.steam ~= "" then 
			_steamURL ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""
		else
			_steamURL = "\n**Steam URL:** N/A" 
		end 
	else 
		_steamURL = "" 
	end
	if playerID then _playerID ="\n**Player ID:** " ..id.."" else _playerID = "" end
	local player1 = message..'\n'.._playerID..''.. _discordID..''.._steamID..''.._steamURL
	_message = player1
	if id2 ~= 0 then
	local ids2 = ExtractIdentifiers(id2)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	if discordID then if ids2.discord ~= "" then _discordID2 ="\n**Discord ID:** <@" ..ids2.discord:gsub("discord:", "")..">" else _discordID2 = "\n**Discord ID:** N/A" end else _discordID2 = "" end
	if steamID then if ids2.steam ~= "" then _steamID2 ="\n**Steam ID:** " ..ids2.steam.."" else _steamID2 = "\n**Steam ID:** N/A" end else _steamID2 = "" end
	if steamURL then  if ids2.steam ~= "" then _steamURL2 ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids2.steam:gsub("steam:", ""),16).."" else _steamURL2 = "\n**Steam URL:** N/A" end else _steamURL2 = "" end
	if playerID then _playerID2 ="\n**Player ID:** " ..id2.."" else _playerID2 = "" end
	local player2 = _playerID2..''.. _discordID2..''.._steamID2..''.._steamURL2
	_message = player1..'\n'..player2
	end
    discordLog(_message, color, channel)
end)
-- Sending message to the All Logs channel and to the channel it has listed
function discordLog(message, color, channel)
  if AllLogs then
	PerformHttpRequest(webhooks["all"], function(err, text, headers) end, 'POST', json.encode({username = username, embeds = {{["color"] = color, ["author"] = {["name"] = communtiyName,["icon_url"] = ""}, ["description"] = "".. message .."",["footer"] = {["text"] = ""..os.date(""),["icon_url"] = "",},}}, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
  end
	PerformHttpRequest(webhooks[channel], function(err, text, headers) end, 'POST', json.encode({username = username, embeds = {{["color"] = color, ["author"] = {["name"] = communtiyName,["icon_url"] = ""}, ["description"] = "".. message .."",["footer"] = {["text"] = ""..os.date(""),["icon_url"] = "",},}}, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end

-- Event Handlers
-- Send message when Player died (including reason/killer check) (Not always working)
RegisterServerEvent('playerDied')
AddEventHandler('playerDied', function(Id, Player, Killer, DeathReason, Weapon)

    local xPlayer = ESX.GetPlayerFromId(source)
    local DeathReason = DeathReason and DeathReason or "Suicide"
    local Weapon = Weapon or ""

    if Id == 1 then
        CoreSendLogs(
            "Logs de Mort",
            "OneLife | Mort",
            ("Le Joueur %s (***%s***) est mort (***%s***)"):format(
                xPlayer.getName(),
                xPlayer.identifier,
                DeathReason
            ),
            "https://discord.com/api/webhooks/1310481178696089611/_oGfpq_rx-kfCFfNHiRGCaBLqRRjjMbyixsq6QacX4i_rAP6-0ulo4twRGn2x_ABk-j2"
        )
    elseif Id == 2 then
        local tPlayer = ESX.GetPlayerFromId(Killer)
        CoreSendLogs(
            "Logs de Mort",
            "OneLife | Mort",
            ("Le joueur %s (***%s***) a été tué par %s (***%s***) avec l'arme (***%s***)"):format(
                xPlayer.getName(),
                xPlayer.identifier,
                tPlayer.getName(),
                tPlayer.identifier,
                Weapon
            ),
            "https://discord.com/api/webhooks/1310481178696089611/_oGfpq_rx-kfCFfNHiRGCaBLqRRjjMbyixsq6QacX4i_rAP6-0ulo4twRGn2x_ABk-j2"
        )        
        xPlayer.showNotification(("Vous été tué par le joueur id : %s"):format(tPlayer.source))
    else
        CoreSendLogs(
            "Logs de Mort",
            "OneLife | Mort",
            ("Le Joueur %s (***%s***) est mort (***Other***)"):format(
                xPlayer.getName(),
                xPlayer.identifier
            ),
            "https://discord.com/api/webhooks/1310481178696089611/_oGfpq_rx-kfCFfNHiRGCaBLqRRjjMbyixsq6QacX4i_rAP6-0ulo4twRGn2x_ABk-j2"
        )
    end

end)

-- Getting exports from clientside
RegisterServerEvent('ClientDiscord')
AddEventHandler('ClientDiscord', function(message, id, id2, color, channel)
	local ids = ExtractIdentifiers(id)	
	local xPlayer = ESX.GetPlayerFromId(source)	
	if discordID then if ids.discord ~= "" then _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" else _discordID = "\n**Discord ID:** N/A" end else _discordID = "" end
	if steamID then if ids.steam ~= "" then _steamID ="\n**Steam ID:** " ..ids.steam.."" else _steamID = "\n**Steam ID:** N/A" end else _steamID = "" end
	if steamURL then  if ids.steam ~= "" then _steamURL ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "\n**Steam URL:** N/A" end else _steamURL = "" end
	if playerID then _playerID ="\n**Player ID:** " ..id.."" else _playerID = "" end
	local player1 = message..'\n'.._playerID..''.. _discordID..''.._steamID..''.._steamURL
	_message = player1
	if id2 ~= 0 then
	local ids2 = ExtractIdentifiers(id2)    
	if discordID then if ids2.discord ~= "" then _discordID2 ="\n**Discord ID:** <@" ..ids2.discord:gsub("discord:", "")..">" else _discordID2 = "\n**Discord ID:** N/A" end else _discordID2 = "" end
	if steamID then if ids2.steam ~= "" then _steamID2 ="\n**Steam ID:** " ..ids2.steam.."" else _steamID2 = "\n**Steam ID:** N/A" end else _steamID2 = "" end
	if steamURL then  if ids2.steam ~= "" then _steamURL2 ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids2.steam:gsub("steam:", ""),16).."" else _steamURL2 = "\n**Steam URL:** N/A" end else _steamURL2 = "" end
	if playerID then _playerID2 ="\n**Player ID:** " ..id2.."" else _playerID2 = "" end
	local player2 = _playerID2..''.. _discordID2..''.._steamID2..''.._steamURL2
	_message = player1..'\n'..player2
	end
   discordLog(_message, color,  channel)
end)
RegisterServerEvent('JDlogs:GetIdentifiers')
AddEventHandler('JDlogs:GetIdentifiers', function(src)
	local ids = ExtractIdentifiers(src)
	return ids
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end

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