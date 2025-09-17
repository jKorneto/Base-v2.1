---@type GameObject
GameObject = Class.new(function(class)

    ---@class GameObject: BaseObject
    local self = class

    ---@private
    function self:Constructor()
        Shared:Initialized("Game.Object")
    end

    ---@param objectHash number | string
    ---@param coords table | vector3
    ---@param callback fun(obj: number)
    function self:Spawn(objectHash, coords, callback)
        local model = type(objectHash) == 'number' and objectHash or GetHashKey(objectHash)
        local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

        CreateThread(function()
            Game.Streaming:RequestModel(model)
            local obj = CreateObject(model, vector.xyz, false, false, true)

            if (callback) then
                callback(obj)
            end
        end)
    end

    ---@param object number
    ---@return boolean
    function self:Delete(object)
        if (not object) then 
            return error("Attempt to delete an invalid object")
        end

        if (DoesEntityExist(object)) then
            DeleteObject(object)
            return true
        else
            return error("Attempt to delete an invalid object")
        end

        return false
    end

    return self
end)