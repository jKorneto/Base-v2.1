function _OneLifeInventory:updateSecondInventory(src)
    self:reloadWeight()

    if (self.type == "player") then
        local PlayerItems = {}

        for i=1, #self.inventoryItems, 1 do
            if (self.inventoryItems[i] ~= "empty") then
                table.insert(PlayerItems, self.inventoryItems[i])
            end
        end
        for i=1, #self.inventoryItems['weapons'], 1 do
            if (self.inventoryItems['weapons'][i] ~= "empty") then
                table.insert(PlayerItems, self.inventoryItems['weapons'][i])
            end
        end

        TriggerClientEvent('OneLife:Inventory:setSecondInventory', src, PlayerItems, self.inventoryName, self.weight, self.maxweight)
        -- TriggerClientEvent('OneLife:Inventory:setSecondInventory', src, self.inventoryItems, self.inventoryName, self.weight, self.maxweight)
    else
        TriggerClientEvent('OneLife:Inventory:setSecondInventory', src, self.inventoryItems, self.inventoryName, self.weight, self.maxweight)
    end
end