Shared.Events:OnNet(Enums.Gamemaster.CheckToEnter, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name == Config["Gamemaster"]["RequiredJob"]) then
            
            local Player = GetPlayerPed(xPlayer.source)
            local Coords = GetEntityCoords(Player)

            local Interior = Config["Gamemaster"]["InteriorCoords"]
            local Heading = Config["Gamemaster"]["InteriorHeading"]

            if #(Coords - Config["Gamemaster"]["EnterCoords"]) < 15 then
                SetTimeout(1000, function()
                    Shared.Events:ToClient(xPlayer.source, Enums.Gamemaster.GotoInterior, Interior, Heading)
                end)
            else
                xPlayer.showNotification("Vous etes trop loin de l'entrée")
            end
        
        end
    end
end)

Shared.Events:OnNet(Enums.Gamemaster.CheckToExit, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name == Config["Gamemaster"]["RequiredJob"]) then
            
            local Player = GetPlayerPed(xPlayer.source)
            local Coords = GetEntityCoords(Player)

            local Exit = Config["Gamemaster"]["EnterCoords"]
            local Heading = Config["Gamemaster"]["EnterHeading"]

            if #(Coords - Config["Gamemaster"]["InteriorCoords"]) < 15 then
                SetTimeout(1000, function()
                    Shared.Events:ToClient(xPlayer.source, Enums.Gamemaster.GotoExterior, Exit, Heading)
                end)
            else
                xPlayer.showNotification("Vous etes trop loin de la sortie")
            end
        
        end
    end
end)

Shared.Events:OnNet(Enums.Gamemaster.SpawnVehicle, function(xPlayer, Label, Model)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name == Config["Gamemaster"]["RequiredJob"]) then

            local Player = GetPlayerPed(xPlayer.source)
            local Coords = GetEntityCoords(Player)
            local CorrectVehicle = false

            for k, v in pairs(Config["Gamemaster"]["VehList"]) do
                if Label == v.label and Model == v.model then
                    CorrectVehicle = true
                    break
                end
            end

            if #(Coords - Config["Gamemaster"]["GarageInteractPos"]) < 15 then
                local SpawnPos = Config["Gamemaster"]["GarageSpawnPos"]
                local Heading = Config["Gamemaster"]["GarageSpawnHeading"]
                if (IsSpawnPointClear(SpawnPos, 10)) then
                    ESX.SpawnVehicle(Model, SpawnPos, Heading, nil, true, xPlayer, xPlayer.identifier, function(handle)
                        local GaragePos = Config["Gamemaster"]["GarageSpawnPedCoords"]
                        local GarageHeading = Config["Gamemaster"]["GarageSpawnPedHeding"]

                        Shared.Events:ToClient(xPlayer.source, Enums.Gamemaster.GotoGarage, GaragePos, GarageHeading)
                    end);
                else
                    xPlayer.showNotification("Impossible de sortir le véhicule un véhicule bloque la place")
                end
            else
                xPlayer.showNotification("Vous etes trop loin du bureau")
            end
        end
    end
end)

Shared.Events:OnNet(Enums.Gamemaster.SendAnnoucement, function(xPlayer, AnnouncementType)
    if (type(xPlayer) == "table") then
        if (xPlayer.job.name == Config["Gamemaster"]["RequiredJob"]) then

            local jobLabel = xPlayer.job.name_label
            local AnnouncementCategory = AnnouncementType == 1 and "open" or AnnouncementType == 2 and "close" or "recruitment"
            local AnnouncementContent = Config["Gamemaster"]["Annoucement"][AnnouncementCategory]

            showSocietyNotify(xPlayer, xPlayer.job.name, "F.Clinton & Partner", AnnouncementContent, "Informations", 10)
        end
    end
end)
