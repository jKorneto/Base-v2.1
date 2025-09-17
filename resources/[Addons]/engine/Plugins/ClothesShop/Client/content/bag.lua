local bags_menu = clothesStorage:Get("bags_menu")
local bags = nil
local hasLoaded = false
local filter = {bag = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["bags"]

bags_menu:IsVisible(function(Items)
    local actualBag = (Client.ClothesShop:getActualClothe("bags_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("bags_1") + 1
    local actualBagVariant = (Client.ClothesShop:getActualClothe("bags_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("bags_2") + 1

    if (not hasLoaded) then
        bags, variants = Client.ClothesShop:loadClothes(5)
        filter.bag = actualBag
        filter.variant = actualBagVariant

        bags_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeBag = (actualBag == filter.bag) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualBagVariant == filter.variant and actualBag == filter.bag) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Sac", bags, filter.bag, nil, {RightBadge = RightBadgeBag}, true, {
        onListChange = function(index)
            filter.bag = index
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 5, filter.bag - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.bag - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            SetPedComponentVariation(Client.Player:GetPed(), 5, filter.bag - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            local clothes = {
                {component = "bags_1", index = filter.bag - 1, clothesType = "bags", name = "Sac", variantComponent = "bags_2", variant = filter.variant - 1},
                {component = "bags_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Sac (1-%s)"):format(#bags), min = 1, max = #bags, required = true}
            })
            
            filter.bag = tonumber(number[1])
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 5, filter.bag - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    bags_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)

