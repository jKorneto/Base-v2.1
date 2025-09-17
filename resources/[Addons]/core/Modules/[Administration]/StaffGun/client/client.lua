local active = false
local victimServerId = nil
local victimName = nil
local playerData = {}
local main_menu = RageUI.AddMenu("", "Staff Gun Gestion")

AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" and active then
        local victim = args[1]
        local attacker = args[2]
        
        if attacker == PlayerPedId() and IsPedAPlayer(victim) then
            if attacker ~= victim then
                local playerIndex = NetworkGetPlayerIndexFromPed(victim)
                victimServerId = GetPlayerServerId(playerIndex)
                victimName = GetPlayerName(playerIndex)
                TriggerServerEvent("izey:requestVictimInfo", victimServerId)
                main_menu:Toggle()
            end
        end
        
    end
end)


RegisterNetEvent("izey:receiveVictimInfo", function(data)
    if data then
        playerData = data
    end
end)

main_menu:IsVisible(function()

    Items:Separator("Staff : ~s~"..GetPlayerName(PlayerId()).."~s~ | ID : ~s~"..GetPlayerServerId(PlayerId()))

    Items:Line()

    Items:Button("Se Teleporter", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            TriggerServerEvent("sAdmin:Goto", victimServerId)
        end
    })

    Items:Button("Téléporter sur vous", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            TriggerServerEvent("sAdmin:Bring", victimServerId)
        end
    })


    Items:Button("Revive le joueur", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            ExecuteCommand("revive "..victimServerId)
        end
    })

    Items:Button("Heal le joueur", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            ExecuteCommand("heal "..victimServerId)
        end
    })

    Items:Button("Freeze le joueur", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            TriggerServerEvent("sAdmin:Freeze", victimServerId)
        end
    })

    Items:Button("Kick le joueur", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            local reason = "Vous avez ete kick par le staff "..GetPlayerName(PlayerId())
            TriggerServerEvent("sAdmin:Kick", victimServerId, reason)
            main_menu:Close()
        end
    })

    Items:Button("Ban le joueur", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            local banTime = 1
            local banReason = "Vous avez ete ban par le staff "..GetPlayerName(PlayerId())
            ExecuteCommand("ban "..victimServerId.." "..banTime.." "..banReason)
        end
    })

end, function(Panels)

    Panels:info("Staff Gun Gestion",
        {"Joueurs:", "ID:", "Métier:", "Grade:", "Faction:", "Rank:"},
        {"~s~"..victimName, "~s~"..victimServerId, "~s~"..(playerData.job or "NotFound"), "~s~"..(playerData.grade or "NotFound"), "~s~"..(playerData.faction or "NotFound"), "~s~"..(playerData.grade2 or "NotFound")})

end)

RegisterCommand("staffgun", function()
    active = not active
    if ESX.GetPlayerData()['group'] == "fondateur" or ESX.GetPlayerData()['group'] == "gerantstaff" or ESX.GetPlayerData()['group'] == "responsable" or ESX.GetPlayerData()['group'] == "admin" then
        if not active then
            ESX.ShowNotification("Staff Gun ~s~désactivé")
        else
            ESX.ShowNotification("Staff Gun ~s~activé")
        end
    else
        ESX.ShowNotification("Permission invalide")
    end
end)