Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.buyClothes, function(xPlayer, clothes, sex)
    if (type(xPlayer) == "table") then
        local price = 0

        for i = 1, #clothes do
            price = price + (Engine["Config"]["ClothesShop"]["Prices"][clothes[i].clothesType] or 0)
        end

        if (price) then
            local bill = ESX.CreateBill(0, xPlayer.source, price, "Achat de tenue", "server")

            if (bill) then
                for i = 1, #clothes do
                    local item = clothes[i]
                    local itemName = Engine.ClothesShop:getItemByComponent(item.component)

                    if (itemName) then
                        if (item.name ~= nil) then
                            if (xPlayer.canCarryItem(itemName, 1)) then
                                local imageName = Engine.ClothesShop:getImageName(sex, item.clothesType, item.index, item.variant)

                                if (imageName) then
                                    if (item.index ~= -1) then
                                        xPlayer.addInventoryItem(itemName, 1, {
                                            note = item.name,
                                            customName = item.name,
                                            customImage = "https://raw.githubusercontent.com/Fowlmas/RP-Clothes/refs/heads/main/"..imageName,
                                            category = item.clothesType,
                                            drawable = item.component,
                                            drawableComponent = item.index, 
                                            texture = item.variantComponent, 
                                            textureComponent = item.variant
                                        })
                                    end
                                end
                            else
                                xPlayer.addAccountMoney("cash", price)
                                Server:showNotification(xPlayer.source, "Vous ne pouvez pas prendre ce vêtement car vous n'avez pas de place sur vous, un remboursement a été effectué", false)
                            end
                        end
                    end
                end

                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.hasBuyClothes, clothes)
            else
                Server:showNotification(xPlayer.source, "La facture de %s ~g~$~s~ n'a pas été payée", false, price)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.buyTop, function(xPlayer, torso, tshirt, arms, sex)
    if (type(xPlayer) == "table") then
        local price = Engine["Config"]["ClothesShop"]["Prices"]["tops"]
        local bill = ESX.CreateBill(0, xPlayer.source, price, "Achat de top", "server")

        if (bill) then
            local itemName = Engine.ClothesShop:getItemByComponent("torso_1")

            if (itemName) then
                if (xPlayer.canCarryItem(itemName, 1)) then
                    local imageName = Engine.ClothesShop:getImageName(sex, "tops", torso.index, torso.variant)

                    xPlayer.addInventoryItem(itemName, 1, {
                        note = "Haut",
                        customName = "Haut",
                        customImage = "https://raw.githubusercontent.com/Fowlmas/RP-Clothes/refs/heads/main/"..imageName, 
                        category = "tops",
                        tshirt = {index = tshirt.index, variant = tshirt.variant},
                        torso = {index = torso.index, variant = torso.variant},
                        arms = {index = arms.index, variant = arms.variant},
                    })
                else
                    xPlayer.addAccountMoney("cash", price)
                    Server:showNotification(xPlayer.source, "Vous ne pouvez pas prendre ce vêtement car vous n'avez pas de place sur vous, un remboursement a été effectué", false)
                end
            end

            local clothes = {
                {component = "tshirt_1", index = tshirt.index},
                {component = "tshirt_2", index = tshirt.variant},
                {component = "torso_1", index = torso.index},
                {component = "torso_2", index = torso.variant},
                {component = "arms", index = arms.index},
                {component = "arms_2", index = arms.variant}
            }

            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.hasBuyClothes, clothes)
        else
            Server:showNotification(xPlayer.source, "La facture de %s ~g~$~s~ n'a pas été payée", false, price)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.setUnderpants, function(xPlayer, sex, index)
    if (type(xPlayer) == "table") then
        if (xPlayer.GetVIP()) then
            local bill = ESX.CreateBill(0, xPlayer.source, Engine["Config"]["ClothesShop"]["Prices"]["underwear"], "Achat de sous-vêtement", "server")

            if (bill) then
                local underpants = Engine["Config"]["ClothesShop"]["Underwear"][sex][index]

                if (underpants) then
                    local selectedUnderpants = {
                        texture = underpants.texture,
                        variant = underpants.variant
                    }

                    xPlayer.setUnderPants(selectedUnderpants)
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveUnderpants, selectedUnderpants)
                end
            end
        else
            Server:showNotification(xPlayer.source, "Vous devez être VIP pour acheter un caleçon", false)
        end
    end
