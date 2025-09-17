---@type GamePeds
GamePeds = Class.new(function(class)

    ---@class GamePeds: BaseObject
    local self = class

    ---@private
    function self:Constructor()
        Shared:Initialized("Game.Peds")
    end

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
                callback(ped)
            end
        end)
    end

    function self:Delete(ped)
        if (not ped) then 
            return error("Attempt to delete an invalid ped")
        end

        if (DoesEntityExist(ped)) then
            DeletePed(ped)
            return true
        else
            return error("Attempt to delete an invalid ped")
        end

        return false
    end

    ---@param otherPeds boolean
    function self:GetPeds(otherPeds)
        local peds, myPed, pool = {}, PlayerPedId(), GetGamePool('CPed')

        for i = 1, #pool do
            if ((otherPeds and pool[i] ~= myPed) or not otherPeds) then
                peds[#peds + 1] = pool[i]
            end
        end

        return peds;
    end

    return self
end)