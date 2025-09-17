--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

ESX.AddGroupCommand('skin', 'moderateur', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])

    if args[1] ~= nil then
        if not exports['epicenter']:IsInService(xTarget.identifier) then
            TriggerClientEvent('esx_skin:openSaveableMenu', xTarget.source)
        else
            xPlayer.showNotification('Ce joueur ne peut pas accéder au menu car il est en staff')
        end
    else
        if not exports['epicenter']:IsInService(xPlayer.identifier) then
            TriggerClientEvent('esx_skin:openSaveableMenu', xPlayer.source)
        else
            xPlayer.showNotification('Vous ne pouvez pas accéder au menu car vous êtes en staff')
        end
    end
end, {help = 'Permet de changer son skin', params = {
    {name = 'playerId', help = 'ID du joueurs'},
}})

ESX.AddGroupCommand('sn', 'responsable', function(source, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_skin:openSaveableMenu', xPlayer.source)
end, {help = 'Permet de changer son skin'})
