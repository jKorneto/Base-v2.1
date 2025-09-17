local main_menu = clothesStorage:Get("main_menu")
local shop_menu = clothesStorage:Get("shop_menu")
local underwear_menu = clothesStorage:Get("underwear_menu")
local saved_outfits_menu = clothesStorage:Get("saved_outfits_menu")
local hat_menu = clothesStorage:Get("hat_menu")
local earring_menu = clothesStorage:Get("earring_menu")
local glasses_menu = clothesStorage:Get("glasses_menu")
local torso_menu = clothesStorage:Get("torso_menu")
local accessories_menu = clothesStorage:Get("accessories_menu")
local bags_menu = clothesStorage:Get("bags_menu")
local watches_menu = clothesStorage:Get("watches_menu")
local bracelets_menu = clothesStorage:Get("bracelets_menu")
local pants_menu = clothesStorage:Get("pants_menu")
local shoes_menu = clothesStorage:Get("shoes_menu")
local mask_menu = clothesStorage:Get("mask_menu")

main_menu:IsVisible(function(Items)
    Items:Button("Boutique de vêtements", nil, {}, true, {}, shop_menu)
    Items:Button("Sous-vêtements", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:undress()
        end
    }, underwear_menu)
    Items:Button("Vos tenues sauvegardées", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:requestOutfits()
        end
    }, saved_outfits_menu)
end, nil, function()
    Client.ClothesShop:stopAnimation()
    Client.ClothesShop:destroyCamera()
    Client.ClothesShop:resetOutfit()
end)

shop_menu:IsVisible(function(Items)
    Items:Button("Chapeau", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("head")
        end
    }, hat_menu)
    Items:Button("Accessoires d'oreille", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("head")
        end
    }, earring_menu)
    Items:Button("Lunettes", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("head")
        end
    }, glasses_menu)
    Items:Button("Haut", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("torso")
        end
    }, torso_menu)
    Items:Button("Accessoires", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("torso")
        end
    }, accessories_menu)
    Items:Button("Sac", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("torso")
        end
    }, bags_menu)
    Items:Button("Montres", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("torso")
        end
    }, watches_menu)
    Items:Button("Bracelet", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("torso")
        end
    }, bracelets_menu)
    Items:Button("Bas", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("legs")
        end
    }, pants_menu)
    Items:Button("Chaussures", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("foot")
        end
    }, shoes_menu)
    Items:Button("Masques", nil, {}, true, {
        onSelected = function()
            Client.ClothesShop:createCamera("head")
        end
    }, mask_menu)
end, nil, function()
    Client.ClothesShop:createCamera()
    Client.ClothesShop:resetOutfit()
end)

Shared.Events:OnNet(Engine["Enums"].ClothesShop.Events.hasBuyClothes, function(data)
    if (type(data) == "table") then
        for i = 1, #data do
            TriggerEvent("skinchanger:change", data[i].component, data[i].index)
        end
        
        SetTimeout(100, function()
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
                Client.ClothesShop:requestActualOutfit()
            end)
        end)
    end
end)

local texture = nil
local variant = nil

underwear_menu:IsVisible(function(Items)
    local player = Client.Player:GetPed()
    local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"
    local underpants = Client.ClothesShop:getUnderpants()
    local isVip = Client.Vip:isPlayerVip()
    local description = not isVip and "~r~Cette fonctionnalité est réservée aux membres VIP" or nil

    if (underpants ~= nil) then
        for i = 1, #Engine["Config"]["ClothesShop"]["Underwear"][sex] do
            local underwear = Engine["Config"]["ClothesShop"]["Underwear"][sex][i]
            local rightBadge = (underwear.texture == underpants.texture and underwear.variant == underpants.variant) and RageUI.BadgeStyle.Clothes or nil
            local rightLabel = (underwear.texture ~= underpants.texture or underwear.variant ~= underpants.variant) and Engine["Config"]["ClothesShop"]["Prices"]["underwear"].." ~g~$~s~" or nil

            Items:Button(underwear.label, description, {RightLabel = rightLabel, RightBadge = rightBadge}, isVip, {
                onActive = function()
                    if (underwear.texture ~= texture or underwear.variant ~= variant) then
                        texture = underwear.texture
                        variant = underwear.variant

                        SetPedComponentVariation(Client.Player:GetPed(), 4, underwear.texture, underwear.variant, 1)
                    end
                end,
                onSelected = function()
                    if (rightBadge == nil) then
                        Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.setUnderpants, sex, i)
                    end
                end
            })
        end
    else
        Items:Separator("Chargement des sous-vêtements...")
    end
