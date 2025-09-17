-- local Timeout = false

-- CreateThread(function()

--     for k, v in ipairs(Config["Drugs"]["Resell"]) do
    
--         Game.Peds:Spawn(GetHashKey(v.pedHash), v.pedPos, v.pedHeading, true, true, function(ped)
--             TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
--         end)
    
--         local ResellZone = Game.Zone("ResellZone")

--         ResellZone:Start(function()
--             ResellZone:SetTimer(1000)
--             ResellZone:SetCoords(v.pedPos) 
    
--             ResellZone:IsPlayerInRadius(5.0, function()
--                 ResellZone:SetTimer(0)
--                 local job = Client.Player:GetJob()
--                 local playerPed = Client.Player:GetPed()
--                 local playerPos = GetEntityCoords(playerPed)

--                 if job ~= "police" then 
--                     ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre votre drogue")
    
--                     ResellZone:IsPlayerInRadius(5.0, function()
--                         ResellZone:KeyPressed("E", function()
--                             if (not Timeout) then
--                                 if not IsPedInAnyVehicle(PlayerPedId(), false) then
--                                     Timeout = true
--                                     Drugs:Ressel(playerPos)
--                                     SetTimeout(1000, function()
--                                         Timeout = false
--                                     end)
--                                 else
--                                     ESX.ShowNotification("Vous ne pouvez pas vendre en voiture")
--                                 end
--                             end
--                         end)
--                     end)
--                 end
--             end)
--         end)

--     end

-- end)