local onlinePlayers = 0

RegisterNetEvent('iZeyy::Hud::UpdatePlayers')
AddEventHandler('iZeyy::Hud::UpdatePlayers', function(playerCount)
	onlinePlayers = playerCount
end)

CreateThread(function()
    while true do
        AddTextEntry('FE_THDR_GTAO', ('~b~OneLife RP~s~ ~c~|~s~ ID: ~b~'..GetPlayerServerId(PlayerId())..'~s~ ~c~ | ~s~ ~b~'..GetPlayerName(PlayerId()))..'~c~ | ~s~ (~b~'..onlinePlayers..'~s~) Joueurs ~c~|~s~ discord.gg/~b~onelife')
        AddTextEntry('PM_PANE_KEYS', 'Configurer vos Touches')
        AddTextEntry('PM_PANE_AUD', 'Audio & Son')
        AddTextEntry('PM_PANE_GTAO', 'Touches Basique')
        AddTextEntry('PM_PANE_CFX', '~s~OneLife')
        AddTextEntry('PM_PANE_LEAVE', 'Retourner sur la liste des serveurs.')
        AddTextEntry('PM_PANE_QUIT', 'Quitter ~s~OneLife')
        Wait(1000)
    end
end)

CreateThread(function()
	while true do
		SetDiscordAppId(1303440261304815758)
		SetDiscordRichPresenceAsset('logo')
		SetDiscordRichPresenceAssetText('Rejoins nous !')
		local playerName = GetPlayerName(PlayerId())
		local playerServerId = GetPlayerServerId(PlayerId())
		local playerCoords = GetEntityCoords(PlayerPedId())
		local streetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		local streetName = GetStreetNameFromHashKey(streetHash)
		SetRichPresence(playerName .. " [".. playerServerId .."] - "..onlinePlayers.." Joueurs\nSe balade à " .. streetName)
		SetDiscordRichPresenceAction(0, "Rejoindre le discord", "https://discord.gg/onelife")
		SetDiscordRichPresenceAction(1, "Boutique du serveur", "https://onelife.tebex.io/")
		Wait(5000)
	end
end)

CreateThread(function()
    local wait = 15
    local count = 60
    local KO = false

    while true do
        if IsPedInMeleeCombat(PlayerPedId()) then
            if GetEntityHealth(PlayerPedId()) < 115 then
                ESX.ShowNotification("Vous etes assommé (K.O)")
                wait = 15
                KO = true
                SetEntityHealth(PlayerPedId(), 116)
            end
        end

        if KO then
            SetPlayerInvincible(PlayerId(), true)
            DisablePlayerFiring(PlayerId(), true)
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(PlayerPedId())

            if wait >= 0 then
                count = count - 1

                if count == 0 then
                    count = 60
                    wait = wait - 1
                    SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 4)
                end
            else
                SetPlayerInvincible(PlayerId(), false)
                KO = false
            end
        end
       Wait(0)
   end
end)