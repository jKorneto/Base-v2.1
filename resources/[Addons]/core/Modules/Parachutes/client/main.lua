local main_menu = RageUI.AddMenu("", "Faites vos actions")


CreateThread(function()
    for k, v in pairs(Config["Parachute"]["Pos"]) do
        local ParachuteZone = Game.Zone("ParachuteZone_" .. k)
        
        ParachuteZone:Start(function()
            ParachuteZone:SetTimer(1000)
            ParachuteZone:SetCoords(v.pos)
    
            ParachuteZone:IsPlayerInRadius(10.0, function()
                ParachuteZone:SetTimer(0)
                ParachuteZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    
                    ParachuteZone:KeyPressed("E", function()
                        main_menu:Toggle()
                    end)
                end)    
            end)
        end)
    
        local Blip = AddBlipForCoord(v.pos)
        SetBlipSprite(Blip, 550)
        SetBlipScale(Blip, 0.4)
        SetBlipColour(Blip, 24)
        SetBlipDisplay(Blip, 4)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Saut en Parachute")
        EndTextCommandSetBlipName(Blip)
    
        local Model = GetHashKey(Config["Parachute"]["PedModel"])
        RequestModel(Model)
        while not HasModelLoaded(Model) do Wait(1) end
        local Ped = CreatePed(4, Model, v.pos, v.heading, false, true)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end
end)

main_menu:IsVisible(function(Items)
    local PlayerPos = GetEntityCoords(PlayerPedId())
    Items:Separator("Zone de " ..GetStreetNameFromHashKey(GetStreetNameAtCoord(PlayerPos.x, PlayerPos.y, PlayerPos.Z)))
    Items:Line()
    Items:Button("Achetez un Parachute", nil, { RightLabel = "Voir le Prix →"}, true, {
        onSelected = function()
            TriggerServerEvent("iZeyy:Parachute:HasMoney")
        end
    })
end)

RegisterNetEvent("iZeyy:Parachute:SetTint", function()
    SetPedParachuteTintIndex(PlayerPedId(), 6)
    main_menu:Close()
end)