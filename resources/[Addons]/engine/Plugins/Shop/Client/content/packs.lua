local pack_menu = shopStorage:Get("packs_menu")
local selected_pack = nil

pack_menu:IsVisible(function(Items)
    local packages = Engine["Config"]["Shop"]["Package"]
    for i = 1, #packages do
        local package = packages[i]
        Items:Button(package.label, nil, {}, true, {
            onActive = function()
                selected_pack = i
            end,
            onSelected = function()
                if (package.name ~= "instapic" and package.name ~= "birdy") then
                    Client.Shop:buyPackage(i)
                else
                    local username = Game.ImputText:KeyboardImput("Entrez votre nom d'utilisateur de l'application ("..package.name..")", {
                        {type = "input", placeholder = "Nom d'utilisateur", required = true}
                    })
                    
                    Client.Shop:buyPackage(i, username)
                end
            end
        })
    end
end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local packages = Engine["Config"]["Shop"]["Package"]
    local price = Shared.Math:GroupDigits(packages[selected_pack].price)

    Panels:info("Boutique",
        {"ID Boutique :", "OneCoins :", "Prix :"},
        {"~b~"..shopID, "~b~"..coins, "~b~"..price}
    )
end)

