RegisterNetEvent('OneLife:Inventory:RemoveWeaponAmmo')
AddEventHandler('OneLife:Inventory:RemoveWeaponAmmo', function(weaponid, ammo)
    local xPlayer = ESX.GetPlayerFromId(source)

    local WeaponSelect = xPlayer.getWeaponsById(weaponid)
    local WeaponAmmo = WeaponSelect.args.ammo
    local NewAmmo = (WeaponAmmo - ammo)
    local throwableWeapon = Configcore_nui.filterItem.throwables[GetHashKey(WeaponSelect.name)]

    if (throwableWeapon and NewAmmo == 0) then
        MOD_inventory.InventoryCache.player[xPlayer.identifier]:removeInventoryWeapon(WeaponSelect.name, weaponid)
        return
    end

    xPlayer.setWeaponsAmmoById(weaponid, NewAmmo)
end)