end)

exports("getDefaultUnderpants", function(sex)
    return Engine.ClothesShop:getDefaultUnderpants(sex)
end)

AddEventHandler("engine:enterspawn:finish", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        if (not Engine.Vip:isPlayerVip(xPlayer.getFivemID(), xPlayer.identifier)) then
            local sex = (GetEntityModel(GetPlayerPed(xPlayer.source)) == GetHashKey("mp_m_freemode_01") and "male") or "female"
      
            xPlayer.setUnderPants(Engine.ClothesShop:getDefaultUnderpants(sex))
            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveUnderpants, xPlayer.getUnderPants())
        else
            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveUnderpants, xPlayer.getUnderPants())
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.saveOutfit, function(xPlayer, name, skin)
    if (type(xPlayer) == "table" and type(name) == "string" and type(skin) == "table") then
        local bill = ESX.CreateBill(0, xPlayer.source, Engine["Config"]["ClothesShop"]["Prices"]["saveOutfit"], "Achat de tenue", "server")

        if (bill) then
            if (Engine.ClothesShop:addOutfit(xPlayer.identifier, name, skin)) then
                local outfits = Engine.ClothesShop:getOutfits(xPlayer.identifier)
                local outfitsData = {}

                if (outfits) then
                    for i = 1, #outfits do
                        outfitsData[i] = outfits[i].name
                    end
                end

                Server:showNotification(xPlayer.source, "Votre tenue ~b~%s~s~ a été sauvegardée", false, name)
                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveOutfits, outfitsData)
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.requestOutfits, function(xPlayer)
    if (type(xPlayer) == "table") then
        local outfits = Engine.ClothesShop:getOutfits(xPlayer.identifier)
        local outfitsData = {}

        if (outfits) then
            for i = 1, #outfits do
                outfitsData[i] = outfits[i].name
            end
        end

        Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveOutfits, outfitsData)
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.takeOutfit, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        local outfits = Engine.ClothesShop:getOutfits(xPlayer.identifier)

        if (outfits) then
            local outfit = outfits[index].skin

            if (outfit) then
                local bill = ESX.CreateBill(0, xPlayer.source, Engine["Config"]["ClothesShop"]["Prices"]["takeOutfit"], "Reprise de tenue", "server")

                if (bill) then
                    Server:showNotification(xPlayer.source, "Vous avez récupéré votre tenue", false)
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.hasBuyOutfit, outfit)
                end
            end
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.renameOutfit, function(xPlayer, index, name)
    if (type(xPlayer) == "table" and type(index) == "number" and type(name) == "string") then
        if (Engine.ClothesShop:renameOutfit(xPlayer.identifier, index, name)) then
            local outfits = Engine.ClothesShop:getOutfits(xPlayer.identifier)
            local outfitsData = {}

            if (outfits) then
                for i = 1, #outfits do
                    outfitsData[i] = outfits[i].name
                end
            end

            Server:showNotification(xPlayer.source, "Votre tenue porte maintenant le nom ~b~%s~s~", false, name)
            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveOutfits, outfitsData)
        end
    end
end)

Shared.Events:OnProtectedNet(Engine["Enums"].ClothesShop.Events.deleteOutfit, function(xPlayer, index)
    if (type(xPlayer) == "table" and type(index) == "number") then
        if (Engine.ClothesShop:removeOutfit(xPlayer.identifier, index)) then
            local outfits = Engine.ClothesShop:getOutfits(xPlayer.identifier)
            local outfitsData = {}

            if (outfits) then
                for i = 1, #outfits do
                    outfitsData[i] = outfits[i].name
                end
            end

            Server:showNotification(xPlayer.source, "Votre tenue a été supprimée", false)
            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].ClothesShop.Events.receiveOutfits, outfitsData)
        end
    end
end)

exports("removeAllOutfits", function(identifier)
    return Engine.ClothesShop:removeAllOutfits(identifier)
end)
