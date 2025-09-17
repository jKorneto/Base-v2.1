local main_menu = shopStorage:Get("main_menu")
local history_menu = shopStorage:Get("history_menu")
local weapon_menu = shopStorage:Get("weapon_menu")
local exclusive_weapon_menu = shopStorage:Get("exclusive_weapon_menu")
local vehicles_menu = shopStorage:Get("vehicles_menu")
local mystery_menu = shopStorage:Get("mystery_menu")
local packs_menu = shopStorage:Get("packs_menu")
local subscriptions_menu = shopStorage:Get("subscriptions_menu")

main_menu:IsVisible(function(Items)
    Items:Button("Acheter des OneCoins", "Vous serez redirigé vers le site de notre boutique Tebex", {}, true, {
        onSelected = function()
            Client.Shop:openUrl()
        end
    })
    Items:Button("Historique des achats", nil, {}, true, {
        onSelected = function()
            Client.Shop:requestHistory()
        end
    }, history_menu)

    Items:Line()

    local inSafeZone = Client.Player:IsInSafeZone()
    local isHandcuffed = Client.Player:IsHandcuffed()
    local isCarry = Client.Player:IsInCarry()
    local isHostage = Client.Player:IsHostage()

    local vehiclesDesc = not inSafeZone and "~r~Vous ne pouvez pas accéder à cette section hors de la zone sûre" or nil
    vehiclesDesc = isHandcuffed and "~r~Vous ne pouvez pas accéder à cette section en étant menotté" or vehiclesDesc
    vehiclesDesc = isCarry and "~r~Vous ne pouvez pas accéder à cette section en étant porté" or vehiclesDesc
    vehiclesDesc = isHostage and "~r~Vous ne pouvez pas accéder à cette section en étant otage" or vehiclesDesc
    local canBuyVehicle = inSafeZone and not isHandcuffed and not isCarry and not isHostage

    Items:Button("Armes", nil, {}, true, {}, weapon_menu)
    Items:Button("Armes Exclusives", nil, {}, true, {}, exclusive_weapon_menu)
    Items:Button("Véhicules", vehiclesDesc, {}, canBuyVehicle, {}, vehicles_menu)
    Items:Button("Conteneur Mystères", vehiclesDesc, {}, canBuyVehicle, {}, mystery_menu)
    Items:Button("Packs", nil, {}, true, {}, packs_menu)
    Items:Button("Abonnement", nil, {}, true, {}, subscriptions_menu)

end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local vipLevel = Client.Vip:isPlayerVip() and "~b~Avantage VIP" or "~r~Aucun"

    Panels:info("Boutique",
        {"ID Boutique :", "OneCoins :", "Niveau VIP :"},
        {"~b~"..shopID, "~b~"..coins, vipLevel}
    )
end)

Shared.Events:OnNet(Engine["Enums"].Shop.Events.receiveHistory, function(history)
    if (type(history) == "table") then
        Client.Shop:setHistory(history)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Shop.Events.receiveCoins, function(coins)
    if (type(coins) == "number") then
        Client.Shop:setCoins(coins)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Shop.Events.receiveLimitedVehicles, function(data)
    if (type(data) == "table") then
        Client.Shop:setLimitedVehicles(data)
    end
end)

Shared:RegisterKeyMapping("Shop", {label = "Open shop menu"}, "F1", function()
    if (Client.Player ~= nil) then
        Client.Shop:requestCoins()
        Client.Shop:openShop()
    end
end)