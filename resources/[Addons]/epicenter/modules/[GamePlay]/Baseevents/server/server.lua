--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterServerEvent('baseevents:onPlayerDied')
RegisterServerEvent('baseevents:onPlayerKilled')
RegisterServerEvent('baseevents:onPlayerWasted')

AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
	local victim = source

	RconLog({msgType = 'playerKilled', victim = victim, attacker = killedBy, data = data})
end)

AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos)
	local victim = source

	RconLog({msgType = 'playerDied', victim = victim, attackerType = killedBy, pos = pos})
end)