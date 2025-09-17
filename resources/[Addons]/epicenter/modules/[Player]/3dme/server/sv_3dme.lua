--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local lang = Languages[dmeC.language]

local function onMeCommand(source, args)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source) 
    local text = "* " .. lang.prefix .. table.concat(args, " ") .. " *"
    if (string.find(text, "<img src")) then
      TriggerEvent("tF:Protect", source, 'Use /me usebug LOL');
      return
    end
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end

local function onMeCommand2(source, args)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local text = "* " .. lang.prefix .. ""..args .. " *"
    if (string.find(text, "<img src")) then
      TriggerEvent("tF:Protect", source, 'Use /me usebug LOL');
      return
    end
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end

RegisterCommand(lang.commandName, onMeCommand)

ESX.AddGroupCommand('metroll', 'fondateur', function(source, args, user)
  TriggerClientEvent("troll:me", args[1], table.concat(args, " ",2))
end, {help = 'Permet de troll les joueurs hihi', params = {
	{name = 'playerId', help = 'ID du joueurs'},
	{name = 'message', help = "le message troll "}
}})
