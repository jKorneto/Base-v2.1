function _OneLifeInventory:LoadFilterType()
    for i=1, #self.inventoryItems, 1 do
        if (self.inventoryItems[i] ~= "empty") then
            for k=1, #Configcore_nui.filterItem['weapons'] do
                local ItemName = Configcore_nui.filterItem['weapons'][k]
                if (self.inventoryItems[i].name == ItemName) then
                    self.inventoryItems[i].filterType = 'weapons'
                end
            end
            for k=1, #Configcore_nui.filterItem['foods'] do
                local ItemName = Configcore_nui.filterItem['foods'][k]
                if (self.inventoryItems[i].name == ItemName) then
                    self.inventoryItems[i].filterType = 'foods'
                end
            end
            for k=1, #Configcore_nui.filterItem['clothes'] do
                local ItemName = Configcore_nui.filterItem['clothes'][k]
                if (self.inventoryItems[i].name == ItemName) then
                    self.inventoryItems[i].filterType = 'clothes'
                end
            end
        end
    end
end