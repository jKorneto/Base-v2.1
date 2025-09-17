function _OneLifeInventory:removeInventoryWeapon(name, itemid)
    RemoveAllPedWeapons(GetPlayerPed(self.class.source))
    local ItemInfo = MOD_Items:getItem(name)

    if (ItemInfo == nil) then print("This Item not exist", name) return false end
    local SlotItem

    for i= 1, #self.inventoryItems['weapons'], 1 do
        local weapons = self.inventoryItems['weapons'][i]

        if (weapons ~= "empty") then
            if (itemid) then
                if (weapons.id == itemid) then
                    self.inventoryItems['weapons'][i] = "empty"
                end
            else
                if (weapons.name == name) then
                    self.inventoryItems['weapons'][i] = "empty"
                    SlotItem = i
                end
            end
        end
    end

    for i= 1, #self.inventoryItems, 1 do
        local weapons = self.inventoryItems[i]

        if (weapons ~= "empty") then
            if (itemid) then
                if (weapons.id == itemid) then
                    self.inventoryItems[i] = "empty"
                end
            else
                if (weapons.name == name) then
                    self.inventoryItems[i] = "empty"
                    SlotItem = i
                end
            end
        end
    end

    self:updateInventory()
end