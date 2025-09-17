local weapon_menu = shopStorage:Get("weapon_menu")
local selected_weapon = nil

weapon_menu:IsVisible(function(Items)
    local weapons = Engine["Config"]["Shop"]["weapons"]
    for i = 1, #weapons do
        local weapon = weapons[i]
        local desc = "~r~Toutes les armes présentes ici sont permanentes~s~"
        Items:Button(weapon.label, desc, {}, true, {
            onActive = function()
                selected_weapon = i
            end,
            onSelected = function()
                Client.Shop:buyWeapon(i)
            end
        })
    end
end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local weapons = Engine["Config"]["Shop"]["weapons"]
    local price = Shared.Math:GroupDigits(weapons[selected_weapon].price)
    local label = weapons[selected_weapon].label
    local name = weapons[selected_weapon].name

    Panels:info("Boutique",
        {"ID Boutique :", "OneCoins :", "Prix " .. label .. " :"},
        {"~b~"..shopID, "~b~"..coins, "~b~"..price}
    )
    Panels:RenderSprite("weapon", name)
end)
