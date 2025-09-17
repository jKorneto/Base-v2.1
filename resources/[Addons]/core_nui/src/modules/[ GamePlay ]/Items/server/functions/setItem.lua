function MOD_Items:setItem(name, data)
    self.ItemsCache[name] = data

    if (self.ItemsCache[name].type == "weapons") then
        self:createUsableItem(self.ItemsCache[name].name, function(source, args, weaponid, ammo)
            local xPlayer = ESX.GetPlayerFromId(source)
            local WeaponSelect = xPlayer.getWeaponsById(weaponid)
            local WeaponAmmo = WeaponSelect.args.ammo
            local HashWeapon = GetHashKey(self.ItemsCache[name].name)
            local PlayerCurrentArmedId = xPlayer.get('currentWeapon')

            if (PlayerCurrentArmedId == nil) then
                if (WeaponAmmo == nil) then
                    xPlayer.setWeaponsAmmoById(weaponid, 0)
                    GiveWeaponToPed(GetPlayerPed(source), HashWeapon, 0, false, true)

                    TriggerClientEvent('OneLife:Inventory:WeaponSet', source, {
                        hash = HashWeapon, 
                        ammo = 0,
                        id = weaponid
                    })
                else
                    -- if (WeaponAmmo == 1) then WeaponAmmo = 0 end
                    if (WeaponAmmo < 0) then WeaponAmmo = 0 end
                    
                    GiveWeaponToPed(GetPlayerPed(source), HashWeapon, WeaponAmmo, false, true)

                    TriggerClientEvent('OneLife:Inventory:WeaponSet', source, {
                        hash = HashWeapon, 
                        ammo = WeaponAmmo,
                        id = weaponid
                    })

                    TriggerClientEvent("OneLife:Inventory:WeaponEquip", xPlayer.source)
                end
                xPlayer.set('currentWeapon', weaponid)
            elseif (PlayerCurrentArmedId == weaponid) then
                RemoveAllPedWeapons(GetPlayerPed(source))
                TriggerClientEvent('OneLife:Inventory:WeaponSet', source, nil)
                xPlayer.set('currentWeapon', nil)
                TriggerClientEvent("OneLife:Inventory:WeaponDisarm", xPlayer.source)
            elseif (PlayerCurrentArmedId ~= weaponid) then
                RemoveAllPedWeapons(GetPlayerPed(source))
                TriggerClientEvent('OneLife:Inventory:WeaponSet', source, nil)
                xPlayer.set('currentWeapon', nil)
                TriggerClientEvent("OneLife:Inventory:WeaponDisarm", xPlayer.source)
            end
        end)
    end
end