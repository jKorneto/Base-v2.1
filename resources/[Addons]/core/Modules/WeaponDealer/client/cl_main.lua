-- local vda1_weapon_menu = RageUI.AddMenu("", "Vente d'armes illégal")
-- local vda2_weapon_menu = RageUI.AddMenu("", "Vente d'armes illégal")

-- local cam = nil 
-- local validWeapon = "None"
-- local timeOutMenu = false

-- function CreateVdaCam()
--     cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
--     SetCamCoord(cam, 1207.693481, -2286.894287, -47.999222)
--     SetCamRot(cam, -20.0, 0.0, 133.0, 2)
--     SetCamActive(cam, true)  
--     RenderScriptCams(true, false, 0, true, true)

--     local player = Client.Player:GetPed()
--     local dict = "anim@heists@heist_corona@team_idles@male_a"
--     local anim = "idle"

--     if (player) then
--         Game.Streaming:RequestAnimDict(dict, function()
--             FreezeEntityPosition(ped, true)
--             TaskPlayAnim(player, dict, anim, 8.0, -8, -1, 49, 0, true, true, true)
--         end)
--     end
-- end

-- function DestroyVdaCam()
--     if cam then
--         RenderScriptCams(false, false, 0, true, true)
--         SetCamActive(cam, false)
--         DestroyCam(cam, false)
--         cam = nil
--         local player = Client.Player:GetPed()

--         if (player) then
--             Client.Player:ClearTasks()
--             FreezeEntityPosition(player, false)
--         end
--     end
-- end


-- CreateThread(function()

--     local VdaEnter1 = Game.Zone("VdaEnter1")

--     VdaEnter1:Start(function()
--         VdaEnter1:SetTimer(1000)
--         VdaEnter1:SetCoords(Config["Vda"]["Coords1"]) 

--         VdaEnter1:IsPlayerInRadius(2.5, function()
--             VdaEnter1:SetTimer(0)
--             VdaEnter1:Marker()
--             local job = Client.Player:GetJob()

--             if job ~= "police" then 
--                 ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

--                 VdaEnter1:IsPlayerInRadius(2.5, function()
--                     VdaEnter1:KeyPressed("E", function()
--                         Shared.Events:ToServer(Enums.Vda.CheckAcces)
--                     end)
--                 end)
--             end
--         end)
--     end)

--     local VdaEnter2 = Game.Zone("VdaEnter2")

--     VdaEnter2:Start(function()
--         VdaEnter2:SetTimer(1000)
--         VdaEnter2:SetCoords(Config["Vda"]["Coords2"]) 

--         VdaEnter2:IsPlayerInRadius(2.5, function()
--             VdaEnter2:SetTimer(0)
--             VdaEnter2:Marker()
--             local job = Client.Player:GetJob()

--             if job ~= "police" then 
--                 ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

--                 VdaEnter2:IsPlayerInRadius(2.5, function()
--                     VdaEnter2:KeyPressed("E", function()
--                         Shared.Events:ToServer(Enums.Vda.CheckAcces)
--                     end)
--                 end)
--             end
--         end)
--     end)

--     local VdaCraft = Game.Zone("VdaCraft")

--     VdaCraft:Start(function()
--         VdaCraft:SetTimer(1000)
--         VdaCraft:SetCoords(Config["Vda"]["CraftPos"]) 

--         VdaCraft:IsPlayerInRadius(2.5, function()
--             VdaCraft:SetTimer(0)
--             local job = Client.Player:GetJob()

--             if job ~= "police" then 
--                 ESX.ShowHelpNotification("pour voir les armes")

--                 VdaCraft:IsPlayerInRadius(2.5, function()
--                     VdaCraft:KeyPressed("E", function()
--                         Shared.Events:ToServer(Enums.Vda.CheckMenuAcces)
--                     end)
--                 end)
--             end
--         end)
--     end)

--     local VdaExit = Game.Zone("VdaExit")

--     VdaExit:Start(function()
--         VdaExit:SetTimer(1000)
--         VdaExit:SetCoords(Config["Vda"]["ExitCoords"]) 

--         VdaExit:IsPlayerInRadius(2.5, function()
--             VdaExit:SetTimer(0)
--             VdaExit:Marker()
--             local job = Client.Player:GetJob()

--             if job ~= "police" then 
--                 ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

--                 VdaExit:IsPlayerInRadius(2.5, function()
--                     VdaExit:KeyPressed("E", function()
--                         -- local player = Client.Player:GetPed()
--                         -- Elevator:Teleport(player, Config["Vda"]["Coords1"], 124.92951965332)
--                         Shared.Events:ToServer(Enums.Vda.Exit)
--                     end)
--                 end)
--             end
--         end)
--     end)

--     vda1_weapon_menu:IsVisible(function(Items)
--         for k, v in pairs(Config["Vda"]["1"]) do
--             Items:Button(v.label, nil, { RightLabel = Shared.Math:GroupDigits(v.price .. "~g~$") }, not timeOutMenu, {
--                 onSelected = function()
--                     Shared.Events:ToServer(Enums.Vda.Craft1, v.name, v.label, v.price)
--                 end
--             })
--         end
--     end, nil, function()
--         DestroyVdaCam()
--     end)

--     vda2_weapon_menu:IsVisible(function(Items)
--         for k, v in pairs(Config["Vda"]["2"]) do
--             Items:Button(v.label, nil, { RightLabel = Shared.Math:GroupDigits(v.price .. "~g~$") }, not timeOutMenu, {
--                 onSelected = function()
--                     Shared.Events:ToServer(Enums.Vda.Craft2, v.name, v.label, v.price)
--                 end
--             })
--         end
--     end, nil, function()
--         DestroyVdaCam()
--     end)

-- end)

