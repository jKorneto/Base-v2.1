---@type Discord
Discord = Class.new(function(class)

    ---@class Discord: BaseObject
    local self = class

    function self:Constructor(scriptName)
        
        self.webhooks = {}

        -- Billing
        self:AddWebhook(
            "Billing",
            ("%s | Billing"):format(scriptName or "Fowlmas Script"),
            Webhooks["Billing"]["Pay"] or ""
        )

        -- Vip
        self:AddWebhook(
            "Vip",
            ("%s | Vip"):format(scriptName or "Fowlmas Script"),
            Webhooks["Vip"]["AddVip"] or ""
        )
        self:AddWebhook(
            "VipRemove",
            ("%s | Vip"):format(scriptName or "Fowlmas Script"),
            Webhooks["Vip"]["RemoveVip"] or ""
        )
        self:AddWebhook(
            "VipExpired",
            ("%s | Vip"):format(scriptName or "Fowlmas Script"),
            Webhooks["Vip"]["ExpiredVip"] or ""
        )

        -- Shop
        self:AddWebhook(
            "ShopBuyCar",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["BuyCar"] or ""
        )
        self:AddWebhook(
            "ShopBuyWeapon",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["BuyWeapon"] or ""
        )
        self:AddWebhook(
            "ShopBuyLimitedCar",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["BuyLimitedCar"] or ""
        )
        self:AddWebhook(
            "ShopBuyMystery",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["BuyMystery"] or ""
        )
        self:AddWebhook(
            "ShopBuyPack",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["BuyPack"] or ""
        )
        self:AddWebhook(
            "ShopAddCoins",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["AddCoins"] or ""
        )
        self:AddWebhook(
            "ShopRemoveCoins",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["RemoveCoins"] or ""
        )
        self:AddWebhook(
            "ShopAddLimitedCar",
            ("%s | Shop"):format(scriptName or "Fowlmas Script"),
            Webhooks["Shop"]["AddLimitedCar"] or ""
        )

        return self
    end

    ---@param name string
    ---@param title string
    ---@param webhook string @url of the webhook
    ---@param color hexColor @color of the webhook
    function self:AddWebhook(name, title, webhook, color)
        if (webhook) then
            self.webhooks[string.upper(name)] = { name = name, title = title, url = webhook, color = color or nil }
        else
            Shared.Log:Error(string.format("No URL for discord webhook %s", name))
        end
    end

    ---@param name string
    ---@param message string
    function self:SendMessage(name, message, embedData, secondaryWebhook)

        if (self.webhooks[string.upper(name)]) then

            local embeds_list = {
                {
                    ["author"] = {
                        ["name"] = (self.webhooks[string.upper(name)] ~= nil and self.webhooks[string.upper(name)].title or "__***No title set***__")
                    },
                    ["description"] = (message and message) or "__***No message set***__",
                    ["type"] = "rich",
                    ["fields"] = embedData or {},
                    ["color"] =  self.webhooks[string.upper(name)].color or Engine["Config"]["ServerLogColor"],
                    ["footer"] =  {
                        ["text"]= self:GetTime(),
                        ["icon_url"] = Engine["Config"]["ServerImage"]
                    }
                }
            }

            PerformHttpRequest(self.webhooks[string.upper(name)].url, function(...)
            end, 'POST', json.encode({
                username = Engine["Config"]["ServerName"],
                avatar_url = Engine["Config"]["ServerImage"],
                embeds = embeds_list or {}
            }), {
                ['Content-Type'] = 'application/json' 
            })

            if (secondaryWebhook ~= nil and secondaryWebhook ~= "") and (
                    secondaryWebhook:sub(1, 33) == "https://discord.com/api/webhooks/" or
                    secondaryWebhook:sub(1, 35) == "https://ptb.discord.com/api/webhooks/" or
                    secondaryWebhook:sub(1, 37) == "https://canary.discord.com/api/webhooks/"
                ) then
                PerformHttpRequest(secondaryWebhook, function(...) end, 'POST', json.encode({
                    username = Engine["Config"]["ServerName"],
                    avatar_url = Engine["Config"]["ServerImage"],
                    embeds = embeds_list
                }), {
                    ['Content-Type'] = 'application/json'
                })
            end

        end

    end

    function self:GetTime()
        local date = os.date('*t')
        if date.day < 10 then date.day = '0' .. tostring(date.day) end
        if date.month < 10 then date.month = '0' .. tostring(date.month) end
        if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
        if date.min < 10 then date.min = '0' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
        date.msg = ("%s ©   |   %s:%s:%s"):format("Powered for OneLife", date.hour, date.min, date.sec)
        return date.msg
    end

    return self
end)