function _OneLifeCoffreGang:saveInventory()
    MySQL.Async.execute('UPDATE gangbuilder SET inventory = @inventory WHERE name = @name', {
        name = self.jobName,
        inventory = json.encode(MOD_inventory.InventoryCache.gang[self.jobName]:saveInventory())
    })
end