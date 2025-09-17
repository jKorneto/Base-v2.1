local mystery_menu = shopStorage:Get("mystery_menu")
local mystery_preview_menu = shopStorage:Get("mystery_preview_menu")
local selectedCase = nil
local selectedIndex = nil
local thisReward = nil

local mysteryActions = {
    list = {
        "Acheter",
        "Visualiser"
    },

    index = 1
}

mystery_menu:IsVisible(function(Items)
    local mystery = Engine["Config"]["Shop"]["mystery"]
    local mysteryCount = Shared.Table:SizeOf(mystery)

    for i = 1, mysteryCount do
        local mysteryBox = mystery[i]

        Items:List(mysteryBox.label, mysteryActions.list, mysteryActions.index, nil, {}, true, {
            onActive = function()
                selectedCase = i
            end,
            onListChange = function(index)
                mysteryActions.index = index
                selectedIndex = index
            end,
            onSelected = function(index)
                if (index == 1) then
                    Client.Shop:buyMysteryBox(i)
                end
            end
        }, mystery_preview_menu, mysteryActions.index == 2)
    end
end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local mystery = Engine["Config"]["Shop"]["mystery"]
    local mysteryBox = mystery[selectedCase]
    local preview = mystery[selectedCase].preview

    Panels:info("Boutique",
        {"ID Boutique :", "OneCoins :", "Prix :"},
        {"~b~"..shopID, "~b~"..coins, "~b~"..mysteryBox.price}
    )
end)

mystery_preview_menu:IsVisible(function(Items)
    local mystery = Engine["Config"]["Shop"]["mystery"]
    local mysteryBox = mystery[selectedCase]

    for i = 1, Shared.Table:SizeOf(mysteryBox.reward) do
        local reward = mysteryBox.reward[i]
        Items:Button(reward.label, nil, {RightLabel = "~b~"..reward.rarety}, true, {
            onActive = function()
                thisReward = reward.preview
            end
        })
    end
end, function(Panels)
    local mystery = Engine["Config"]["Shop"]["mystery"]
    local preview = thisReward
    Panels:RenderSprite("weapon", preview)
end)

