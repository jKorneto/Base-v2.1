_OneLifeBuckets = {}

local __instance = {
    __index = _OneLifeBuckets
}

setmetatable(_OneLifeBuckets, {
    __call = function(_, BucketId)
        local self = setmetatable({}, __instance)

        self.bucket = BucketId

        self.playersInBuckets = {}
        self.objectsInBuckets = {}

        --Functions
        exportMetatable(_OneLifeBuckets, self)

        return (self)
    end
})