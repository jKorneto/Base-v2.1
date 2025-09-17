local Timeout = false

CreateThread(function()

    local HarvestZone = Game.Zone("HarvestZone")

    HarvestZone:Start(function()
        HarvestZone:SetTimer(1000)
        HarvestZone:SetCoords(Config["Meth"]["Recolte"]) 

        HarvestZone:IsPlayerInRadius(10.0, function()
            HarvestZone:SetTimer(0)
            local job = Client.Player:GetJob()

            if job ~= "police" then 
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récolter de la Meth")

                HarvestZone:IsPlayerInRadius(10.0, function()
                    HarvestZone:KeyPressed("E", function()
                        if not Timeout then
                            Timeout = true
                            Drugs:StartHarvestAnim("Meth")
                            SetTimeout(2000, function()
                                Timeout = false
                            end)
                        end
                    end)
                end)
            end
        end)
    end)

    local ProcessZone = Game.Zone("ProcessZone")

    ProcessZone:Start(function()
        ProcessZone:SetTimer(1000)
        ProcessZone:SetCoords(Config["Meth"]["Traitement"]) 

        ProcessZone:IsPlayerInRadius(5.0, function()
            ProcessZone:SetTimer(0)
            local job = Client.Player:GetJob()

            if job ~= "police" then 
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter votre Meth")

                ProcessZone:IsPlayerInRadius(5.0, function()
                    ProcessZone:KeyPressed("E", function()
                        if not Timeout then
                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                Timeout = true
                                Drugs:StartProcesstAnim("Meth")
                                SetTimeout(2000, function()
                                    Timeout = false
                                end)
                            else
                                ESX.ShowNotification("Vous ne pouvez pas traiter en voiture")
                            end
                        end
                    end)
                end)
            end
        end)
    end)

end)