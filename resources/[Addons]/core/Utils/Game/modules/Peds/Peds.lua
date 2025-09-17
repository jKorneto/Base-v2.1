---@type GamePeds
GamePeds = Class.new(function(class)

    ---@class GamePeds: BaseObject
    local self = class;

    ---@param pedHash number | string
    ---@param coords table | vector3
    ---@param heading number
    ---@param isInvincible boolean
    ---@param isFreeze boolean
    ---@param callback fun(obj: number)
    function self:Spawn(pedHash, coords, heading, isInvincible, isFreeze, callback)
        local model = type(pedHash) == 'number' and pedHash or GetHashKey(pedHash)
        local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
        CreateThread(function()
            Game.Streaming:RequestModel(model)
            local ped = CreatePed(4, model, vector.xyz, heading, false, false, true)
            SetEntityInvincible(ped, isInvincible)
            FreezeEntityPosition(ped, isFreeze)
            SetBlockingOfNonTemporaryEvents(ped, true)

            if (callback) then
                callback(ped);
            end
        end);
    end

    return self;
end);