function MOD_inventory:loadCoffreBuilderInventory(coffreId, items, slots, maxweight, class)
    MOD_inventory.InventoryCache.coffrebuilder[coffreId] = _OneLifeInventory('coffrebuilder', items, nil, slots, maxweight, class)

    return (MOD_inventory.InventoryCache.coffrebuilder[coffreId])
end