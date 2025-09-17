local subscriptions_menu = shopStorage:Get("subscriptions_menu")
local selected_subscription = nil

subscriptions_menu:IsVisible(function(Items)
    local subscriptions = Engine["Config"]["Shop"]["Subscription"]

    for i = 1, #subscriptions do
        local subscription = subscriptions[i]
        Items:Button(subscription.label, "Vous serez redirigé vers le site de notre boutique Tebex", {}, true, {
            onActive = function()
                selected_subscription = i
            end,
            onSelected = function()
                Client.Shop:openUrl(subscription.url)
            end
        })
    end
end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local vipLevel = Client.Vip:isPlayerVip() and "~b~Avantage VIP" or "~r~Aucun"
    local price = Engine["Config"]["Shop"]["Subscription"][selected_subscription].price

    Panels:info("Boutique",
        {"ID Boutique :", "OneCoins :", "Niveau VIP :", "Prix :"},
        {"~b~"..shopID, "~b~"..coins, vipLevel, "~b~"..price}
    )
end)
