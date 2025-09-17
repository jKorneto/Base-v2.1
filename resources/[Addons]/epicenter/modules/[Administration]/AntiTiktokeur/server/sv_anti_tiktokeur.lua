local Fdp = {}

RegisterCommand("antisalope", function(source, args, rawCommand)
    if (source == 0 or (ESX.GetPlayerFromId(source) and ESX.GetPlayerFromId(source).getGroup() == AntiTiktokeur.AutorizedGroup)) then
        local TargetId = tonumber(args[1])
        local ImageUrl = AntiTiktokeur.Image

        if (not TargetId) then
            return print("Vous devez spécifier un ID")
        end

        local xTarget = ESX.GetPlayerFromId(TargetId)
        if (not xTarget) then
            return print("Joueur introuvable")
        end

        local PlayerPed = GetPlayerPed(xTarget.source)

        if (ImageUrl) then
            Fdp[xTarget.identifier] = true
            TriggerClientEvent("anti:tiktokeur:salope", xTarget.source, ImageUrl)
            SetEntityCoords(PlayerPed, AntiTiktokeur.TeleportCoords)
            for i = 1, 3 do
                exports["xsound"]:PlayUrl(xTarget.source, "AntiFdp_" .. i, AntiTiktokeur.Sound, 1.0, true)
            end
        end
    end
end)

RegisterNetEvent("anti:tiktokeur:byeeeee", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (Fdp[xPlayer.identifier] == true) then
        Fdp[xPlayer.identifier] = {}
        xPlayer.ban(0, "Va cheat ailleurs " .. AntiTiktokeur.ServerName .. " OnTop 🦧🤡")
    else
        xPlayer.showNotification("Abuse toi aussi Chef 🦧")
    end
end)

-- AddEventHandler("playerDropped", function()
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if (Fdp[xPlayer.identifier] == true) then
--         local args = {xPlayer.identifier, 0, "Va cheat ailleurs " .. AntiTiktokeur.ServerName .. " OnTop 🦧🤡"}
--         banplayeroffline(0, args)
--     end
-- end)