function MOD_CoffreSociety:loadCoffreSociety(jobName, coords, inventory, maxWeight, maxSlots)
    if (self.list[jobName] == nil) then
        _OneLifeCoffreSociety(jobName, coords, inventory, maxWeight, maxSlots)
    end
end