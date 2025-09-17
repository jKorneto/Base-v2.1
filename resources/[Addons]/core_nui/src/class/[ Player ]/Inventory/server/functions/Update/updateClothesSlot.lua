function _OneLifeInventory:updateClothesSlot(indexInv, InvData, indexClothes, ClothesData)
    self:reloadWeight()

    local InvData = { index = indexInv, data = InvData }
    local ClothesData = { index = indexClothes, data = ClothesData }

    if (self.type == 'player') then
        TriggerClientEvent('OneLife:Inventory:UpdateClothesSlot', self.class.source, InvData, ClothesData, self.weight, self.maxweight)
    end
end