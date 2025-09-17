_OneLifeCoffreSociety = {}

local __instance = {
    __index = _OneLifeCoffreSociety
}

setmetatable(_OneLifeCoffreSociety, {
    __call = function(_, jobName, coords, inventory, maxWeight, maxSlots)
        local self = setmetatable({}, __instance)

        self.jobName = jobName

        self.coordsCoffre = coords

        local defaultSlots = maxSlots or 100
        self.inventoryClass = MOD_inventory:loadSocietyInventory(jobName, inventory, defaultSlots, maxWeight, self)

        --Functions
        exportMetatable(_OneLifeCoffreSociety, self)

        MOD_CoffreSociety.list[jobName] = self

        return (self)
    end
})