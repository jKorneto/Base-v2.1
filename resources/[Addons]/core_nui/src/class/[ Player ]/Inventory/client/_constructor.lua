_OneLifeInventory = {}

local __instance = {
    __index = _OneLifeInventory
}

setmetatable(_OneLifeInventory, {
    __call = function(_)
        local self = setmetatable({}, __instance)

        self.StateInventory = false

        self.settings = {}

        self.inventoryStatic = {}

        self.inventoryItems = {}
        self.inventoryWeapons = {}
        self.inventoryClothes = {}

        self.SecondInventoryOpen = false
        self.SecondInventoryItems = nil

        self.GiveItemTablePlayer = {}
        self.CurrentGiveItem = false

        self.CurrentPedPreview = nil

        --Functions
        exportMetatable(_OneLifeInventory, self)


        self:DeletePedScreen()
        self:desactivateWheel()
        self:StartkeyUtils()

        return (self)
    end
})