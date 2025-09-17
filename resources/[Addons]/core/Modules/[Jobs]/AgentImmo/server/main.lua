local Timeout = {}
local SpawnTimeout = {}

RegisterNetEvent("iZeyy:Dynasty8:SendAnnoucement", function(announcementType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.job.name ~= "realestateagent") then
            xPlayer.ban(0, "Veuillez vous reconnectez Erreur : (iZeyy:Dynasty8:SendAnnoucement)")
            return
        end

        local jobLabel = xPlayer.job.name_label
        local announcementCategory = announcementType == 1 and "open" or announcementType == 2 and "close" or "recruitment"
        local announcementContent = Config["Dynasty8"]["Annoucement"][announcementCategory]

        showSocietyNotify(xPlayer, xPlayer.job.name, "Dynasty8", announcementContent, "Informations", 10)
    end
end)

RegisterNetEvent("iZeyy:Dynasty8:SpawnVehicle", function(Model, Label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    local correctVehicle = false

    if (xPlayer) then
        if (xPlayer.job.name ~= "realestateagent") then
            xPlayer.ban(0, "(iZeyy:Dynasty8:SpawnVehicle) #2")
            return
        end

        if (not SpawnTimeout[xPlayer.identifier] or GetGameTimer() - SpawnTimeout[xPlayer.identifier] > 10000) then
            SpawnTimeout[xPlayer.identifier] = GetGameTimer()

            for k, v in pairs(Config["Dynasty8"]["VehList"]) do
                if Model == v.model and Label == v.label then
                    correctVehicle = true
                    break
                end
            end

            if #(coords - Config["Dynasty8"]["CarMenuPos"]) < 15 then
                ESX.SpawnVehicle(Model, Config["Dynasty8"]["SpawnCarPos"], Config["Dynasty8"]["SpawnCarHeading"], nil, false, xPlayer, xPlayer.identifier, function(vehicle)
                    --TaskWarpPedIntoVehicle(player, vehicle, -1)
                    SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
                end)
            else
                xPlayer.ban(0, "(iZeyy:Dynasty8:SpawnVehicle) (coords)")
            end

        else
            xPlayer.ban(0, "(iZeyy:Dynasty8:SpawnVehicle) (correctVehicle)")
        end
    else
        xPlayer.showNotification("Veuillez attendre 10 seconde avant de refaire appel a un véhicule")
    end
end)