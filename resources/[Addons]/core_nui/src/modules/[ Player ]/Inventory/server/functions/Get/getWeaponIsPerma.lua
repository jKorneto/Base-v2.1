function MOD_inventory:getWeaponIsPerma(name)
    for i=1, #Configcore_nui.permanentWeapons, 1 do
        if (string.lower(Configcore_nui.permanentWeapons[i]) == name) then
            return true
        end
    end

    return false
end