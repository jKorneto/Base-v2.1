exports("GetPermanentWeapons", function()

    return Config["Weapons"]["PERMANENT_WEAPONS"];

end);

exports("IsWeaponPermanent", function(weaponName)

    return Shared:IsWeaponPermanent(weaponName);

end);