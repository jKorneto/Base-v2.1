local DjMenu = RageUI.AddMenu("", "Faites vos actions")
local MusicStarted = false

DjMenu:SetSpriteBanner("commonmenu", "interaction_legal")
DjMenu:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

CreateThread(function()
    for k, v in pairs(Config["Bar"]["List"]) do
        local DjZone = Game.Zone("DjZone#"..k, {
            job = k
        })

        DjZone:Start(function()
            DjZone:SetTimer(1000)
            DjZone:SetCoords(v.djTablePos)

            DjZone:IsPlayerInRadius(3.0, function()
                DjZone:SetTimer(0)
                DjZone:Marker()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                DjZone:IsPlayerInRadius(5.0, function()

                    DjZone:KeyPressed("E", function()
                        DjMenu:Toggle()
                    end)

                end, false, false)
            end, false, false)

            DjZone:RadiusEvents(5.0, nil, function()
                DjMenu:Close()
            end)
        end)
    end
end)

DjMenu:IsVisible(function(Items)
    Items:Button("Changer de musique", nil, {}, true, {
        onSelected = function()
            local playerJob = ESX.GetPlayerData().job.name
            local jobConfig = Config["Bar"]["List"][playerJob]
            
            if jobConfig then
                local Zone = jobConfig.djTablePos
                
                local success, input = pcall(function()
                    return lib.inputDialog("URL de la Musique", {
                        {type = "input", label = "URL de la musique (YouTube uniquement)", maxLength = 100}
                    })
                end)
    
                if not success or input == nil then
                    Game.Notification:showNotification("Une erreur s'est produite ou le dialogue a été annulé")
                    return
                end
    
                local Music = input[1]
    
                TriggerServerEvent("iZeyy:Bar:changeMusic", Music, Zone)
            else
                Game.Notification:showNotification("Job non trouvé dans la configuration")
            end
        end
    })
    if MusicStarted then
        Items:Button("Arrêter la musique", nil, {}, MusicStarted, {
            onSelected = function()
                TriggerServerEvent("iZeyy:Bar:stopMusic")
                MusicStarted = false
            end
        })
        Items:Button("Volume de la musique", nil, {}, MusicStarted, {
            onSelected = function()
                local success, input = pcall(function()
                    return lib.inputDialog("Deposer", {
                        {type = "number", label = "Indiquez un montant", placeholder = "entre 0 en 100"},
                    })
                end)
                
                if not success then
                    return
                elseif input == nil then
                    ESX.ShowNotification("volume invalide")
                else
                    local amount = input[1]
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("volume invalide")
                    else
                        amount = tonumber(amount)
                        if amount >= 0 and amount <= 100 then
                            local volume = amount / 100
                            TriggerServerEvent("core:music:volume", volume)
                        else
                            ESX.ShowNotification("Le volume doit être entre 0 et 100")
                        end
                    end
                end
            end
        })
        
    end
end)

RegisterNetEvent("iZeyy:Bar:playMusic", function(UrlMusic, Zone, ZoneMusicId)
    local ZoneMusicId = tostring(ZoneMusicId)
    exports["xsound"]:PlayUrlPos(ZoneMusicId, UrlMusic, 1.0, Zone)
    exports["xsound"]:Distance(ZoneMusicId, 25.0)
    MusicStarted = true
end)

RegisterNetEvent("iZeyy:Bar:stopMusic", function(ZoneMusicId)
    local ZoneMusicId = tostring(ZoneMusicId)
    exports["xsound"]:Destroy(ZoneMusicId)
    MusicStarted = false
end)

RegisterNetEvent("core:music:setvolume", function(MusicId, masterVol)
    local MusicId = tostring(MusicId)
    local masterVol = tonumber(masterVol)

    if masterVol == nil then
        return
    end

    if MusicStarted then
        exports["xsound"]:setVolume(MusicId, masterVol)
    end
end)
