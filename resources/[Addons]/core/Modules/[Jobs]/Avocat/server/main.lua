local TimeoutSignal= {}
local SpawnTimeout = {}

RegisterNetEvent("iZeyy:Avocat:SendAnnoucement", function(announcementType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.job.name ~= "avocat") then
            xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:Avocat:SendAnnoucement)")
            return
        end

        local jobLabel = xPlayer.job.name_label
        local announcementCategory = announcementType == 1 and "open" or announcementType == 2 and "close" or "recruitment"
        local announcementContent = Config["Avocat"]["Annoucement"][announcementCategory]

        showSocietyNotify(xPlayer, xPlayer.job.name, "Avocat", announcementContent, "Informations", 10)
    end  
end)

RegisterNetEvent("iZeyy:Avocat:SendSignal", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if (not TimeoutSignal[xPlayer.identifier] or GetGameTimer() - TimeoutSignal[xPlayer.identifier] > 600000) then
        TimeoutSignal[xPlayer.identifier] = GetGameTimer()

        if (xPlayer.job.name ~= "avocat") then
            DropPlayer(source, "Veuillez vous reconnectez Erreur : (iZeyy:Avocat:SendSignal)")
        else
            for _, playerId in pairs(xPlayers) do
                local xTarget = ESX.GetPlayerFromId(playerId)
                if xTarget and xTarget.job.name == "police" then
                    xPlayer.showNotification("Demande envoyé un agent vous prendra en charge au plus vite")
                    xTarget.showNotification("Avocat "..xPlayer.getFirstName().." "..xPlayer.getLastName().." a fait une demande d'agent au poste de police merci de s'y rendre au plus vite")
                end
            end
        end
    else
        xPlayer.showNotification("Veuillez attendre 10 minutes avant de pouvoir refaire une demande.")
    end
end)

RegisterNetEvent("iZeyy:Avocat:SpawnVehicle", function(Model, Label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    local correctVehicle = false

    if xPlayer then
        if xPlayer.job.name ~= "avocat" then
            xPlayer.ban(0, "(iZeyy:Avocat:SpawnVehicle) (job)")
            return
        end

        if (not SpawnTimeout[xPlayer.identifier] or GetGameTimer() - SpawnTimeout[xPlayer.identifier] > 10000) then
            SpawnTimeout[xPlayer.identifier] = GetGameTimer()

            for k, v in pairs(Config["Avocat"]["VehList"]) do
                if Model == v.model and Label == v.label then
                    correctVehicle = true
                    break
                end
            end

            if #(coords - Config["Avocat"]["CarMenuPos"]) < 15 then
                local spawnPos = Config["Avocat"]["SpawnCarPos"]
                ESX.SpawnVehicle(Model, spawnPos, 0, nil, false, xPlayer, xPlayer.identifier, function(handle)
                    --TaskWarpPedIntoVehicle(ped, handle, -1);
                    SetPedIntoVehicle(GetPlayerPed(xPlayer.source), handle:GetHandle(), -1)
                end);
            else
                xPlayer.ban(0, "(iZeyy:Avocat:SpawnVehicle) (coords)")
            end

        else
            xPlayer.ban(0, "(iZeyy:Avocat:SpawnVehicle) (correctVehicle)")
        end
    else
        xPlayer.showNotification("Veuillez attendre 10 seconde avant de refaire appel a un véhicule")
    end
end)