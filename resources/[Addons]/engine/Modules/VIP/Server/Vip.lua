---@overload fun(): Vip
Vip = Class.new(function(class)
    ---@class Vip: BaseObject
    local self = class
    local players_vip = {}

    ---@private
    function self:Constructor()
        self:loadVipData()
    end

    ---@param fivemID string
    ---@param identifier string | nil
    ---@return boolean
    function self:isPlayerVip(fivemID, identifier)
        if (type(fivemID) == "string" or type(identifier) == "string") then
            return (fivemID and players_vip[fivemID] ~= nil) or self:isPlayerVipByIdentifier(identifier)
        end

        return false
    end

    ---@param identifier string
    ---@return boolean
    function self:isPlayerVipByIdentifier(identifier)
        if (type(identifier) == "string") then
            for fivemID, vip in pairs(players_vip) do
                if (vip.identifier == identifier) then
                    return true, fivemID
                end
            end
        end

        return false
    end

    function self:isMissingIdentifier(fivemID)
        if (type(fivemID) == "string" and fivemID ~= 0) then
            if (self:isPlayerVip(fivemID)) then
                if (players_vip[fivemID].identifier == nil) then
                    return true
                end
            end
        end

        return false
    end

    function self:addIdentifier(fivemID, identifier)
        if (type(fivemID) == "string" and type(identifier) == "string") then
            if (self:isPlayerVip(fivemID)) then
                players_vip[fivemID].identifier = identifier

                MySQL.Async.execute("UPDATE vip_players SET identifier = @identifier WHERE fivemID = @fivemID", {
                    ["@identifier"] = identifier,
                    ["@fivemID"] = fivemID
                })
            end
        end
    end

    ---@param identifier string
    ---@return table
    function self:getPlayerVipData(identifier)
        if (type(identifier) == "string") then
            if (self:isPlayerVip(nil, identifier)) then
                for fivemID, vip in pairs(players_vip) do
                    if (vip.identifier == identifier) then
                        return vip
                    end
                end
            end
        end

        return {}
    end

    ---@param fivemID string
    ---@param identifier string
    ---@param time number (days)
    ---@return boolean
    function self:addVip(fivemID, identifier, time)
        if (type(fivemID) == "string" and fivemID ~= 0 and type(time) == "number" and time > 0) then
            if (not self:isPlayerVip(fivemID)) then
                local expirationTimestamp = os.time() + (time * 86400)
                local expirationDatetime = os.date("%Y-%m-%d %H:%M:%S", expirationTimestamp)

                players_vip[fivemID] = {
                    fivemID = fivemID,
                    identifier = identifier,
                    expiration = tonumber(expirationTimestamp) * 1000,
                    buyDate = os.date("%d/%m/%Y")
                }

                MySQL.Async.execute("INSERT INTO vip_players (identifier, fivemID, expiration) VALUES (@identifier, @fivemID, @expiration)", {
                    ["@identifier"] = identifier,
                    ["@fivemID"] = fivemID,
                    ["@expiration"] = expirationDatetime
                })

                Shared.Log:Success(string.format("Added Player VIP: ^4%s^0 for %d %s", fivemID, time, (time > 1 and "days" or "day")))
                return true
            else
                self:addDayVip(fivemID, time)
                return "added_day"
            end
        end

        return false
    end

    ---@param fivemID string
    ---@param time number (days)
    ---@return boolean
    function self:addDayVip(fivemID, time)
        if (type(fivemID) == "string" and fivemID ~= 0 and type(time) == "number" and time > 0) then
            if (self:isPlayerVip(fivemID)) then
                local playerVipData = players_vip[fivemID]
                local expirationTimestamp = playerVipData.expiration / 1000 + (time * 86400)
                local expirationDatetime = os.date("%Y-%m-%d %H:%M:%S", expirationTimestamp)

                players_vip[fivemID] = {
                    fivemID = fivemID,
                    identifier = playerVipData.identifier,
                    expiration = tonumber(expirationTimestamp) * 1000,
                    buyDate = playerVipData.buyDate
                }

                MySQL.Async.execute("UPDATE vip_players SET expiration = @expiration WHERE fivemID = @fivemID", {
                    ["@expiration"] = expirationDatetime,
                    ["@fivemID"] = fivemID
                })

                Shared.Log:Success(string.format("Added %d %s to Player VIP: ^4%s^0", time, (time > 1 and "days" or "day"), fivemID))
                return true
            else
                Shared.Log:Error(string.format("The player: ^4%s^0 has not VIP", fivemID))
                return "not_vip"
            end
        end

        return false
    end

    function self:removeVip(identifier)
        if (type(identifier) == "string") then
            if (self:isPlayerVip(nil, identifier)) then
                local playerVipData = self:getPlayerVipData(identifier)

                if (next(playerVipData) ~= nil) then
                    local fivemID = playerVipData.fivemID

                    players_vip[fivemID] = nil

                    MySQL.Async.execute("DELETE FROM vip_players WHERE identifier = @identifier", {
                        ['@identifier'] = identifier,
                    })

                    Shared.Log:Success(string.format("Removed Player VIP: ^4%s^0", fivemID))
                    return true
                end
            else
                Shared.Log:Error(string.format("The player: ^4%s^0 has not VIP", identifier))
                return "not_vip"
            end
        end

        return false
    end

    ---@param xPlayer xPlayer
    function self:updateClientVipData(xPlayer)
        if (type(xPlayer) == "table") then
            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Vip.Events.ReceiveData, self:getPlayerVipData(xPlayer.identifier))
        end
    end

    function self:loadVipData()
        CreateThread(function()
            local vipCount = 0

            MySQL.Async.fetchAll("SELECT * FROM vip_players", {}, function(data)
                for _, vip in pairs(data) do
                    players_vip[vip.fivemID] = {
                        fivemID = vip.fivemID,
                        identifier = vip.identifier,
                        expiration = vip.expiration,
                        buyDate = vip.buyDate
                    }

                    vipCount += 1
                end

                if (tonumber(vipCount) > 0) then
                    Shared.Log:Success(string.format("^4%s^0 VIP Players Loaded", vipCount or 0))
                end

                self:vipCheck()
            end)
        end)
    end

    function self:vipCheck()
        CreateThread(function()
            while true do
                if (next(players_vip) ~= nil) then
                    for _, vip in pairs(players_vip) do
                        if (vip.expiration ~= nil) then
                            local currentTime = os.time()
                            local expirationTime = vip.expiration

                            if ((expirationTime / 1000) <= currentTime) then
                                self:removeVip(vip.identifier)
                                Engine.Discord:SendMessage("VipExpired",
                                    string.format("Le VIP du joueur (***%s***) a expiré",
                                        vip.identifier
                                    )
                                )
                                Shared.Log:Info(string.format("VIP Expired for player: ^4%s^0", vip.identifier))
                            end
                        end
                    end
                end

                Wait(60000)
            end
        end)
    end

    return self
end)
