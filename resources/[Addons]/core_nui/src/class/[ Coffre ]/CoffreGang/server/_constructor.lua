_OneLifeCoffreGang = {}

local __instance = {
    __index = _OneLifeCoffreGang
}

setmetatable(_OneLifeCoffreGang, {
    __call = function(_, jobName, coords, inventory, maxWeight, maxSlots)
        local self = setmetatable({}, __instance)

        self.jobName = jobName

        self.coordsCoffre = coords

        self.inventoryClass = MOD_inventory:loadGangInventory(jobName, inventory, maxSlots or 100, maxWeight or 1500, self)

        --Functions
        exportMetatable(_OneLifeCoffreGang, self)

        MOD_CoffreGang.list[jobName] = self

        return (self)
    end
})