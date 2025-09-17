exports("removeInventoryWeapon", function(licence, name, weaponID)
    MOD_inventory.InventoryCache.player[licence]:removeInventoryWeapon(name, weaponID)
end)