-- local AfkPlayers = {}
-- local AllPlayers = {}

-- CreateThread(function()
--     MySQL.Async.fetchAll("SELECT * FROM afk_players", {}, function(results)
--         if (#results >= 1) then
--             for _, player in pairs(results) do
--                 AllPlayers[player.license] = {
--                     username = player.username,
--                     coins = player.coins or 0
--                 }
--             end
--             Shared.Log:Info(("%s joueurs AFK chargés"):format(#results))
--         else
--             Shared.Log:Info("Aucun joueur AFK trouvé")
--         end
--     end)
-- end)

-- local function RunReward(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     while AfkPlayers[xPlayer.identifier] ~= nil do
--         Wait(5000)
--         AllPlayers[xPlayer.identifier].coins = AllPlayers[xPlayer.identifier].coins + 1
--         xPlayer.showNotification("Vous avez gagné (~b~1~s~) jeton vous avez desormais (~b~" .. AllPlayers[xPlayer.identifier].coins .. "~s~) jeton")
--         print("Vous avez gagné 1 jeton vous avez desormais " .. AllPlayers[xPlayer.identifier].coins .. " jeton")
--     end
-- end

-- local function GetCoins(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     return AllPlayers[xPlayer.identifier].coins
-- end

-- local function AddPlayerToDatabaseIfNotInAllPlayers(xPlayer)
--     if (not AllPlayers[xPlayer.identifier]) then
--         MySQL.Async.execute("INSERT INTO afk_players (license, username, coins) VALUES (@license, @username, @coins)", {
--             ['@license'] = xPlayer.identifier,
--             ['@username'] = xPlayer.getName(),
--             ['@coins'] = 0
--         }, function(rowsChanged)
--             if (rowsChanged) > 0 then
--                 AllPlayers[xPlayer.identifier] = {
--                     username = xPlayer.getName(),
--                     coins = 0
--                 }
--             end
--         end)
--     end
-- end

-- local Timeout = {}

-- RegisterServerEvent("iZeyy:Afk:State", function(state)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if (xPlayer) then
--         AddPlayerToDatabaseIfNotInAllPlayers(xPlayer)

--         if (state) then
--             local currentTime = GetGameTimer()

--             if Timeout[xPlayer.identifier] and currentTime - Timeout[xPlayer.identifier] < 60000 then
--                 local remainingTime = math.ceil((60000 - (currentTime - Timeout[xPlayer.identifier])) / 1000)
--                 xPlayer.showNotification("Vous devez attendre encore ~b~" .. remainingTime .. " secondes~s~ avant d'entrer en mode AFK.")
--                 print("Vous devez attendre encore " .. remainingTime .. " secondes avant d'entrer en mode AFK.")
--                 return
--             end

--             Timeout[xPlayer.identifier] = currentTime
--             AfkPlayers[xPlayer.identifier] = true
--             SetEntityCoords(GetPlayerPed(xPlayer.source), Config["Afk"]["AfkCoords"])
--             exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 888)
--             print("TriggerClientEvent")
--             TriggerClientEvent("iZeyy:Afk:State", xPlayer.source, true)
--             print("TriggerClientEvent")
--             CoreSendLogs(
--                 "Entrée en mode AFK",
--                 "OneLife | Afk",
--                 ("Le joueur **%s** (***%s***) a entré en mode AFK"):format(xPlayer.getName(), xPlayer.identifier),
--                 Config["Log"]["Other"]["AfkState"]
--             )
--             RunReward(xPlayer.source)
--             GetCoins(xPlayer.source)
--         else
--             if (not Timeout[xPlayer.identifier]) then
--                 AfkPlayers[xPlayer.identifier] = nil
--                 SetEntityCoords(GetPlayerPed(xPlayer.source), Config["Afk"]["ParkingCoords"])
--                 exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 0)
--                 xPlayer.showNotification("Vous avez quitté le mode AFK vous avez desormais (~b~" .. AllPlayers[xPlayer.identifier].coins .. "~s~) jeton")
--                 CoreSendLogs(
--                     "Quitter le mode AFK",
--                     "OneLife | Afk",
--                     ("Le joueur **%s** (***%s***) a quitté le mode AFK"):format(xPlayer.getName(), xPlayer.identifier),
--                     Config["Log"]["Other"]["AfkState"]
--                     )
--                 TriggerClientEvent("iZeyy:Afk:State", xPlayer.source, false)
--             else
--                 xPlayer.showNotification("Vous devez attendre 60 secondes avant de sortir du mode AFK")
--             end
--         end
--     end
-- end)


-- RegisterNetEvent("iZeyy:Afk:GetCoins", function()
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local coins = GetCoins(xPlayer.source)
--     TriggerClientEvent("iZeyy:Afk:GetCoins", xPlayer.source, coins)
-- end)

-- RegisterNetEvent("iZeyy:Afk:BuyItem", function(name, label, price, stype)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     local correctItem = false
--     for k, v in pairs(Config["Afk"]["Items"]) do
--         if (name == v.name and label == v.label and price == v.price and stype == v.type) then
--             correctItem = true
--             break
--         end
--     end

--     if (not correctItem) then
--         return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
--     end

--     local player = GetPlayerPed(xPlayer.source)
--     local playerCoords = GetEntityCoords(player)
--     local shopIllegalPos = Config["Afk"]["PedPos"]
--     local distance = #(playerCoords - shopIllegalPos)

--     if (distance < 15) then
--         if (AllPlayers[xPlayer.identifier].coins >= price) then
--             AllPlayers[xPlayer.identifier].coins = AllPlayers[xPlayer.identifier].coins - price
--             if (stype == "money") then
--                 xPlayer.addAccountMoney("cash", name)
--                 xPlayer.showNotification(("Vous avez acheté %s pour %s jeton"):format(label, price))
--                 CoreSendLogs(
--                     "Achat d'item",
--                     "OneLife | Afk",
--                     ("Le joueur **%s** (***%s***) a acheté **%s** pour **%s jeton**"):format(xPlayer.getName(), xPlayer.identifier, label, price),
--                     Config["Log"]["Other"]["AfkBuyItem"]
--                 )
--             end
--         else
--             xPlayer.showNotification("Vous n'avez pas assez de jetons")
--         end
--     end
-- end)

-- AddEventHandler("playerDropped", function()
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if (xPlayer) then
--         local playerData = AllPlayers[xPlayer.identifier]
--         if (playerData) then
--             MySQL.Async.execute("UPDATE afk_players SET coins = @coins WHERE license = @license", {
--                 ['@coins'] = playerData.coins or 0,
--                 ['@license'] = xPlayer.identifier
--             }, function(rowsChanged)
--                 return
--             end)
--         end
--         AfkPlayers[xPlayer.identifier] = nil
--     end
-- end)
