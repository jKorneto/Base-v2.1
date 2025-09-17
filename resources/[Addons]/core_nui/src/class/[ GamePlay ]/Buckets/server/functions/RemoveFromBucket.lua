function _OneLifeBuckets:RemoveFromBucket(entity, _type)
    assert(type(entity) == "string" or type(entity) == "number", "Entity must be a string or a number")
    assert(type(_type) == "string", "_type must be a string")

    local IsRegistered, index = self:IsRegistered(entity, _type)

    -- print(IsRegistered, index)

    if (_type == "object" and IsRegistered) then
        exports["Framework"]:SetEntityRoutingBucket(entity, 0)

        table.remove(self.objectsInBuckets, index)
    elseif (_type == "player" and IsRegistered) then
        exports["Framework"]:SetPlayerRoutingBucket(entity, 0)

        table.remove(self.playersInBuckets, index)
    else
        print("Error: type must be object or player")
    end
end