local main_menu = RageUI.AddMenu("", "Faites vos actions")

CreateThread(function()

    local MoneyWashZone = Game.Zone("MoneyWashZone")

    MoneyWashZone:Start(function()
        MoneyWashZone:SetTimer(1000)
        MoneyWashZone:SetCoords(Config["MoneyWash"]["Pos"]) 
        
        MoneyWashZone:IsPlayerInRadius(10.0, function()
            MoneyWashZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name
    
            for k, v in pairs(Config["MoneyWash"]["Job"]) do
                if job ~= v then
                    MoneyWashZone:Marker()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
        
                    MoneyWashZone:IsPlayerInRadius(3.0, function()
                        MoneyWashZone:KeyPressed("E", function()
                            main_menu:Toggle()
                        end)
                    end)
            
                    MoneyWashZone:RadiusEvents(3.0, nil, function()
                        main_menu:Close()
                    end)
                end
            end
        end)
    end) 
    

    local Model = GetHashKey("s_m_m_ups_02")
    RequestModel(Model)
    while not HasModelLoaded(Model) do
        Wait(10)
    end
    local Ped = CreatePed(9, Model, Config["MoneyWash"]["PedPos"], Config["MoneyWash"]["PedHeading"], false, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)
    FreezeEntityPosition(Ped, true)

end)

main_menu:IsVisible(function(Items)
    Items:Button("Blanchir votre argent", nil, {RightLabel = Config["MoneyWash"]["Pourcent"]}, true, {
        onSelected = function()
            local success, input = pcall(function()
                return lib.inputDialog("Blanchiment", {
                    {type = "number", label = "Montant à blanchir ?", placeholder = "250K$ Minimum"},
                })
            end)

            if not success then
                return
            elseif input == nil then
                ESX.ShowNotification("Entrez un montant valide")
            else
                local amount = input[1]
                TriggerServerEvent("iZeyy:Washmoney:CheckMoney", amount)
            end
        end
    })
end)

RegisterCommand("getpos", function()
    local playerpos = GetEntityCoords(PlayerPedId())
    local playerheading = GetEntityHeading(PlayerPedId())
    print(playerpos, playerheading)
end)