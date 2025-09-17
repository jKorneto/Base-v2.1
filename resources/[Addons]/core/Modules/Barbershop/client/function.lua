-- local cameraSettings = {
--     camera = nil,
--     isActive = false,
--     boneCoords = nil,
--     azimuth = nil,
--     elevation = nil,
--     zoomLevel = nil,
--     bodyPart = "none"
-- }

-- function createHeadCamera()

--     if (cameraSettings.camera) then
--         destroyHeadCamera()
--     end

--     local ped = Client.Player:GetPed()
--     local pedHeading = GetEntityHeading(ped)
--     local headCoords = GetPedBoneCoords(ped, 0x796E)

--     cameraSettings.bodyPart = "head"
--     cameraSettings.zoomLevel = 0.7
--     cameraSettings.boneCoords = headCoords
--     cameraSettings.azimuth = pedHeading + 180.0
--     cameraSettings.elevation = 10

--     cameraSettings.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
--     SetCamActive(cameraSettings.camera, true)
--     RenderScriptCams(true, false, 0, true, true)

--     if (not cameraSettings.isActive) then
--         cameraSettings.isActive = true

--         CreateThread(function()
--             while cameraSettings.camera do
--                 SetMouseCursorActiveThisFrame()

--                 if (IsControlJustPressed(0, 24) or IsDisabledControlPressed(0, 24)) then
--                     local mouseX = GetDisabledControlNormal(0, 1)
--                     local mouseY = GetDisabledControlNormal(0, 2)

--                     SetMouseCursorSprite(4)
--                     cameraSettings.azimuth = cameraSettings.azimuth + mouseX * 10.0
--                     cameraSettings.elevation = cameraSettings.elevation + mouseY * 10.0

--                     if (cameraSettings.elevation > 80.0) then
--                         cameraSettings.elevation = 80.0
--                     elseif (cameraSettings.elevation < -80.0) then
--                         cameraSettings.elevation = -80.0
--                     end
--                 else
--                     SetMouseCursorSprite(1)
--                 end

--                 local cameraX = cameraSettings.boneCoords.x + cameraSettings.zoomLevel * math.cos(math.rad(cameraSettings.elevation)) * math.sin(math.rad(cameraSettings.azimuth))
--                 local cameraY = cameraSettings.boneCoords.y + cameraSettings.zoomLevel * math.cos(math.rad(cameraSettings.elevation)) * math.cos(math.rad(cameraSettings.azimuth))
--                 local cameraZ = cameraSettings.boneCoords.z + cameraSettings.zoomLevel * math.sin(math.rad(cameraSettings.elevation))

--                 SetCamCoord(cameraSettings.camera, cameraX, cameraY, cameraZ)
--                 PointCamAtCoord(cameraSettings.camera, cameraSettings.boneCoords.x, cameraSettings.boneCoords.y, cameraSettings.boneCoords.z)

--                 Wait(0)
--             end

--             cameraSettings.isActive = false
--         end)
--     end

--     return cameraSettings.camera
-- end

-- function destroyHeadCamera()
--     if (cameraSettings.camera) then
--         RenderScriptCams(false, false, 0, true, true)
--         DestroyCam(cameraSettings.camera, true)
--         cameraSettings.camera = nil
--         cameraSettings.bodyPart = nil
--         cameraSettings.boneCoords = nil
--         cameraSettings.azimuth = nil
--         cameraSettings.elevation = nil
--         cameraSettings.zoomLevel = nil
--         cameraSettings.isActive = false

--         return true
--     end

--     return false
-- end

-- function requestBarberInfo()
--     TriggerEvent('skinchanger:getSkin', function(outfit)
--         local hairAndBeard = {
--             ["hair_1"] = tonumber(outfit.hair_1),      -- Style de cheveux
--             ["hair_2"] = tonumber(outfit.hair_2),      -- Mèche de cheveux (secondary color)
--             ["hair_color_1"] = tonumber(outfit.hair_color_1), -- Couleur principale des cheveux
--             ["hair_color_2"] = tonumber(outfit.hair_color_2), -- Couleur secondaire des cheveux
--             ["beard_1"] = tonumber(outfit.beard_1),    -- Style de barbe
--             ["beard_2"] = tonumber(outfit.beard_2),    -- Couleur de la barbe
--         }

--         lastBarberSkin = hairAndBeard
--     end)
-- end

-- function barberSetComponent(skintype, i)
--     TriggerEvent('skinchanger:change', skintype, i)
-- end