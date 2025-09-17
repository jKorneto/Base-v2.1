local main_menu = mecanoStorage:Get("cloak_menu")
local take_outfit_menu = mecanoStorage:Get("take_outfit_menu")
local remove_outfit_menu = mecanoStorage:Get("remove_outfit_menu")

main_menu:IsVisible(function(Items)
    local inService = Client.Mecano:isInService()
    local label = inService and "Arreter son service" or "Commencer son service"

    Items:Button(label, nil, {}, true, {
        onSelected = function()
            Client.Mecano:setInService(not Client.Mecano:isInService())
        end
    })

    Items:Button("Prendre une tenue", nil, {}, inService, {
        onSelected = function()
            local player = Client.Player:GetPed()
            local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"
            Client.Mecano:requestClothes(sex)
        end
    }, take_outfit_menu)

    Items:Button("Reprendre sa tenue", nil, {}, inService, {
        onSelected = function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    })

    Items:Line()

    Items:Button("Ajouter une tenue", "La tenue ajouter sera votre tenue actuelle", {}, inService, {
        onSelected = function()
            local outfitName = Game.ImputText:KeyboardImput("Nom de la tenue", {
                {type = "input", placeholder = "Nom", required = true}
            })

            if (outfitName ~= nil) then
                if (Game.ImputText:InputIsValid(outfitName[1], "string")) then
                    if (string.len(outfitName[1]) <= 25) then
                        local player = Client.Player:GetPed()
                        local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"

                        Client.Mecano:addClothes(tostring(outfitName[1]), sex)
                    else
                        Game.Notification:showNotification("Le nom de la tenue ne peut pas dépasser 25 caractères", false)
                    end
                else
                    Game.Notification:showNotification("Veuillez entrer un nom valide", false)
                end
            else
                Game.Notification:showNotification("Veuillez entrer un nom valide", false)
            end
        end
    })

    Items:Button("Retirer une tenue", nil, {}, inService, {
        onSelected = function()
            local player = Client.Player:GetPed()
            local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"
            Client.Mecano:requestClothes(sex)
        end
    }, remove_outfit_menu)
end)

take_outfit_menu:IsVisible(function(Items)
    local clothes = Client.Mecano:getClothes()

    if (type(clothes) == "table") then
        if (next(clothes) ~= nil) then
            for k, v in pairs(clothes) do
                Items:Button(k, nil, {}, true, {
                    onSelected = function()
                        local player = Client.Player:GetPed()
                        local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"

                        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.takeOutfit, sex, k)
                    end
                })
            end
        else
            Items:Separator("Aucune tenue disponible")
        end
    else
        Items:Separator("Chargement des tenues...")
    end
end)

remove_outfit_menu:IsVisible(function(Items)
    local clothes = Client.Mecano:getClothes()

    if (type(clothes) == "table") then
        if (next(clothes) ~= nil) then
            for k, v in pairs(clothes) do
                Items:Button(k, nil, {}, true, {
                    onSelected = function()
                        local Confirmation = Game.ImputText:KeyboardImput("Confirmation", {
                            {type = "input", placeholder = "Mettre \"oui\" pour confirmer", required = true}
                        })

                        if (Game.ImputText:InputIsValid(Confirmation[1], "string")) then
                            if (Confirmation[1]:lower() == "oui") then
                                local player = Client.Player:GetPed()
                                local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"

                                Client.Mecano:removeClothes(k, sex)
                            end
                        end
                    end
                })
            end
        else
            Items:Separator("Aucune tenue disponible")
        end
    else
        Items:Separator("Chargement des tenues...")
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receiveClothes, function(clothes)
    if (type(clothes) == "table") then
        Client.Mecano:setClothes(clothes)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receiveRemoveClothes, function(name)
    if (type(name) == "string") then
        Client.Mecano:removeClothesByName(name)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.receiveOutfit, function(outfit)
    if (type(outfit) == "table") then
        Client.Mecano:takeOutfit(outfit)
    end
end)

CreateThread(function()
    local mecanoCloakZone = Engine["Config"]["Mecano"]["Zones"]

    for k, v in pairs(mecanoCloakZone) do
        local cloakZoneCoords = v.cloakRoom
        local cloakZone = Game.Zone("mecanoCloakZone-"..k, {
            job = v.jobName
        })

        cloakZone:Start(function()
            cloakZone:SetTimer(1000)
            cloakZone:SetCoords(cloakZoneCoords)

            cloakZone:IsPlayerInRadius(5.0, function()
                cloakZone:SetTimer(0)
                cloakZone:Marker()

                cloakZone:IsPlayerInRadius(3.0, function()
                    Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire")

                    cloakZone:KeyPressed("E", function()
                        Client.Mecano:setMenuStyle(v.menuStyle)
                        main_menu:Toggle()
                    end)

                    end, false, false)
            end, false, false)

            cloakZone:RadiusEvents(3.0, nil, function()
                main_menu:Close()
            end)
        end)
    end
end)