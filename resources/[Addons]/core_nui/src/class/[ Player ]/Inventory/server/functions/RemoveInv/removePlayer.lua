function _OneLifeInventory:removePlayer(source)
    if (self.playersOpened[source]) then
        self.playersOpened[source] = nil
    end
end