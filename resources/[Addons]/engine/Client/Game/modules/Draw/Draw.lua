---@type GameDraw
GameDraw = Class.new(function(class)

    ---@class GameDraw: BaseObject
    local self = class

    ---@private
    function self:Constructor()
        Shared:Initialized("Game.Draw")
    end

    ---@param coords table | vector3
    ---@param text string
    ---@param size number
    ---@param font number
    function self:Text3D(coords, text, size, font)
        local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

        local camCoords = GetFinalRenderedCamCoord()
        local distance = #(vector - camCoords)

        if not size then size = 1 end
        if not font then font = 0 end

        local scale = (size / distance) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov

        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        BeginTextCommandDisplayText('STRING')
        SetTextCentre(true)
        AddTextComponentSubstringPlayerName(text)
        SetDrawOrigin(vector.xyz, 0)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()
    end

    return self
end)