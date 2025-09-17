---@overload fun(): ClothesShop
Heist = Class.new(function(class)
    ---@class Heist: BaseObject
    local self = class
    local robberies = {}
    local playersTimer = {}

    function self:getRandomHouse()
        local houses = Engine["Config"]["Heist"]["Houses"]
        local categories = {}
    
        for category, _ in pairs(houses) do
            table.insert(categories, category)
        end

        math.randomseed(GetGameTimer())
    
        local randomCategory = categories[math.random(#categories)]
        local selectedCategory = houses[randomCategory]
        local randomIndex = math.random(#selectedCategory)
        local selectedHouse = selectedCategory[randomIndex]
        local hasSleepingPed = math.random(1, 4) == 1

        return {
            category = randomCategory,
            position = selectedHouse.position,
            image = selectedHouse.image,
            hasSleepingPed = hasSleepingPed
        }
    end

    ---@param xPlayer Player
    function self:addPlayerInRobbery(xPlayer, category, position, hasSleepingPed)
        local identifier = xPlayer.identifier

        if (not self:isPlayerInRobbery(identifier)) then
            robberies[identifier] = {
                category = category,
                position = position,
                hasSleepingPed = hasSleepingPed
            }
        end
    end

    function self:removePlayerInRobbery(identifier)
        if (self:isPlayerInRobbery(identifier)) then
            robberies[identifier] = nil
        end
    end

    function self:isPlayerInRobbery(identifier)
        return robberies[identifier] ~= nil
    end

    function self:getPlayerInRobbery(identifier)
        return robberies[identifier]
    end

    function self:getPoliceInService()
        return exports["core"]:GetPoliceInService()
    end

    function self:startPlayerTimer(identifier)
        playersTimer[identifier] = Shared.Timer(60 * 30)
        playersTimer[identifier]:Start()
    end

    function self:removePlayerTimer(identifier)
        playersTimer[identifier] = nil
    end

    function self:getPlayerTimer(identifier)
        return playersTimer[identifier]
    end

    return self
end)