RegisterCommand('teleport', function(source, args, rawCommand)
    if (ESX.GetPlayerData()['group'] ~= "user") then

        if #args ~= 3 then
            ESX.ShowNotification("Mauvaise utilisation")
            return
        end

        local x = tonumber(args[1])
        local y = tonumber(args[2])
        local z = tonumber(args[3])

        if (x and y and z) then
            local playerPed = Client.Player:GetPed()

            DoScreenFadeOut(500)
            Wait(500)
            SetEntityCoords(playerPed, x, y, z)
            Wait(500)
            DoScreenFadeIn(500)
        else
            ESX.ShowNotification("Position invalide")
        end
    end
    
end, false)