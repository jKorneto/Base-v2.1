local Module <const> = {}
---@type { [string]: ShopClass }
Module.Shops = {}

ScriptServer.Managers.Shops = Module

function Module:GetShop(shopID)
    return self.Shops[shopID] or nil
end
