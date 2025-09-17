_OneLifeCoffreProperties = {}

local __instance = {
    __index = _OneLifeCoffreProperties
}

setmetatable(_OneLifeCoffreProperties, {
    __call = function(_, inventory, propertiesName, maxWeight)
        local self = setmetatable({}, __instance)

        self.propertiesName = propertiesName

        local defaultSlots = 100
        self.inventoryClass = MOD_inventory:loadPropertiesInventory(propertiesName, inventory, defaultSlots, maxWeight, self)

        --Functions
        exportMetatable(_OneLifeCoffreProperties, self)

        MOD_CoffreProperties.list[propertiesName] = self

        return (self)
    end
})