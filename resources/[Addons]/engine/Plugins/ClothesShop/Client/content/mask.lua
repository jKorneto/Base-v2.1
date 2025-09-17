local mask_menu = clothesStorage:Get("mask_menu")
local mask = nil
local hasLoaded = false
local filter = {mask = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["masks"]

mask_menu:IsVisible(function(Items)
    local actualMask = (Client.ClothesShop:getActualClothe("mask_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("mask_1") + 1
    local actualMaskVariant = (Client.ClothesShop:getActualClothe("mask_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("mask_2") + 1

    if (not hasLoaded) then
        mask, variants = Client.ClothesShop:loadClothes(1)
        filter.mask = actualMask
        filter.variant = actualMaskVariant

        mask_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeMask = (actualMask == filter.mask) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualMaskVariant == filter.variant and actualMask == filter.mask) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Masque", mask, filter.mask, nil, {RightBadge = RightBadgeMask}, true, {
        onListChange = function(index)
            filter.mask = index
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 1, filter.mask - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.mask - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            SetPedComponentVariation(Client.Player:GetPed(), 1, filter.mask - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            local clothes = {
                {component = "mask_1", index = filter.mask - 1, clothesType = "masks", name = "Masque", variantComponent = "mask_2", variant = filter.variant - 1},
                {component = "mask_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Masque (1-%s)"):format(#masks), min = 1, max = #masks, required = true}
            })
            
            filter.mask = tonumber(number[1])
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 1, filter.mask - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    mask_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)
