-- local vdaAccess = {}
-- local playerPositions = {}

-- local function hasAccess(license)
--     for _, access in ipairs(vdaAccess) do
--         if access.license == license then
--             return access
--         end
--     end
--     return nil
-- end

--     function vdaGetPlayerType(license)
--         for _, access in ipairs(vdaAccess) do
--             if access.license == license then
--                 return access.type
--             end
--         end
--         return nil
--     end

-- CreateThread(function()
--     MySQL.Async.fetchAll("SELECT * FROM wl_vda", {}, function(results)
--         for _, result in ipairs(results) do
--             table.insert(vdaAccess, {
--                 license = result.license,
--                 type = result.type,
--             })
--         end
--     end)
-- end)

-- Shared.Events:OnNet(Enums.Vda.CheckAcces, function(xPlayer)
--     if (type(xPlayer) == "table") then

--         if (xPlayer.job.name == "police") then
--             return
--         end

--         local player = GetPlayerPed(xPlayer.source)
--         local playerPos = GetEntityCoords(player)

--         playerPositions[xPlayer.source] = playerPos

--         local vdaPos1 = Config["Vda"]["Coords1"]
--         local vdaPos2 = Config["Vda"]["Coords2"]

--         local dist1 = #(playerPos - vdaPos1)
--         local dist2 = #(playerPos - vdaPos2)

--         if (dist1 < 15 or dist2 < 15) then
--             if (hasAccess(xPlayer.identifier)) then
--                 local vdaRoom = Config["Vda"]["IplPos"] 
--                 local vdaHeading = Config["Vda"]["HeadingPos"]
--                 Shared.Events:ToClient(xPlayer.source, Enums.Vda.HasAcces, vdaRoom, vdaHeading)
--                 exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 999)
--             else
--                 xPlayer.showNotification("Y'a rien à voir ici, dégage !")
--             end
--         end
--     end
-- end)

-- Shared.Events:OnNet(Enums.Vda.Exit, function(xPlayer)
--     if (type(xPlayer) == "table") then

--         if (xPlayer.job.name == "police") then
--             return
--         end

--         if playerPositions[xPlayer.source] then
--             local savedPos = playerPositions[xPlayer.source]
--             Shared.Events:ToClient(xPlayer.source, Enums.Vda.SetCoords, savedPos)
--             exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 0)
--             playerPositions[xPlayer.source] = nil
--         else
--             xPlayer.showNotification("(~b~Veuillez faire une Report~s~) Aucune position sauvegard")
--         end
--     end
-- end)

-- Shared.Events:OnNet(Enums.Vda.CheckMenuAcces, function(xPlayer)
--     if (type(xPlayer) == "table") then
--         if (xPlayer.job.name == "police") then
--             return
--         end

--         local player = GetPlayerPed(xPlayer.source)
--         local playerPos = GetEntityCoords(player)
--         local craftPos = Config["Vda"]["CraftPos"] 

--         local dist = #(playerPos - craftPos)
--         if (dist < 15) then
--             if (hasAccess(xPlayer.identifier)) then
--                 local vdaType = vdaGetPlayerType(xPlayer.identifier)
--                 Shared.Events:ToClient(xPlayer.source, Enums.Vda.HasMenuAcces, vdaType)
--             end
--         end
--     end
-- end)

-- -- AddVda
-- RegisterCommand("addvda", function(source, args, rawCommand)
--     local targetId = tonumber(args[1])
--     local vdaType = args[2]

--     if not targetId or targetId <= 0 then
--         Shared.Log:Error("[^3VDA^7] => Usage: /addvda <id> <type>")
--         return
--     end

--     local validTypes = { ["vda1"] = true, ["vda2"] = true }
--     if not vdaType or not validTypes[vdaType] then
--         Shared.Log:Error("[^3VDA^7] => Invalid type. Allowed types: vda1, vda2")
--         return
--     end

--     local xTarget = ESX.GetPlayerFromId(targetId)
--     if not xTarget then
--         Shared.Log:Error("[^3VDA^7] => Player not online")
--         return
--     end

--     local license = xTarget.identifier
--     local username = GetPlayerName(targetId)

--     MySQL.Async.fetchScalar("SELECT COUNT(*) FROM wl_vda WHERE license = @license", {
--         ["@license"] = license
--     }, function(count)
--         if count > 0 then
--             Shared.Log:Info("[^3VDA^7] => Player is already in VDA")
--             return
--         else
--             MySQL.Async.execute("INSERT INTO wl_vda (license, username, type) VALUES (@license, @username, @type)", {
--                 ["@license"] = license,
--                 ["@username"] = username,
--                 ["@type"] = vdaType
--             }, function(rowsChanged)
--                 if rowsChanged > 0 then
--                     xTarget.showNotification("Vous avez été ajouté à la liste de la VDA avec le type : " .. vdaType)
--                     Shared.Log:Success("[^3VDA^7] => VDA added for player ID: " .. targetId .. " with type: " .. vdaType)
--                     vdaAccess[xTarget.identifier] = true
--                 else
--                     Shared.Log:Error("[^3VDA^7] => Error adding VDA for player ID: " .. targetId)
--                 end
--             end)
--         end
--     end)
-- end, false)