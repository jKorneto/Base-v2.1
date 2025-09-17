---@type Server
Server = Class.new(function(class)

    ---@class Server: BaseObject
    local self = class

    function self:Constructor()
        MySQL.ready(function()
            SetTimeout(1000, function()
                Engine.Discord = Discord(Engine["Config"]["ServerName"])
                Engine.Mecano = Mecano()
                Engine.Bill = Bill()
                Engine.ClothesShop = ClothesShop()
                Engine.Vip = Vip()
                Engine.Shop = Shop()
                Engine.Heist = Heist()
                self:HandleDisconnectError()
                Shared:Initialized("Server")
            end)
        end)
    end

    ---@param callback function
    function self:OnRestart(callback)
        AddEventHandler("onResourceStart", function(resourceName)
            if (resourceName == "engine") then
                if (callback) then callback() end
            end
        end)
    end

    ---@param xPlayer xPlayer | number
    ---@return xPlayer
    function self:ConvertToPlayer(xPlayer)
        return type(xPlayer) == "table" and xPlayer or ESX.GetPlayerFromId(xPlayer)
    end

    ---@param target number
    ---@param message string
    ---@param hasTranslation boolean
    ---@param ... any
    function self:showNotification(target, message, hasTranslation, ...)
        if (target ~= 0) then
            TriggerClientEvent("engine:notification", target, message, hasTranslation or false, ...)
        else
            if (hasTranslation) then
                print((message):format(...))
            else
                print((message):format(...))
            end
        end
    end

    local societyTimeouts = {}

    ---@param xPlayer xPlayer
    ---@param job string
    ---@param title string
    ---@param content string
    ---@param societyType string
    ---@param timeout number
    function self:showSocietyNotify(xPlayer, job, title, content, societyType, timeout)
        if (type(xPlayer) == "table") then
            ::retry::

            local society = societyTimeouts[job]

            if (society == nil) then
                societyTimeouts[job] = Timer(timeout * 60 or 60)
                societyTimeouts[job]:Start()

                exports["engine_nui"]:SendNUIMessage(-1, {
                    type = 'showSocietyNotify',
                    title = title or "Default Title",
                    content = content or "Default Content",
                    societyType = societyType or "Default Society Type"
                })
            else
                if (society:HasPassed()) then
                    societyTimeouts[job] = nil
                    goto retry
                end

                self:showNotification(xPlayer.source, "Vous devez attendre %s avant de pouvoir envoyer une nouvelle annonce", false, society:ShowRemaining())
            end
        end
    end

    ---@param xPlayer xPlayer | number
    ---@param reason string
    function self:BanPlayer(xPlayer, reason)
        local banReason = string.format("%s", reason) or "\nNo reason provided."
        local xPlayer = self:ConvertToPlayer(xPlayer)

        if (xPlayer) then
            Shared.Events:ToClient(xPlayer, Enums.OneLife.Player.TrollSong)
            xPlayer.ban(0, banReason)
        end
    end

    ---@param callback fun(xPlayer: xPlayer, reason: string)
    ---@return number
    function self:OnPlayerDropped(callback)
        return AddEventHandler("playerDropped", function(reason)
            local src = source
            local xPlayer = ESX.GetPlayerFromId(src)

            if (xPlayer) then
                callback(xPlayer, reason)
            end
        end)
    end

    function self:HandleDisconnectError()
        AddEventHandler("playerDropped", function(reason)
            local src = source
            local xPlayer = ESX.GetPlayerFromId(src)

            if (not xPlayer) then
                local playerName = GetPlayerName(src)
                Shared.Log:Error(Shared.Lang:Translate("player_disconnected_while_loading", playerName ~= nil and playerName or src, reason))
            end
        end)
    end

    return self

end)()