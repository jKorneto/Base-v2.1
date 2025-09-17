-- local function EnumerateObjects()
--     return coroutine.wrap(function()
--         local handle, object = FindFirstObject()
--         local success
--         repeat
--             coroutine.yield(object)
--             success, object = FindNextObject(handle)
--         until not success
--         EndFindObject(handle)
--     end)
-- end

-- local function GetClosestObject()
--     local playerPed = PlayerPedId()
--     local playerCoords = GetEntityCoords(playerPed)

--     local radius = 5.0
--     local closestObject = nil
--     local closestDistance = radius

--     for object in EnumerateObjects() do
--         local objectCoords = GetEntityCoords(object)
--         local distance = #(playerCoords - objectCoords)

--         if distance < closestDistance then
--             closestDistance = distance
--             closestObject = object
--         end
--     end

--     return closestObject
-- end

-- local function ShowClosestObjectHash()
--     local object = GetClosestObject()

--     if object then
--         local objectHash = GetEntityModel(object)
--         print("Le hash du props est : " .. objectHash)
--     else
--         print("Aucun props trouvé à proximité.")
--     end
-- end

-- RegisterCommand("getprophash", function()
--     ShowClosestObjectHash()
-- end, false)
