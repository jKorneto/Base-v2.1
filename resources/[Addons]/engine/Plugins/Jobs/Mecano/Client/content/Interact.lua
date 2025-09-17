local Announcements = {
    List = {
        "Ouverture",
        "Fermeture",
        "Recrutement"
    },
    Index = 1
}

CreateThread(function()
    local main_menu = {}
    local select_vehicle_menu = {}

    for k, v in pairs(Engine["Config"]["Mecano"]["Zones"]) do
        local menuColor = Engine["Config"]["Mecano"]["MenuColors"][v.menuStyle] or { R = 203, G = 202, B = 205, A = 255 }
        local textureName = Engine["Config"]["Mecano"]["MenuStyle"][v.menuStyle] or "interaction_mecano"
        main_menu[k] = Game.InteractSociety:AddMenu(k, "", "Menu Société", "commonmenu", textureName, menuColor)
        select_vehicle_menu[k] = Game.InteractSociety:AddSubMenu(k, main_menu[k], "", "Menu Société", nil, nil, menuColor)

        local selected_flatbed = nil
        local selected_vehicle = nil

        main_menu[k]:IsVisible(function(Items)
            local inService = Client.Mecano:isInService()
            main_menu[k]:SetSubtitle(v.jobLabel)

            if (inService) then
                Items:Button("Annonces Personnalisé", "~r~Cette action est reservé au Patron d'entreprise~s~", {}, true, {
                    onSelected = function()             
                        local success, inputs = pcall(function()
                            return lib.inputDialog("Annonce(s) Mecano", {
                                {type = "input", label = "Tapez votre Annonce", placeholer = "Ici"},
                            })
                        end)
                
                        if not success then
                            return
                        elseif inputs == nil then
                            return
                        end
                
                        local announcements = inputs[1]
        
                        if not announcements or #announcements < 10 then
                            return ESX.ShowNotification("Votre annonces doit contenir minimum 10 caractères")
                        end
        
                        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.sendPersoAnnouncement, announcements)
                    end
                })

                Items:List("Annonces", Announcements.List, Announcements.Index, nil, {}, true, {
                    onListChange = function(Index)
                        Announcements.Index = Index
                    end,
                    onSelected = function()
                        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.sendAnnouncement, Announcements.Index)
                    end
                })

                if (not Client.Player:IsInAnyVehicle()) then
                    Items:Button("Nettoyer le véhicule", nil, {}, true, {
                        onSelected = function()
                            local player, playerDistance = Game.Players:GetClosestPlayer()
                            local vehicle, vehicleDistance = Game.Vehicle:GetClosest(Client.Player:GetCoords(), 10)

                            if (vehicle ~= -1 and vehicleDistance <= 5) then
                                if (player ~= -1 and playerDistance <= 5) then
                                    Shared.Events:ToServer(Engine["Enums"].Mecano.Events.requestClean, GetPlayerServerId(player), NetworkGetNetworkIdFromEntity(vehicle))
                                else
                                    Game.Notification:showNotification("Vous devez être à côté d'une personne pour mettre une facture", false)
                                end
                            else
                                Game.Notification:showNotification("Vous devez être à côté d'un véhicule pour le nettoyer", false)
                            end
                        end
                    })

                    Items:Button("Réparer le véhicule", nil, {}, true, {
                        onSelected = function()
                            local player, playerDistance = Game.Players:GetClosestPlayer()
                            local vehicle, vehicleDistance = Game.Vehicle:GetClosest(Client.Player:GetCoords(), 10)

                            if (vehicle ~= -1 and vehicleDistance <= 5) then
                                if (player ~= -1 and playerDistance <= 5) then
                                    Shared.Events:ToServer(Engine["Enums"].Mecano.Events.requestRepair, GetPlayerServerId(player), NetworkGetNetworkIdFromEntity(vehicle))
                                else
                                    Game.Notification:showNotification("Vous devez être à côté d'une personne pour mettre une facture", false)
                                end
                            else
                                Game.Notification:showNotification("Vous devez être à côté d'un véhicule pour le réparer", false)
                            end
                        end
                    })

                    if (selected_vehicle == nil) then
                        Items:Button("Mettre le véhicule sur le plateau", nil, {}, selected_vehicle == nil, {}, select_vehicle_menu[k])
                    else
                        Items:Button("Retirer le véhicule du plateau", nil, {}, selected_vehicle ~= nil, {
                            onSelected = function()
                                if (selected_vehicle) then
                                    if (DoesEntityExist(selected_vehicle) and IsEntityAVehicle(selected_vehicle)) then
                                        FreezeEntityPosition(selected_vehicle, false)
                                        DetachEntity(selected_vehicle, true, true)

                                        local flatbedCoords = GetEntityCoords(selected_flatbed)
                                        local flatbedHeading = GetEntityHeading(selected_flatbed)
                                        local newCoords = GetOffsetFromEntityInWorldCoords(selected_flatbed, 0.0, -10.0, 0.0)

                                        SetEntityCoords(selected_vehicle, newCoords)
                                    end

                                    selected_vehicle = nil
                                    selected_flatbed = nil
                                end
                            end
                        })

                        if (not DoesEntityExist(selected_vehicle) and not IsEntityAVehicle(selected_vehicle)) then
                            selected_vehicle = nil
                            selected_flatbed = nil
                        end
                    end

                    Items:Button("Ouvrir le véhicule", nil, {}, true, {
                        onSelected = function()
                            local vehicle, vehicleDistance = Game.Vehicle:GetClosest(Client.Player:GetCoords(), 10)

                            if (vehicle ~= -1 and vehicleDistance <= 5) then
                                Shared.Events:ToServer(Engine["Enums"].Mecano.Events.requestUnlockVehicle, NetworkGetNetworkIdFromEntity(vehicle))
                            else
                                Game.Notification:showNotification("Vous devez être à côté d'un véhicule pour l'ouvrir", false)
                            end
                        end
                    })

                    Items:Button("Faire une facture", nil, {}, true, {
                        onSelected = function()
                            local player, playerDistance = Game.Players:GetClosestPlayer()

                            if (player ~= -1 and playerDistance <= 5) then
                                local imput = Game.ImputText:KeyboardImput("Facture", {
                                    {type = "number", placeholder = "Montant", min = 1, max = 1000000, required = true},
                                    {type = "input", placeholder = "Raison", required = true}
                                })

                                if (imput ~= nil) then
                                    if (Game.ImputText:InputIsValid(tostring(imput[1]), "number")) then
                                        if (tonumber(imput[1]) >= 1 and tonumber(imput[1]) <= 1000000) then
                                            Shared.Events:ToServer(Engine["Enums"].Mecano.Events.sendCustomBill, GetPlayerServerId(player), tonumber(imput[1]), tostring(imput[2]))
                                        else
                                            Game.Notification:showNotification("Veuillez saisir une valeur entre %s et %s", false, 1, 1000000)
                                        end
                                    else
                                        Game.Notification:showNotification("Veuillez entrer un nombre valide", false)
                                    end
                                else
                                    Game.Notification:showNotification("Veuillez entrer un nombre valide", false)
                                end
                            else
                                Game.Notification:showNotification("Vous devez être à côté d'une personne pour faire une facture", false)
                            end
                        end
                    })

                    if (Client.Player:GetJob().grade_name == "boss") then
                        Items:Button("Gérer le pourcentage", "Permet de modifier le pourcentage pris sur les modifications de véhicule", {}, true, {
                            onSelected = function()
                                if (Engine["Config"]["Mecano"]["Zones"][Client.Player:GetJob().name]) then
                                    local minimum = Engine["Config"]["Mecano"]["Zones"][Client.Player:GetJob().name].minPercentage
                                    local maximum = Engine["Config"]["Mecano"]["Zones"][Client.Player:GetJob().name].maxPercentage
                                    local imput = Game.ImputText:KeyboardImput("Gérer le pourcentage", {
                                        {type = "number", placeholder = "Pourcentage", min = minimum, max = maximum, required = true}
                                    })

                                    if (imput ~= nil) then
                                        if (Game.ImputText:InputIsValid(tostring(imput[1]), "number")) then
                                            if (tonumber(imput[1]) >= minimum and tonumber(imput[1]) <= maximum) then
                                                Shared.Events:ToServer(Engine["Enums"].Mecano.Events.setPercentage, tonumber(imput[1]))
                                            else
                                                Game.Notification:showNotification("Veuillez saisir un pourcentage entre %s%% et %s%%", false, minimum, maximum)
                                            end
                                        else
                                            Game.Notification:showNotification("Veuillez entrer un nombre valide", false)
                                        end
                                    else
                                        Game.Notification:showNotification("Veuillez entrer un nombre valide", false)
                                    end
                                else
                                    Game.Notification:showNotification("Une erreur est survenue", false)
                                end
                            end
                        })
                    end
                end
            else
                Items:Separator("Vous n'êtes pas en service")
            end
        end)

        select_vehicle_menu[k]:IsVisible(function(Items)
            select_vehicle_menu[k]:SetSubtitle(v.jobLabel)

            Items:Button("Sélectionner le plateau", nil, {RightLabel = GetVehicleNumberPlateText(selected_flatbed) or "Aucun vehicle sélectionné"}, true, {
                onSelected = function()
                    local vehicle, vehicleDistance = Game.Vehicle:GetClosest(Client.Player:GetCoords(), 10)

                    if (vehicle ~= -1 and vehicleDistance <= 5) then
                        if (Engine["Config"]["Mecano"]["Zones"][Client.Player:GetJob().name]) then
                            local vehicleModel = GetEntityModel(vehicle)
                            local flatbedModel = GetHashKey(Engine["Config"]["Mecano"]["Zones"][Client.Player:GetJob().name].flatbedModel)

                            if (vehicleModel == flatbedModel) then
                                selected_flatbed = vehicle
                            else
                                Game.Notification:showNotification("Vous devez sélectionner un véhicule avec plateau", false)
                            end
                        else
                            Game.Notification:showNotification("Une erreur est survenue", false)
                        end
                    else
                        Game.Notification:showNotification("Vous devez être à côté d'un véhicule pour le sélectionner", false)
                    end
                end
            })

            Items:Button("Selectionner le véhicule", nil, {RightLabel = GetVehicleNumberPlateText(selected_vehicle) or "Aucun vehicle sélectionné"}, true, {
                onSelected = function()
                    local vehicle, vehicleDistance = Game.Vehicle:GetClosest(Client.Player:GetCoords(), 10)

                    if (vehicle ~= -1 and vehicleDistance <= 5) then
                        local vehicleModel = GetEntityModel(vehicle)
                        local flatbedModel = GetHashKey(Engine["Config"]["Mecano"]["Zones"][Client.Player:GetJob().name].flatbedModel)

                        if (vehicleModel ~= flatbedModel) then
                            selected_vehicle = vehicle
                        else
                            Game.Notification:showNotification("Vous pouvez pas sélectionner un plateau comme véhicule", false)
                        end
                    else
                        Game.Notification:showNotification("Vous devez être à côté d'un véhicule pour le sélectionner", false)
                    end
                end
            })

            Items:Button("Mettre le vehicle sur le plateau", nil, {}, selected_flatbed ~= nil and selected_vehicle ~= nil, {
                onSelected = function()
                    if (selected_flatbed and selected_vehicle) then
                        if (DoesEntityExist(selected_vehicle) and IsEntityAVehicle(selected_vehicle)) then
                            local flatbedCoords = GetEntityCoords(selected_flatbed)
                            local vehicleCoords = GetEntityCoords(selected_vehicle)
                            local distance = #(vehicleCoords - flatbedCoords)

                            if (distance < 15) then
                                AttachEntityToEntity(selected_vehicle, selected_flatbed, GetEntityBoneIndexByName(selected_flatbed, "chassis"),
                                0.0, -2.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                FreezeEntityPosition(selected_vehicle, true)
                                RageUI.GoBack()
                            else
                                Game.Notification:showNotification("Le véhicule est trop loin du plateau", false)
                            end
                        end
                    end
                end
            })
        end)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receiveClean, function(networkID)
    if (type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)

        if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
            local ped = Client.Player:GetPed()
            local vehicleLeftPos = GetOffsetFromEntityInWorldCoords(vehicle, -2.0, 0.0, 0.0)

            TaskGoStraightToCoord(ped, vehicleLeftPos.x, vehicleLeftPos.y, vehicleLeftPos.z, 500.0, 2000, 121.89, 3.0)

            SetTimeout(2000, function()
                if (#(Client.Player:GetCoords() - vehicleLeftPos) > 1.0) then
                    SetEntityCoords(ped, vehicleLeftPos.x, vehicleLeftPos.y, vehicleLeftPos.z)
                end

                TaskTurnPedToFaceEntity(ped, vehicle, 1000)
                Wait(1000)
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MAID_CLEAN', 0, true)

                HUDProgressBar("Nettoyage du véhicule...", 15, function()
                    Client.Player:ClearTasks()
                    Client.Player:ClearAreaOfObjects(10.0)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    Game.Notification:showNotification("Le véhicule a été nettoyer", false)
                end)
            end)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receiveRepair, function(networkID)
    if (type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)

        if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
            local ped = Client.Player:GetPed()
            local vehicleFrontPos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 3.0, 0.0)

            TaskGoStraightToCoord(ped, vehicleFrontPos.x, vehicleFrontPos.y, vehicleFrontPos.z, 500.0, 2000, 121.89, 3.0)

            SetTimeout(2000, function()
                if (#(Client.Player:GetCoords() - vehicleFrontPos) > 1.0) then
                    SetEntityCoords(ped, vehicleFrontPos.x, vehicleFrontPos.y, vehicleFrontPos.z)
                end

                TaskTurnPedToFaceEntity(ped, vehicle, 1000)
                Wait(1000)
                TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)

                HUDProgressBar("Réparation du véhicule...", 15, function()
                    Client.Player:ClearTasks()
                    Client.Player:ClearAreaOfObjects(10.0)

                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleFixed(vehicle)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    SetVehicleBodyHealth(vehicle, 1000.0)
                    SetVehiclePetrolTankHealth(vehicle, 1000.0)
                    SetVehicleEngineTemperature(vehicle, 10.0)
            
                    for i = 0, 4 do
                        SetVehicleTyreFixed(vehicle, i)
                    end

                    Game.Notification:showNotification("Le véhicule a été réparé", false)
                end)
            end)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receiveUnlockVehicle, function(networkID)
    if (type(networkID) == "number") then
        local vehicle = NetworkGetEntityFromNetworkId(networkID)

        if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
            local ped = Client.Player:GetPed()
            local vehicleLeftPos = GetOffsetFromEntityInWorldCoords(vehicle, -2.0, 0.0, 0.0)

            TaskGoStraightToCoord(ped, vehicleLeftPos.x, vehicleLeftPos.y, vehicleLeftPos.z, 500.0, 2000, 121.89, 3.0)

            SetTimeout(2000, function()
                if (#(Client.Player:GetCoords() - vehicleLeftPos) > 1.0) then
                    SetEntityCoords(ped, vehicleLeftPos.x, vehicleLeftPos.y, vehicleLeftPos.z)
                end

                TaskTurnPedToFaceEntity(ped, vehicle, 1000)
                Wait(1000)
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
                HUDProgressBar("Crochetage du véhicule...", 15, function()
                    Shared.Events:ToServer(Engine["Enums"].Mecano.Events.requestSyncUnlockVehicle, NetworkGetNetworkIdFromEntity(vehicle))
                    Client.Player:ClearTasks()
                    Client.Player:ClearAreaOfObjects(10.0)
                    Game.Notification:showNotification("Le véhicule a été déverrouillé", false)
                end)
            end)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receivePercentage, function(percentage)
    if (type(percentage) == "number") then
        Client.Mecano:setPercentage(percentage)
    end
end)
