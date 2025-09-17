local torso_menu = clothesStorage:Get("torso_menu")
local filter = {top = 1, topVariant = 1, tshirt = 1, tshirtVariant = 1, arm = 1, armVariant = 1, decal = 1, decalVariant = 1}
local price = {top = 0, tshirt = 0, arm = 0, decal = 0}
local topPrice = Engine["Config"]["ClothesShop"]["Prices"]["tops"]
local tshirtPrice = Engine["Config"]["ClothesShop"]["Prices"]["tshirts"]
local armPrice = Engine["Config"]["ClothesShop"]["Prices"]["arms"]
local decalPrice = Engine["Config"]["ClothesShop"]["Prices"]["decals"]

local function calculatePrice()
    return price.top + price.tshirt + price.arm + price.decal
end

local function resetPrice()
    price = {top = 0, tshirt = 0, arm = 0, decal = 0}
end

local function research(label, max, componentID, component, variant)
    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = label.. " (1-"..max..")", min = 1, max = max, required = true}
            })
            
            filter[component] = tonumber(number[1])
            filter[variant] = 1

            SetPedComponentVariation(Client.Player:GetPed(), componentID, filter[component] - 1, filter[variant] - 1, true)
        end
    end)
end

torso_menu:IsVisible(function(Items)
    local actualTop = (Client.ClothesShop:getActualClothe("torso_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("torso_1") + 1
    local actualTopVariant = (Client.ClothesShop:getActualClothe("torso_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("torso_2") + 1
    local actualTshirt = (Client.ClothesShop:getActualClothe("tshirt_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("tshirt_1") + 1
    local actualTshirtVariant = (Client.ClothesShop:getActualClothe("tshirt_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("tshirt_2") + 1
    local actualArm = (Client.ClothesShop:getActualClothe("arms") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("arms") + 1
    local actualArmVariant = (Client.ClothesShop:getActualClothe("arms_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("arms_2") + 1
    local actualDecal = (Client.ClothesShop:getActualClothe("decals_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("decals_1") + 1
    local actualDecalVariant = (Client.ClothesShop:getActualClothe("decals_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("decals_2") + 1

    if (not hasLoaded) then
        top, variants = Client.ClothesShop:loadClothes(11)
        tshirt, tshirtVariants = Client.ClothesShop:loadClothes(8)
        arm, armVariants = Client.ClothesShop:loadClothes(3)
        decal, decalVariants = Client.ClothesShop:loadClothes(10)
        filter.top = actualTop
        filter.topVariant = actualTopVariant
        filter.tshirt = actualTshirt
        filter.tshirtVariant = actualTshirtVariant
        filter.arm = actualArm
        filter.armVariant = actualArmVariant
        filter.decal = actualDecal
        filter.decalVariant = actualDecalVariant

        torso_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })
        
        hasLoaded = true
    end

    local RightBadgeTop = (actualTop == filter.top) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeTopVariant = (actualTopVariant == filter.topVariant and actualTop == filter.top) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeTshirt = (actualTshirt == filter.tshirt) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeTshirtVariant = (actualTshirtVariant == filter.tshirtVariant and actualTshirt == filter.tshirt) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeArm = (actualArm == filter.arm) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeArmVariant = (actualArmVariant == filter.armVariant and actualArm == filter.arm) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeDecal = (actualDecal == filter.decal) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeDecalVariant = (actualDecalVariant == filter.decalVariant and actualDecal == filter.decal) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Hauts", top, filter.top, nil, {RightBadge = RightBadgeTop}, true, {
        onListChange = function(index)
            filter.top = index
            filter.topVariant = 1

            if (actualTop == filter.top) then
                price.top = 0
            else
                price.top = topPrice
            end

            SetPedComponentVariation(Client.Player:GetPed(), 11, filter.top - 1, filter.topVariant - 1, true)
        end,
        onActive = function()
            research("Numéro de Haut", #top, 11, "top", "topVariant")
        end
    })

    Items:List("Variantes du Haut", variants[filter.top - 1], filter.topVariant, nil, {RightBadge = RightBadgeTopVariant}, true, {
        onListChange = function(index)
            filter.topVariant = index

            SetPedComponentVariation(Client.Player:GetPed(), 11, filter.top - 1, filter.topVariant - 1, true)
        end
    })

    Items:List("Sous-Hauts", tshirt, filter.tshirt, nil, {RightBadge = RightBadgeTshirt}, true, {
        onListChange = function(index)
            filter.tshirt = index
            filter.tshirtVariant = 1

            if (actualTshirt == filter.tshirt) then
                price.tshirt = 0
            else
                price.tshirt = topPrice
            end

            SetPedComponentVariation(Client.Player:GetPed(), 8, filter.tshirt - 1, filter.tshirtVariant - 1, true)
        end,
        onActive = function()
            research("Numéro de Sous-Haut", #tshirt, 8, "tshirt", "tshirtVariant")
        end
    })

    Items:List("Variantes du Sous-Haut", tshirtVariants[filter.tshirt - 1], filter.tshirtVariant, nil, {RightBadge = RightBadgeTshirtVariant}, true, {
        onListChange = function(index)
            filter.tshirtVariant = index

            SetPedComponentVariation(Client.Player:GetPed(), 8, filter.tshirt - 1, filter.tshirtVariant - 1, true)
        end
    })

    Items:List("Bras", arm, filter.arm, nil, {RightBadge = RightBadgeArm}, true, {
        onListChange = function(index)
            filter.arm = index
            filter.armVariant = 1

            if (actualArm == filter.arm) then
                price.arm = 0
            else
                price.arm = topPrice
            end

            SetPedComponentVariation(Client.Player:GetPed(), 3, filter.arm - 1, filter.armVariant - 1, true)
        end,
        onActive = function()
            research("Numéro de Bras", #arm, 3, "arm", "armVariant")
        end
    })

    Items:List("Variantes des Bras", armVariants[filter.arm - 1], filter.armVariant, nil, {RightBadge = RightBadgeArmVariant}, true, {
        onListChange = function(index)
            filter.armVariant = index

            SetPedComponentVariation(Client.Player:GetPed(), 3, filter.arm - 1, filter.armVariant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = calculatePrice().. " ~g~$~s~"}, true, {
        onSelected = function()
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyTop,
                {index = filter.top - 1, variant = filter.topVariant - 1},
                {index = filter.tshirt - 1, variant = filter.tshirtVariant - 1},
                {index = filter.arm - 1, variant = filter.armVariant - 1},
                sex
            )
        end
    })
end, nil, function()
    Client.ClothesShop:createCamera()
    torso_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    resetPrice()
    hasLoaded = false
end)