end, nil, function()
    Client.ClothesShop:resetOutfit()
end)

Shared.Events:OnNet(Engine["Enums"].ClothesShop.Events.receiveUnderpants, function(data)
    if (type(data) == "table") then
        Client.ClothesShop:setUnderpants(data)
    end
end)

exports("getUnderpants", function()
    return Client.ClothesShop:getUnderpants()
end)

local savedOutfits = {
    List = {
        "Mettre",
        "Renommer",
        "Supprimer"
    },
    Index = 1
}

saved_outfits_menu:IsVisible(function(Items)
    local outfits = Client.ClothesShop:getOutfits()
    local isVip = Client.Vip:isPlayerVip()
    local maxOutfits = isVip and Engine["Config"]["ClothesShop"]["MaxOutfitsVip"] or Engine["Config"]["ClothesShop"]["MaxOutfits"]

    if (outfits ~= nil) then
        if (#outfits > 0) then
            for i = 1, #outfits do
                local outfitInfo = i > maxOutfits and "~r~Vous ne pouvez plus accéder à cette tenue, car elle dépasse la limite des tenues sauvegardées~s~" or nil

                Items:List(outfits[i], savedOutfits.List, savedOutfits.Index, outfitInfo, {}, i <= maxOutfits, {
                    onListChange = function(Index)
                        savedOutfits.Index = Index
                    end,
                    onSelected = function()
                        if (savedOutfits.Index == 1) then
                            Client.ClothesShop:takeOutfit(i)
                        elseif (savedOutfits.Index == 2) then
                            local outfitName = Game.ImputText:KeyboardImput("Nom de la tenue", {
                                {type = "input", placeholder = "Nom", required = true}
                            })

                            if (outfitName ~= nil) then
                                if (Game.ImputText:InputIsValid(outfitName[1], "string")) then
                                    if (string.len(outfitName[1]) > 0 and string.len(outfitName[1]) <= 25) then
                                        Client.ClothesShop:renameOutfit(i, outfitName[1])
                                    else
                                        Game.Notification:showNotification("Le nom de la tenue ne peut pas dépasser 25 caractères", false)
                                    end
                                else
                                    Game.Notification:showNotification("Veuillez entrer un nom valide", false)
                                end
                            end
                        elseif (savedOutfits.Index == 3) then
                            local confirm = Game.ImputText:KeyboardImput("Voulez-vous supprimer la tenue "..outfits[i].." ?", {
                                {type = "input", placeholder = "Mettre \"oui\" pour confirmer", required = true}
                            })

                            if (confirm ~= nil) then
                                if (Game.ImputText:InputIsValid(confirm[1], "string")) then
                                    if (confirm[1]:lower() == "oui") then
                                        Client.ClothesShop:deleteOutfit(i)
                                    end
                                end
                            end
                        end
                    end
                })
            end
        end

        if (#outfits < maxOutfits) then
            Items:Button("Créer une nouvelle tenue", "La tenue ajouter sera votre tenue actuelle", {}, #outfits <= maxOutfits, {
                onSelected = function()
                    local outfitName = Game.ImputText:KeyboardImput("Nom de la tenue", {
                        {type = "input", placeholder = "Nom", required = true}
                    })
        
                    if (outfitName ~= nil) then
                        if (Game.ImputText:InputIsValid(outfitName[1], "string")) then
                            if (string.len(outfitName[1]) > 0 and string.len(outfitName[1]) <= 25) then
                                local isVip = Client.Vip:isPlayerVip()
                                local maxOutfits = isVip and Engine["Config"]["ClothesShop"]["MaxOutfitsVip"] or Engine["Config"]["ClothesShop"]["MaxOutfits"]
        
                                if (#outfits < maxOutfits) then
                                    Client.ClothesShop:saveOutfit(outfitName[1])
                                else
                                    Game.Notification:showNotification("Vous avez atteint le nombre maximum de tenues sauvegardées", false)
                                end
                            else
                                Game.Notification:showNotification("Le nom de la tenue ne peut pas dépasser 25 caractères", false)
                            end
                        else
                            Game.Notification:showNotification("Veuillez entrer un nom valide", false)
                        end
                    end
                end
            })
        end
    else
        Items:Separator("Chargement des tenues...")
    end
end, function(Panels)
    local outfits = Client.ClothesShop:getOutfits()

    if (outfits ~= nil) then
        local isVip = Client.Vip:isPlayerVip()
        local maxOutfits = isVip and Engine["Config"]["ClothesShop"]["MaxOutfitsVip"] or Engine["Config"]["ClothesShop"]["MaxOutfits"]
        local additionalInfo = not isVip and "~r~Vous pouvez sauvegarder plus de tenues en devenant VIP~s~" or nil
        local outfitsCount = #outfits or 0

        Panels:info("Informations",
            {"Tenues sauvegardées :", "Tenues maximum :", additionalInfo},
            {outfitsCount, maxOutfits, ""}
        )
    end
end)

Shared.Events:OnNet(Engine["Enums"].ClothesShop.Events.receiveOutfits, function(data)
    if (type(data) == "table") then
        Client.ClothesShop:setOutfits(data)
    end
end)

Shared.Events:OnNet(Engine["Enums"].ClothesShop.Events.hasBuyOutfit, function(outfit)
    if (type(outfit) == "table") then
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, outfit)
        end)

        SetTimeout(100, function()
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
                Client.ClothesShop:requestActualOutfit()
            end)
        end)
    end
