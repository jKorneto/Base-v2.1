---@type Vehicle
Vehicle = Class.new(function(class)

    ---@class Vehicle: BaseObject
    local self = class;

    ---@return string
    function self:GeneratePlate()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        local nums = "0123456789"
        local plateChars = {}
        
        for i = 1, 4 do
            local randIndex = math.random(1, #nums)
            table.insert(plateChars, nums:sub(randIndex, randIndex))
        end

        for i = 1, 3 do
            local randIndex = math.random(1, #chars)
            table.insert(plateChars, chars:sub(randIndex, randIndex))
        end

        for i = #plateChars, 2, -1 do
            local j = math.random(1, i)
            plateChars[i], plateChars[j] = plateChars[j], plateChars[i]
        end

        return table.concat(plateChars)
    end

    return self;
end);
