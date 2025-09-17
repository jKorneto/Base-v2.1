-- RegisterNetEvent("esx:playerLoaded", function()
--     local lastPosition = GetEntityCoords(PlayerPedId())
--     local basicSpeedThreshold = 1000.0
--     local maxSpeed = 10.0

--     if (ESX.GetPlayerData()['group'] == "fondateur") then
--         Shared.Log:Info("Anti NoClip / FreeCam launched")

--         Citizen.CreateThread(function()
--             while true do
--                 local Sleep = 1000
--                 local PlayerData = ESX.GetPlayerData()
--                 local PlayerPed = PlayerPedId()
--                 local PlayerCoords = GetEntityCoords(PlayerPed)

--                 print(PlayerPed, PlayerCoords)

--                 if not IsPedInAnyVehicle(PlayerPed, false) then
--                     local distanceTraveled = #(PlayerCoords - lastPosition)
--                     local basicTime = GetFrameTime()
--                     local basicSpeed = distanceTraveled / basicTime

--                     if basicSpeed > maxSpeed then
--                         print("Joueur banni pour déplacement trop rapide hors du véhicule")
--                     end
--                 end

--                 lastPosition = PlayerCoords
--                 Wait(Sleep)
--             end
--         end)

--     else
--         Shared.Log:Info("Anti NoClip / FreeCam not launched because your staff")
--     end
-- end)
