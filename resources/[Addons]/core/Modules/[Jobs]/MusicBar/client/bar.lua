local BarMenu = RageUI.AddMenu("", "Faites vos actions")

BarMenu:SetSpriteBanner("commonmenu", "interaction_legal")
BarMenu:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

CreateThread(function()
    for k, v in pairs(Config["Bar"]["List"]) do
        local BarZone = Game.Zone("BarZone#"..k, {
            job = k
        })

        BarZone:Start(function()
            BarZone:SetTimer(1000)
            BarZone:SetCoords(v.barPos)

            BarZone:IsPlayerInRadius(3.0, function()
                BarZone:SetTimer(0)
                BarZone:Marker()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                BarZone:IsPlayerInRadius(5.0, function()

                    BarZone:KeyPressed("E", function()
                        BarMenu:Toggle()
                    end)

                end, false, false)
            end, false, false)

            BarZone:RadiusEvents(5.0, nil, function()
                BarMenu:Close()
            end)
        end)
    end
end)

BarMenu:IsVisible(function(Items)
    for k, v in pairs(Config["Bar"]["List"]) do
        local barItems = v.items
        if type(barItems) == "table" then
            for itemKey, itemValue in pairs(barItems) do
                Items:Button(itemValue.label, nil, { RightLabel = itemValue.price * 2 .."$"}, true, {
                    onSelected = function()
                        local ClosetPlayer, Distance = ESX.Game.GetClosestPlayer()
                        if ClosetPlayer == -1 or Distance > 10.0 then
                            ESX.ShowNotification("Aucun joueur à proximité")
                        else
                            local success, input = pcall(function()
                                return lib.inputDialog("Montant", {
                                    {type = "number", label = "Quantité"},
                                })
                            end)
                            
                            if not success then
                                return
                            elseif input == nil or input[1] == nil then
                                ESX.ShowNotification("Veuillez entrer un montant valide")
                            else
                                local Count = tostring(input[1])
                                if (tonumber(Count) > 0) then
                                    local TotalPrice = itemValue.price * tonumber(Count)
                                    TriggerServerEvent("iZeyy:Bar:buyItems", GetPlayerServerId(ClosetPlayer), itemKey, tonumber(Count), TotalPrice)
                                else
                                    ESX.ShowNotification("Veuillez entrer un montant supérieur à 0")
                                end
                            end
                            
                        end
                    end
                })
            end
        end
    end
end)