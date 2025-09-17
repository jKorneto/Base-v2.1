ServerInBlackout = false

function IsServerInBlackout()
    return ServerInBlackout
end

exports('IsServerInBlackout', IsServerInBlackout)

-- RegisterNetEvent("iZeyy:SetBlackout", function(blackout)
--     if (blackout == true) then
--         CreateDui("https://cfx-nui-engine/Nui/assets/sounds/explosion.mp3", 0.5, 0.5)
--         Wait(10000)
--         SetArtificialLightsState(true)
--         ServerInBlackout = true
--         CreateDui("https://cfx-nui-engine/Nui/assets/sounds/alarm.mp3", 1, 1)
--     elseif (blackout == false) then
--         SetArtificialLightsState(false)
--         ServerInBlackout = false
--     end
-- end)

-- RegisterNetEvent("iZeyy:SetBlackout:After", function(blackout)
--     if blackout == true then
--         ServerInBlackout = true
--         SetArtificialLightsState(true)
--         ESX.ShowNotification("La ville de Los Santos est actuellement en panne d'électricité générale. Merci de rester vigilant et de faire preuve de patience pendant que la situation est en cours de résolution.")
--     end
-- end)