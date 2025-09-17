ServerInBlackout = false

-- function ShowAlertNotification(title, content, societyType)
--     exports["engine_nui"]:SendNUIMessage(-1, {
--         type = 'showSocietyNotify',
--         title = title or "Default Title",
--         content = content or "Default Content",
--         societyType = societyType or "Default Society Type"
--     })
-- end

-- local function RunEvent()
--     if (ServerInBlackout) then
--         local Job = "Gouvernement de LS"
--         local Content = "⚠️ Une coupure d'électricité affecte actuellement certaines zones de Los Santos. Ce message est envoyé automatiquement. Nos équipes travaillent activement pour rétablir le service. Nous reviendrons vers vous dès que nous aurons de nouvelles informations. Merci pour votre compréhension."
--         while (ServerInBlackout) do
--             Wait(600000)
--             ShowAlertNotification(Job, Content, "Alerte National")
--         end  
--     end
-- end

-- ESX.AddGroupCommand("blackout", "gerantstaff", function(source, args)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local blackout = tostring(args[1])

--     if (xPlayer) then
--         if (blackout == "on") then
--             if (ServerInBlackout) then
--                 xPlayer.showNotification("Le blackout est déjà activé.")
--             else
--                 TriggerClientEvent("iZeyy:SetBlackout", -1, true)
--                 ExecuteCommand("time 00 00")
--                 ExecuteCommand("freezetime")
--                 ExecuteCommand("setweather thunder")
--                 ServerInBlackout = true
--                 SetTimeout(18000, function()
--                     local Job = "Gouvernement de LS"
--                     local Content = "Une coupure d'électricité affecte actuellement certaines zones de Los Santos. Nos équipes travaillent activement pour rétablir le service dans les meilleurs délais. Nous vous remercions pour votre compréhension."
--                     ShowAlertNotification(Job, Content, "Alerte National")
--                     RunEvent()
--                 end)
--             end
--         elseif (blackout == "off") then
--             if (not ServerInBlackout) then
--                 xPlayer.showNotification("Le blackout est déjà désactivé.")
--             else
--                 TriggerClientEvent("iZeyy:SetBlackout", -1, false)
--                 ExecuteCommand("freezetime")
--                 ExecuteCommand("setweather extrasunny")
--                 ServerInBlackout = false
--             end
--         else
--             xPlayer.showNotification("Utilisez on ou off")
--         end
--     end
-- end, {help = "Activé / Desactivé le Blackout", params = {
--     {name = "status", help = "on pour l'Activé off pour le Desactivé "}
-- }})

-- AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
--     deferrals.defer()
--     local src = source

--     if (ServerInBlackout) then
--         deferrals.update("Connexion en cours a l'event...")
--         Wait(1000)
--         TriggerClientEvent("iZeyy:SetBlackout:After", src, true)
--     end

--     deferrals.done()
-- end)

-- AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
--     if (ServerInBlackout) then
--         TriggerClientEvent("iZeyy:SetBlackout:After", playerId, true)
--     end
-- end)
