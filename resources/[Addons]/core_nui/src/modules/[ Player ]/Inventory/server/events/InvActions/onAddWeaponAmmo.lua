RegisterNetEvent('OneLife:Inventory:AddWeaponAmmo')
AddEventHandler('OneLife:Inventory:AddWeaponAmmo', function(weaponid, ammo, src)
    if (src ~= nil) then 
        source = src 
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    if (not weaponid) then
        weaponid = xPlayer.get('currentWeapon')
    end

    local WeaponSelect = xPlayer.getWeaponsById(weaponid)
    local WeaponAmmo = WeaponSelect.args.ammo

    local NewAmmo = (WeaponAmmo + ammo)

    xPlayer.setWeaponsAmmoById(weaponid, NewAmmo)
end)