end)

RegisterNetEvent("engine:clothes:use", function(item)
    if (type(item) == "table") then
        local drawable = item.meta.drawable
        local firstComponent = item.meta.drawableComponent
        local texture = item.meta.texture
        local secondComponent = item.meta.textureComponent
        local category = item.meta.category
        local animation = Engine["Config"]["ClothesShop"]["Animation"][category]
        local isWeared = false

        if (animation) then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if (firstComponent == skin[drawable] and secondComponent == skin[texture]) then
                    isWeared = true
                    return Game.Notification:showNotification("Vous portez déjà ce vêtement", false)
                end
            end)

            if (not isWeared) then
                Client.ClothesShop:makeAnimation(animation.dict, animation.anim, animation.flag, animation.time, function()
                    TriggerEvent("skinchanger:change", drawable, firstComponent)
                    TriggerEvent("skinchanger:change", texture, secondComponent)
                    SetTimeout(100, function()
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                        end)
                    end)
                end)

                exports["inventory"]:wearDress({id = animation.id, drawable = firstComponent, texture = secondComponent, prop = animation.prop})
            end
        end
    end
end)

RegisterNetEvent("engine:clothes:top", function(item)
    if (type(item) == "table") then
        local torsoIndex = item.meta.torso.index
        local torsoVariant = item.meta.torso.variant
        local tshirtIndex = item.meta.tshirt.index
        local tshirtVariant = item.meta.tshirt.variant
        local armsIndex = item.meta.arms.index
        local armsVariant = item.meta.arms.variant
        local animation = Engine["Config"]["ClothesShop"]["Animation"]["tops"]
        local isWeared = false

        if (animation) then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if (torsoIndex == skin["torso_1"] and torsoVariant == skin["torso_2"]) then
                    isWeared = true
                    return Game.Notification:showNotification("Vous portez déjà ce vêtement", false)
                end
            end)

            if (not isWeared) then
                Client.ClothesShop:makeAnimation(animation.dict, animation.anim, animation.flag, animation.time, function()
                    TriggerEvent("skinchanger:change", "torso_1", torsoIndex)
                    TriggerEvent("skinchanger:change", "torso_2", torsoVariant)
                    TriggerEvent("skinchanger:change", "tshirt_1", tshirtIndex)
                    TriggerEvent("skinchanger:change", "tshirt_2", tshirtVariant)
                    TriggerEvent("skinchanger:change", "arms", armsIndex)
                    TriggerEvent("skinchanger:change", "arms_2", armsVariant)
                    SetTimeout(100, function()
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                        end)
                    end)
                end)

                exports["inventory"]:wearDress({id = animation.id, drawable = torsoIndex, texture = torsoVariant, prop = animation.prop})
            end
        end
    end
end)