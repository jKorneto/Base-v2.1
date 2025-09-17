-- AddEventHandler("engine:enterspawn:finish", function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local UrlMusic = "https://cfx-nui-engine/Nui/assets/sounds/noel.mp3"
--     local AmbianceData = {}

--     for k, v in pairs(Config["AmbianceNoel"]["Pos"]) do        
--         table.insert(AmbianceData, {
--             MusicPos = v.position,
--             MusicRadius = v.radius,
--             MusicId = tostring(v.id)
--         })
--     end

--     if (xPlayer) then
--         TriggerClientEvent("iZeyy:Noel:StartAmbiance", xPlayer.source, UrlMusic, AmbianceData)
--         Shared.Log:Success(("Noel ambiance started for (%s)"):format(xPlayer.getName()))
--     else
--         Shared.Log:Error(("With ambiance noel for"):format(xPlayer.getName()))
--     end
-- end)