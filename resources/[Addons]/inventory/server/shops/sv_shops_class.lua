---@class ShopClass:ShopConstructor
---@field blips API_Server_BlipBase[]
---@field peds API_Server_PedBase[]
local Module <const> = {}
Module.__index = Module

ScriptServer.Classes.Shop = Module

---@class ShopConstructor
---@field shopId string
---@field items ShopItem[]
---@field shopName string

---@param allData ShopStaticData
Module.new = function(id, allData)
    local self = setmetatable({}, Module)

    self.shopName = allData.label:upper()
    self.shopId = id
    self.items = {}

    for i = 1, #allData.items do
        local v = allData.items[i]
        local iData = ScriptShared.Items:Get(v.name)
        if iData then
            self.items[#self.items + 1] = {
                data = iData,
                meta = type(v.meta) == "table" and v.meta or type(iData.defaultMeta) == "table" and iData.defaultMeta or
                    {},
                name = v.name,
                price = v.price
            }
        end
    end

    ScriptServer.Managers.Shops.Shops[self.shopId] = self

    return self
end

function Module:openShop(source)
    TriggerClientEvent("inventory:PLAYER_SEND_NUI_MESSAGE", source, {
        event = "OPEN_SHOP",
        items = self.items,
        shopId = self.shopId,
        shopName = self.shopName
    })
end

function Module:GetShopItemOnSlot(slot)
    return self.items[slot] or nil
end

for k, v in pairs(ScriptShared.Shops) do
    ScriptServer.Classes.Shop.new(k, v)
end
