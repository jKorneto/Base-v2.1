---@type Elevator
Elevator = Class.new(function(class)

    ---@class Elevator: BaseObject
    local self = class;

    ---@return player
    ---@return vector3
    ---@return heading
    function self:Teleport(player, pos, heading)
        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(player, pos)
        SetEntityHeading(player, heading)
        Wait(500)
        DoScreenFadeIn(500)
    end

    return self;
end);
