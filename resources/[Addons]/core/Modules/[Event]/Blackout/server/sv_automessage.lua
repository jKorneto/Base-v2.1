-- CreateThread(function()
--     local Job = "Gouvernement de LS"
--     local Messages = {
--         [16] = "Alerte : Des perturbations électriques mineures sont signalées. Nous vous prions de rester vigilants..",
--         [17] = "Mise à jour : Nous continuons à restaurer le réseau. Des coupures peuvent encore survenir.",
--         [18] = "Avis : Les perturbations électriques devraient se stabiliser bientôt. Merci de votre coopération.",
--         [19] = "Alerte : Le risque de coupures de courant augmente à mesure que la demande sur le réseau augmente.",
--         [20] = "Avis : La situation électrique reste critique. Préparez-vous à des interruptions prolongées.",
--     }

--     for hour = 16, 20 do
--         if hour > 16 then
--             Wait(3600000)
--         end

--         local Content = Messages[hour]
--         if Content then
--             ShowAlertNotification(Job, Content, "Alerte Nationale")
--         end
--     end

--     Shared.Log:Info("Fin des annonces pour l'événement blackout.")
-- end)
