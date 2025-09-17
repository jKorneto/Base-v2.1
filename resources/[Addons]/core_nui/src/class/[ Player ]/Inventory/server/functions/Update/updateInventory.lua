function _OneLifeInventory:updateInventory()
    self:reloadWeight()

    TriggerClientEvent('OneLife:Inventory:UpdatePlayerInventory', self.class.source, self.inventoryItems, self.inventoryClothes, self.weight, self.maxweight)

end