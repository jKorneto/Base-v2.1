function _OneLifeInventory:setInventoryVisible(bool)

    if (not bool) then
        if (self.SecondInventoryOpen) then
            TriggerServerEvent('OneLife:Inventory:PlayerSyncRemoveSecond')
            self.SecondInventoryOpen = false
        end
        self.SecondInventoryItems = nil

        self:setSecondInventory(self.SecondInventoryItems, nil, nil, nil)
    end

    sendUIMessage({
        ShowInventory = bool
    })

    self.StateInventory = bool

    self.CurrentGiveItem = false
end