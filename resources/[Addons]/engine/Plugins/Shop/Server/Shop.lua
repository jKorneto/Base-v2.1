---@overload fun(): Shop
Shop = Class.new(function(class)
    local self = class
    local playerData = {}
    local limitedVehicles = {}
    local pendingCoins = {}

    function self:Constructor()
        Shared:Initialized("Shop")
        self:loadLimitedVehicles()
        self:loadPendingCoins()
    end

    ---@param identifier string
    ---@return boolean
    function self:doesPlayerHasData(identifier)
        if (type(identifier) == "string") then
            return playerData[identifier] ~= nil
        end

        return false
    end

    ---@param xPlayer Player
    ---@return boolean
    function self:createPlayerData(xPlayer)
        if (type(xPlayer) == "table") then
            if (not self:doesPlayerHasData(xPlayer.identifier)) then
                playerData[xPlayer.identifier] = {
                    coins = xPlayer.GetCoins(),
                    history = self:loadHistory(xPlayer.identifier),
                    lastPosition = nil,
                }

                return true
            end
        end

        return false
    end

    ---@param identifier string
    ---@return boolean
    function self:deletePlayerData(identifier)
        if (type(identifier) == "string") then
            if (self:doesPlayerHasData(identifier)) then
                playerData[identifier] = nil
                return true
            end
        end

        return false
    end

    ---@param identifier string
    function self:loadHistory(identifier)
        if (type(identifier) == "string") then
            local history = {}

            MySQL.Async.fetchAll('SELECT * FROM tebex_history WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function(result)
                if (result and #result > 0) then
                    for k, v in pairs(result) do
                        history[k] = {
                            transaction = v.transaction,
                            price = v.price,
                            date = os.date("%Y-%m-%d %H:%M:%S", v.date / 1000),
                        }
                    end

                    table.sort(history, function(a, b) return a.date < b.date end)
                    playerData[identifier].history = history
                end
            end)
        end
    end

    function self:loadLimitedVehicles(callback)
        limitedVehicles = {}

        MySQL.Async.fetchAll('SELECT * FROM tebex_limited_vehicles', {}, function(result)
            if (result and #result > 0) then
                for k, v in pairs(result) do
                    limitedVehicles[k] = v
                end
            end

            if (callback) then
                callback(true)
            end
        end) 
    end

    function self:getLimitedVehicles()
        return limitedVehicles
    end

    ---@param index number
    ---@return number
    function self:getLimitedVehicleQuantity(index)
        if (type(index) == "number") then
            local vehicle = limitedVehicles[index]
            return vehicle.quantity
        end

        return 0
    end

    ---@param index number
    ---@return boolean
    function self:removeLimitedVehicleQuantity(index, callback)
        if (type(index) == "number") then
            local vehicle = limitedVehicles[index]

            if (vehicle ~= nil) then
                vehicle.quantity -= 1

                if (vehicle.quantity > 0) then
                    MySQL.Async.execute("UPDATE tebex_limited_vehicles SET quantity = @quantity WHERE id = @id", {
                        ['@quantity'] = vehicle.quantity,
                        ['@id'] = vehicle.id,
                    })

                    callback(true)
                else
                    self:removeLimitedVehicle(index, function(success)
                        if (success) then
                            callback(true)
                        end
                    end)
                end
            end
        end
    end

    ---@param model string
    ---@param label string
    ---@param quantity number
    ---@param price number
    function self:addLimitedVehicle(model, label, quantity, price)
        if (type(model) == "string" and type(label) == "string" and type(quantity) == "number" and type(price) == "number") then
            MySQL.Async.execute("INSERT INTO tebex_limited_vehicles (model, label, quantity, price) VALUES (@model, @label, @quantity, @price)", {
                ['@model'] = model,
                ['@label'] = label,
                ['@quantity'] = quantity,
                ['@price'] = price,
            }, function(id)
                if (id > 0) then
                    self:loadLimitedVehicles()
                end
            end)
        end
    end

    ---@param index number
    ---@return boolean
    function self:removeLimitedVehicle(index, callback)
        if (type(index) == "number") then
            local vehicle = limitedVehicles[index]

            if (vehicle ~= nil) then
                MySQL.Async.execute("DELETE FROM tebex_limited_vehicles WHERE id = @id", {["@id"] = vehicle.id})
                self:loadLimitedVehicles(function(success)
                    if (success) then
                        callback(true)
                    end
                end)
            end
        end

        callback(false)
    end

    function self:buyLimitedVehicle(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local vehicle = limitedVehicles[index]

            if (vehicle ~= nil) then
                local price = vehicle.price
                local isVip = xPlayer.GetVIP()
                local multiplier, reduction = self:getReduction()
                local vipPrice = price * multiplier
                local finalPrice = isVip and vipPrice or price
                local playerCoins = self:getCoins(xPlayer.identifier)
                local vehicleQuantity = self:getLimitedVehicleQuantity(index)

                if (vehicleQuantity > 0) then
                    if (playerCoins >= finalPrice) then
                        if (self:removeCoins(xPlayer, finalPrice)) then
                            if (self:addLimitedVehicleToPlayer(xPlayer, index)) then
                                self:removeLimitedVehicleQuantity(index, function(success)
                                    if (success) then
                                        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveLimitedVehicles, self:getLimitedVehicles() or {})
                                        self:addHistory(xPlayer.identifier, string.format("Achat d'un véhicule limité : ~b~%s~s~ %s", vehicle.label, (isVip and finalPrice > 0) and "~s~(VIP -"..reduction.."%)" or ""), math.floor(-finalPrice))
                                        Engine.Discord:SendMessage("ShopBuyLimitedCar",
                                            string.format("Le joueur %s (***%s***) vient d'acheter un véhicule limité (***%s***) %s quantité restante : %s",
                                                xPlayer.name,
                                                xPlayer.identifier,
                                                vehicle.label,
                                                (isVip and finalPrice > 0) and string.format("(VIP -%s%%)", reduction) or "",
                                                vehicleQuantity - 1
                                            )
                                        )
                                    end
                                end)
                            end
                        end
                    end
                else
                    Server:showNotification(xPlayer.source, "Le véhicule limité n'est plus disponible", false)
                end
            end
        end
    end

    function self:addHistory(identifier, transaction, price)
        if (type(identifier) == "string" and type(transaction) == "string" and type(price) == "number") then
            if (self:doesPlayerHasData(identifier)) then
                MySQL.Async.execute("INSERT INTO tebex_history (identifier, transaction, price) VALUES (@identifier, @transaction, @price)", {
                    ['@identifier'] = identifier,
                    ['@transaction'] = tostring(transaction),
                    ['@price'] = tonumber(price),
                })

                if (playerData[identifier].history == nil) then
                    playerData[identifier].history = {}
                end

                table.insert(playerData[identifier].history, {
                    transaction = transaction,
                    price = price,
                    date = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                })

                return true
            end
        end

        return false
    end

    function self:getHistory(identifier)
        if (type(identifier) == "string") then
            if (self:doesPlayerHasData(identifier)) then
                return playerData[identifier].history
            end
        end

        return {}
    end

    function self:getCoins(identifier)
        if (type(identifier) == "string") then
            if (self:doesPlayerHasData(identifier)) then
                return playerData[identifier].coins
            end
        end

        return 0
    end

    ---@param xPlayer Player
    ---@param coins number
    ---@return boolean
    function self:removeCoins(xPlayer, coins)
        if (type(xPlayer) == "table" and type(coins) == "number") then
            if (self:doesPlayerHasData(xPlayer.identifier)) then
                local playerCoins = self:getCoins(xPlayer.identifier)

                if (playerCoins >= coins) then
                    xPlayer.RemoveCoins(coins)
                    playerData[xPlayer.identifier].coins -= coins
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveCoins, self:getCoins(xPlayer.identifier))
                    return true
                end
            end
        end

        return false
    end
    
    function self:addCoins(xPlayer, coins)
        if (type(xPlayer) == "table" and type(coins) == "number") then
            if (self:doesPlayerHasData(xPlayer.identifier)) then
                if (xPlayer.AddCoins(coins)) then
                    playerData[xPlayer.identifier].coins += coins
                    self:addHistory(xPlayer.identifier, string.format("Ajout de OneCoins"), coins)
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveCoins, self:getCoins(xPlayer.identifier))
                    return true
                end
            end
        end

        return false
    end

    function self:setLastPosition(identifier, lastPosition)
        if (type(identifier) == "string" and type(lastPosition) == "vector4") then
            playerData[identifier].lastPosition = lastPosition
        end
    end

    function self:deleteLastPosition(identifier)
        if (type(identifier) == "string") then
            playerData[identifier].lastPosition = nil
        end
    end

    function self:getLastPosition(identifier)
        if (type(identifier) == "string") then
            if (self:doesPlayerHasData(identifier)) then
                return playerData[identifier].lastPosition
            end
        end

        return nil
    end

    function self:generatePlate(callback)
        local function randomPlate()
            local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            local digits = "0123456789"
            local plate = ""

            for i = 1, 3 do
                local randomIndex = math.random(1, #digits)
                plate = plate .. digits:sub(randomIndex, randomIndex)
            end
    
            for i = 1, 5 do
                local source = math.random(1, 2) == 1 and chars or digits
                local randomIndex = math.random(1, #source)
                plate = plate .. source:sub(randomIndex, randomIndex)
            end
    
            local shuffledplate = ""
            for i = 1, #plate do
                local randomIndex = math.random(1, #plate)
                shuffledplate = shuffledplate .. plate:sub(randomIndex, randomIndex)
                plate = plate:sub(1, randomIndex - 1) .. plate:sub(randomIndex + 1)
            end

            return shuffledplate
        end

        local plate = randomPlate()
        MySQL.Async.fetchScalar("SELECT plate FROM owned_vehicles WHERE plate = @plate", {["@plate"] = plate}, function(result)
            if (result) then
                self:generatePlate(callback)
            else
                callback(plate)
            end
        end)
    end

    function self:buyVehicle(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local vehicle = Engine["Config"]["Shop"]["vehicles"][index]

            if (vehicle ~= nil) then
                local price = vehicle.price
                local isVip = xPlayer.GetVIP()
                local multiplier, reduction = self:getReduction()
                local vipPrice = price * multiplier
                local finalPrice = isVip and vipPrice or price
                local playerCoins = self:getCoins(xPlayer.identifier)

                if (playerCoins >= finalPrice) then
                    if (self:removeCoins(xPlayer, finalPrice)) then
                        if (self:addVehicle(xPlayer, index)) then
                            self:addHistory(xPlayer.identifier, string.format("Achat d'un véhicule : ~b~%s~s~ %s", vehicle.label, (isVip and finalPrice > 0) and "~s~(VIP -"..reduction.."%)" or ""), math.floor(-finalPrice))
                            Engine.Discord:SendMessage("ShopBuyCar",
                                string.format("Le joueur %s (***%s***) vient d'acheter un véhicule (***%s***) %s",
                                    xPlayer.name,
                                    xPlayer.identifier,
                                    vehicle.label,
                                    (isVip and finalPrice > 0) and string.format("(VIP -%s%%)", reduction) or ""
                                )
                            )
                            return true
                        end
                    end
                end
            end
        end

        return false
    end

    function self:getReduction()
        local reduction = Engine["Config"]["Shop"]["vipReduction"]
        local multiplier = 1 - (reduction / 100)

        return multiplier, reduction
    end

    function self:addVehicle(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local vehicle = Engine["Config"]["Shop"]["vehicles"][index]

            if (vehicle ~= nil) then
                self:generatePlate(function(plate)
                    MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle, type, state, boutique, stored) VALUES (@owner, @plate, @vehicle, @type, @state, @boutique, @stored)",
                    {
                        ["@owner"] = xPlayer.identifier,
                        ["@plate"] = plate,
                        ["@vehicle"] = json.encode({
                            model = vehicle.name,
                            plate = plate,
                        }),
                        ["@state"] = 1,
                        ["@boutique"] = 1,
                        ["@stored"] = 1,
                        ["@type"] = "car",
                    }, 
                    function(rowsChanged)
                        if (rowsChanged > 0) then
                            xPlayer.showNotification(("Merci pour votre achat vous avez reçu votre véhicule (~b~%s~s~) [~b~%s~s~] dans votre garage."):format(vehicle.label, plate))
                        end
                    end)
                end)

                return true
            end
        end

        return false
    end

    function self:addLimitedVehicleToPlayer(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local vehicle = limitedVehicles[index]
            
            if (vehicle ~= nil) then
                self:generatePlate(function(plate)
                    MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle, type, state, boutique, stored) VALUES (@owner, @plate, @vehicle, @type, @state, @boutique, @stored)",
                    {
                        ["@owner"] = xPlayer.identifier,
                        ["@plate"] = plate,
                        ["@vehicle"] = json.encode({
                            model = vehicle.model,
                            plate = plate,
                        }),
                        ["@state"] = 1,
                        ["@boutique"] = 1,
                        ["@stored"] = 1,
                        ["@type"] = "car",
                    }, 
                    function(rowsChanged)
                        if (rowsChanged > 0) then
                            xPlayer.showNotification(("Merci pour votre achat vous avez reçu votre véhicule (~b~%s~s~) [~b~%s~s~] dans votre garage."):format(vehicle.label, plate))
                        end
                    end)
                end)

                return true
            end
        end

        return false
    end

    function self:getMysteryReward(xPlayer, index, isBuy)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local mystery = Engine["Config"]["Shop"]["mystery"][index]

            if (mystery ~= nil) then
                local rewards = mystery.reward
                local randomItemList = {}
                local rarityChance = {
                    COMMON = Engine["Config"]["Shop"]["Chance"]["COMMON"],
                    RARE = Engine["Config"]["Shop"]["Chance"]["RARE"],
                    EPIC = Engine["Config"]["Shop"]["Chance"]["EPIC"],
                    LENGENDARY = Engine["Config"]["Shop"]["Chance"]["LENGENDARY"]
                }

                for k, v in pairs(rewards) do
                    local chance = math.ceil(rarityChance[v.rarety] / 0.1)

                    for i = 0, chance do
                        table.insert(randomItemList, v)
                    end
                end

                math.randomseed(GetGameTimer())
                selectedReward = randomItemList[math.random(1, #randomItemList)]

                if (playerData[xPlayer.identifier].reward == nil) then
                    playerData[xPlayer.identifier].reward = {}
                end

                playerData[xPlayer.identifier].reward = {
                    label = mystery.label,
                    price = mystery.price,
                    reward = selectedReward 
                }

                if (isBuy == true) then
                    Engine.Discord:SendMessage("ShopBuyMystery",
                        string.format("Le joueur %s (***%s***) vient d'acheter un conteneur mystère (***%s***) et vient de gagné la récompense : **%s**",
                            xPlayer.name,
                            xPlayer.identifier,
                            mystery.label,
                            selectedReward.label
                        )
                    ) 
                end

                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.startAnimationMystery, selectedReward.label, isBuy)
            end
        end

        return nil
    end

    function self:addWeapon(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local weapon = Engine["Config"]["Shop"]["weapons"][index]
            
            if (weapon ~= nil) then
                xPlayer.addWeapon(weapon.name, 1)
                xPlayer.showNotification(("Merci pour votre achat vous avez reçu %s"):format(weapon.label))
                Engine.Discord:SendMessage("ShopBuyWeapon",
                    string.format("Le joueur %s (***%s***) vient d'acheter une armes perm (***%s***)",
                        xPlayer.name,
                        xPlayer.identifier,
                        weapon.label
                    )
                )
                self:addHistory(xPlayer.identifier, string.format("Achat d'arme : ~b~%s~s~", weapon.label), -weapon.price)
            end
        end
    end

    function self:addExWeapon(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local weapon = Engine["Config"]["Shop"]["ex_weapons"][index]

            if (weapon ~= nil) then
                xPlayer.addWeapon(weapon.name, 1)
                xPlayer.showNotification(("Merci pour votre achat vous avez reçu %s"):format(weapon.label))
                Engine.Discord:SendMessage("ShopBuyWeapon",
                    string.format("Le joueur %s (***%s***) vient d'acheter une armes exclusive perm (***%s***)",
                        xPlayer.name,
                        xPlayer.identifier,
                        weapon.label
                    )
                )
                self:addHistory(xPlayer.identifier, string.format("Achat d'arme exclusive : ~b~%s~s~", weapon.label), -weapon.price)
            end
        end
    end

    function self:addMysteryReward(xPlayer, reward, label, price, isBuy)
        if (type(xPlayer) == "table" and type(reward) == "table") then
            local rewardType = reward.type
            local rewardLabel = reward.label
            local rewardValue = reward.reward
            local winMessage = nil

            if (rewardType == "cash") then
                xPlayer.addAccountMoney("bank", rewardValue)
                Server:showNotification(xPlayer.source, "Vous avez reçu %s ~g~$~s~ dans votre banque", false, rewardValue)
            end

            if (rewardType == "vehicle") then
                self:generatePlate(function(plate)
                    MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle, type, state, boutique, stored) VALUES (@owner, @plate, @vehicle, @type, @state, @boutique, @stored)",
                    {
                        ["@owner"] = xPlayer.identifier,
                        ["@plate"] = plate,
                        ["@vehicle"] = json.encode({
                            model = rewardValue,
                            plate = plate,
                        }),
                        ["@state"] = 1,
                        ["@boutique"] = 1,
                        ["@stored"] = 1,
                        ["@type"] = "car",
                    })

                    Server:showNotification(xPlayer.source, "Vous avez reçu votre véhicule ~b~%s~s~ [~b~%s~s~] dans votre garage", false, rewardLabel, plate)
                end)
            end

            if (rewardType == "items") then
                if (xPlayer.canCarryItem(rewardValue, reward.quantity)) then
                    xPlayer.addInventoryItem(rewardValue, reward.quantity)
                    Server:showNotification(xPlayer.source, "Vous avez reçu l'item ~b~%s~s~ dans votre inventaire", false, rewardLabel)
                else
                    xPlayer.AddCoins(price)
                    playerData[xPlayer.identifier].coins += price
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveCoins, self:getCoins(xPlayer.identifier))
                    Server:showNotification(xPlayer.source, "Vous n'avez pas reçu votre item dans votre inventaire car vous n'avez pas de place")
                end
            end

            if (rewardType == "weapon") then
                if (xPlayer.canCarryItem(string.lower(rewardValue), 1)) then
                    xPlayer.addWeapon(rewardValue, 1)
                    Server:showNotification(xPlayer.source, "Vous avez reçu l'arme ~b~%s~s~ dans votre inventaire", false, rewardLabel)
                else
                    xPlayer.AddCoins(price)
                    playerData[xPlayer.identifier].coins += price
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveCoins, self:getCoins(xPlayer.identifier))
                    Server:showNotification(xPlayer.source, "Vous n'avez pas reçu votre arme dans votre inventaire car vous n'avez pas de place")
                end
            end

            if (rewardType == "coins") then
                xPlayer.AddCoins(price)
                playerData[xPlayer.identifier].coins += price
                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Shop.Events.receiveCoins, self:getCoins(xPlayer.identifier))
                Server:showNotification(xPlayer.source, "Vous avez reçu ~b~%s~s~ OneCoins", false, rewardValue)
            end

            if (isBuy == true) then
                self:addHistory(xPlayer.identifier, string.format("Achat conteneur mystère : ~b~%s~s~", label), -price)
                self:addHistory(xPlayer.identifier, string.format("Gain du conteneur : ~b~%s~s~", rewardLabel), 0) 
            elseif (isBuy == false) then
                self:addHistory(xPlayer.identifier, string.format("Ouverture d'un conteneur mystère : ~b~%s~s~", label), 0)
                self:addHistory(xPlayer.identifier, string.format("Gain du conteneur : ~b~%s~s~", rewardLabel), 0)
            end
            playerData[xPlayer.identifier].reward = nil
        end
    end

    function self:acceptMysteryReward(xPlayer, isBuy)
        if (type(xPlayer) == "table") then
            local reward = playerData[xPlayer.identifier].reward

            if (reward ~= nil) then
                self:addMysteryReward(xPlayer, reward.reward, reward.label, reward.price, isBuy)
            end
        end
    end

    function self:refundMysteryReward(xPlayer)
        if (type(xPlayer) == "table") then
            local reward = playerData[xPlayer.identifier].reward

            if (reward ~= nil) then
                if (self:addCoins(xPlayer, math.floor(reward.price / 2))) then
                    self:addHistory(xPlayer.identifier, string.format("Achat conteneur mystère : ~b~%s~s~", reward.label), math.floor(-reward.price))
                    self:addHistory(xPlayer.identifier, string.format("Remboursement : ~b~%s~s~", reward.label), math.floor(reward.price / 2))
                    Server:showNotification(xPlayer.source, "Vous avez reçu un remboursement de ~b~%s~s~ OneCoins", false, math.floor(reward.price / 2))
                    playerData[xPlayer.identifier].reward = nil
                end
            end
        end
    end

    function self:buyMysteryBox(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local mystery = Engine["Config"]["Shop"]["mystery"][index]

            if (mystery ~= nil) then
                local price = mystery.price
                local playerCoins = self:getCoins(xPlayer.identifier)

                if (playerCoins >= price) then
                    if (self:removeCoins(xPlayer, price)) then
                        self:getMysteryReward(xPlayer, index, true)
                    end
                end
            end
        end
    end

    function self:openMysteryBox(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local mystery = Engine["Config"]["Shop"]["mystery"][index]
            local item = Engine["Config"]["Shop"]["mystery"][index].name

            if (mystery ~= nil and item ~= nil) then
                local hasItem = xPlayer.getInventoryItem(item)
                if (hasItem and hasItem.quantity > 0) then
                    xPlayer.removeInventoryItem(item, 1)
                    self:getMysteryReward(xPlayer, index, false)
                    
                else
                    Server:showNotification(xPlayer.source, "Vous n'avez pas l'item ~b~%s~s~ dans votre inventaire", false, item)
                end
            end
        end
    end

    function self:buyWeapon(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local weapon = Engine["Config"]["Shop"]["weapons"][index]

            if (weapon ~= nil) then
                local price = weapon.price
                local playerCoins = self:getCoins(xPlayer.identifier)

                if (playerCoins >= price) then
                    if (self:removeCoins(xPlayer, price)) then
                        self:addWeapon(xPlayer, index)
                    end
                end
            end
        end
    end

    function self:buyExWeapon(xPlayer, index)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local weapon = Engine["Config"]["Shop"]["ex_weapons"][index]

            if (weapon ~= nil) then
                local price = weapon.price
                local playerCoins = self:getCoins(xPlayer.identifier)

                if (playerCoins >= price) then
                    if (self:removeCoins(xPlayer, price)) then
                        self:addExWeapon(xPlayer, index)
                    end
                end
            end
        end
    end

    function self:buyPackage(xPlayer, index, username)
        if (type(xPlayer) == "table" and type(index) == "number") then
            local package = Engine["Config"]["Shop"]["Package"][index]
            local price = package.price
            local playerCoins = self:getCoins(xPlayer.identifier)

            if (username ~= nil) then
                local isVerified = exports["lb-phone"]:IsVerified(package.name, username)

                if (isVerified) then
                    Server:showNotification(xPlayer.source, "Votre compte est déjà certifié", false)
                    return
                end
            end

            if (playerCoins >= price) then
                if (self:removeCoins(xPlayer, price)) then
                    if (package.name ~= "instapic" or package.name ~= "insta") then
                        Server:showNotification(xPlayer.source,
                            "Merci %s pour votre achat, faites un ticket sur notre discord afin de réclamer votre pack ~b~%s~s~",
                            false,
                            xPlayer.name,
                            package.label
                        )
                    else
                        exports["lb-phone"]:ToggleVerified(package.name, username, true)
                        Server:showNotification(xPlayer.source,
                            "Merci %s pour votre achat, votre compte sur l'application %s a été certifier",
                            false,
                            xPlayer.name,
                            package.name
                        )
                    end

                    Engine.Discord:SendMessage("ShopBuyPack",
                        string.format("Le joueur %s (***%s***) vient d'acheter un pack (***%s***)",
                            xPlayer.name,
                            xPlayer.identifier,
                            package.label
                        )
                    )

                    self:addHistory(xPlayer.identifier, string.format("Achat d'un pack : ~b~%s~s~", package.label), -price)
                end
            end
        end
    end

    function self:loadPendingCoins(callback)
        MySQL.Async.fetchAll('SELECT * FROM tebex_pending_payment', {}, function(result)
            if (result and #result > 0) then
                for k, v in pairs(result) do
                    pendingCoins[k] = {
                        fivemID = v.fivemID,
                        coins = v.coins
                    }
                end

                Shared.Log:Success(string.format("Loaded ^4%s^7 pending coins", #result))
            end
        end) 
    end

    function self:hasPendingCoins(fivemID)
        if (type(fivemID) == "string") then
            local coins = pendingCoins[fivemID] or 0
            return coins > 0, coins
        end

        return false, 0
    end

    function self:addPendingCoins(fivemID, amount)
        if (type(fivemID) == "string" and type(amount) == "number") then

            if (pendingCoins[fivemID] == nil) then
                pendingCoins[fivemID] = 0
            end

            pendingCoins[fivemID] += tonumber(amount)

            MySQL.Async.execute("INSERT INTO tebex_pending_payment (fivemID, coins) VALUES (@fivemID, @coins)", {
                ["@fivemID"] = fivemID,
                ["@coins"] = tonumber(amount),
            })
        end
    end

    function self:removePendingCoins(fivemID)
        if (type(fivemID) == "string") then
            pendingCoins[fivemID] = nil

            MySQL.Async.execute("DELETE FROM tebex_pending_payment WHERE fivemID = @fivemID", {
                ["@fivemID"] = fivemID,
            })
        end
    end

    return self
end)