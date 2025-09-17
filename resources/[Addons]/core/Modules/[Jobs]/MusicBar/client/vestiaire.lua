local Vestiaire = RageUI.AddMenu("", "Faites vos actions")

Vestiaire:SetSpriteBanner("commonmenu", "interaction_legal")
Vestiaire:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

local function SetUniform(type)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Bar"]["Clothes"][type].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Bar"]["Clothes"][type].female)
        end
    end)
end


CreateThread(function()
    for k, v in pairs(Config["Bar"]["List"]) do
        local VestiaireZone = Game.Zone("VestiaireZone#"..k, {
            job = k
        })

        VestiaireZone:Start(function()
            VestiaireZone:SetTimer(1000)
            VestiaireZone:SetCoords(v.vestiairePos)

            VestiaireZone:IsPlayerInRadius(3.0, function()
                VestiaireZone:SetTimer(0)
                VestiaireZone:Marker()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                VestiaireZone:IsPlayerInRadius(5.0, function()

                    VestiaireZone:KeyPressed("E", function()
                        Vestiaire:Toggle()
                    end)

                end, false, false)
            end, false, false)

            VestiaireZone:RadiusEvents(5.0, nil, function()
                Vestiaire:Close()
            end)
        end)
    end

    Vestiaire:IsVisible(function(Items)
        local Job = Client.Player:GetJob().name
        
        Items:Button("Prendre votre Service", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Vestiaire:Close()
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("iZeyy:job:takeService", Job, true)
                SetUniform("service")
                InService = true
            end
        })
        Items:Button("Prendre la tenue de Danse", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Vestiaire:Close()
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("iZeyy:job:takeService", Job, true)
                SetUniform("danse")
                InService = true
            end
        })
        Items:Button("Fin de service", nil, {}, InService, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Vestiaire:Close()
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
                TriggerServerEvent("iZeyy:job:takeService", Job, false)
                InService = false
            end 
        })
    end)

end)