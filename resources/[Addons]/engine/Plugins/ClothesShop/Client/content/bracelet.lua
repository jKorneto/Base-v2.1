local bracelets_menu = clothesStorage:Get("bracelets_menu")
local bracelets = nil
local hasLoaded = false
local filter = {bracelet = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["bracelets"]

bracelets_menu:IsVisible(function(Items)
    local actualBracelet = (Client.ClothesShop:getActualClothe("bracelets_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("bracelets_1") + 1
    local actualBraceletVariant = (Client.ClothesShop:getActualClothe("bracelets_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("bracelets_2") + 1

    if (not hasLoaded) then
        bracelets, variants = Client.ClothesShop:loadProps(7)
        filter.bracelet = actualBracelet
        filter.variant = actualBraceletVariant

        bracelets_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeBracelet = (actualBracelet == filter.bracelet) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualBraceletVariant == filter.variant and actualBracelet == filter.bracelet) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Bracelet", bracelets, filter.bracelet, nil, {RightBadge = RightBadgeBracelet}, true, {
        onListChange = function(index)
            filter.bracelet = index
            filter.variant = 1

            if (filter.bracelet == 1) then
                ClearPedProp(Client.Player:GetPed(), 7)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 7, filter.bracelet - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.bracelet - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            if (filter.bracelet == 1) then
                ClearPedProp(Client.Player:GetPed(), 7)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 7, filter.bracelet - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local value = filter.bracelet - 1
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            if (filter.bracelet == 1) then
                value = -1
            end

            local clothes = {
                {component = "bracelets_1", index = value, clothesType = "bracelets", name = "Bracelet", variantComponent = "bracelets_2", variant = filter.variant - 1},
                {component = "bracelets_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Bracelet (1-%s)"):format(#bracelets), min = 1, max = #bracelets, required = true}
            })
            
            filter.bracelet = tonumber(number[1])
            filter.variant = 1

            if (filter.bracelet == 1) then
                ClearPedProp(Client.Player:GetPed(), 7)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 7, filter.bracelet - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    bracelets_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)

