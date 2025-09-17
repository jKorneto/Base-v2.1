function MOD_inventory:loadVehiculeInventory(plate, data, slots, maxweight, class)
    MOD_inventory.InventoryCache.vehicule[plate] = _OneLifeInventory('vehicule', data, nil, slots, maxweight, class)

    return (MOD_inventory.InventoryCache.vehicule[plate])
end