_OneLifeItems = {}

local __instance = {
    __index = _OneLifeItems
}

setmetatable(_OneLifeItems, {
    __call = function(_, type, data)
        local self = setmetatable({}, __instance)
    
        self.type = type
        self.name = data.name
        self.label = data.label
        self.weight = data.weight
        self.unique = false

        if (data.unique == 1) then
            self.unique = true
        end
        

        --Functions
        exportMetatable(_OneLifeItems, self)

        return (self)
    end
})