-- local function SetClosable(boolean)
--     vda1_weapon_menu:SetClosable(boolean)
--     vda2_weapon_menu:SetClosable(boolean)
-- end

Shared.Events:OnNet(Enums.Vda.CraftingWeapon, function()
    Game.Streaming:RequestAnimDict("weapons@first_person@aim_idle@p_m_zero@light_machine_gun@shared@fidgets@c", function()
        timeOutMenu = true
        SetClosable(false)
        SetTimeout(30000, function()
            timeOutMenu = false
            SetClosable(true)
        end)
        TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_idle@p_m_zero@light_machine_gun@shared@fidgets@c", "fidget_low_loop", 8.0, -8.0, -1, 33, 0, false, false, false)
        HUDProgressBar("Armes en cours de production...", 30, function()
            local player = Client.Player:GetPed()
            local dict = "anim@heists@heist_corona@team_idles@male_a"
            local anim = "idle"
        
            if (player) then
                Game.Streaming:RequestAnimDict(dict, function()
                    FreezeEntityPosition(ped, true)
                    TaskPlayAnim(player, dict, anim, 8.0, -8, -1, 49, 0, true, true, true)
                end)
            end
        end)
    end)
end)

-- Shared.Events:OnNet(Enums.Vda.SetCoords, function(coords)
--     local player = Client.Player:GetPed()
--     local pos = vector3(coords)
--     Elevator:Teleport(player, pos, 0.0)
-- end)

-- Shared.Events:OnNet(Enums.Vda.HasAcces, function(iplPos, heading)
--     local player = Client.Player:GetPed()
--     Elevator:Teleport(player, iplPos, heading)
-- end)

-- Shared.Events:OnNet(Enums.Vda.HasMenuAcces, function(vdaType)
--     if (vdaType == "vda1") then
--         vda1_weapon_menu:Toggle()
--     elseif (vdaType == "vda2") then
--         vda2_weapon_menu:Toggle()
--     end
--     CreateVdaCam()
-- end)