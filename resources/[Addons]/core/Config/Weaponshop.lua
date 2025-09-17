Config["Weaponshop"] = {}

Config["Weaponshop"]["Pos"] = {
    vector3(-662.4192, -935.4647, 21.82921),
    vector3(1693.578, 3759.426, 34.7053),
    vector3(-330.4556, 6083.456, 31.45476),
    vector3(251.9472, -49.86555, 69.94102),
    vector3(21.82369, -1107.19, 29.797),
    vector3(2568.004, 294.5252, 108.7348),
    vector3(-1117.884, 2698.496, 18.55412),
    vector3(842.4682, -1033.3, 28.19486),
    vector3(-1305.939, -394.0775, 36.69574),
    vector3(-3172.08, 1087.62, 20.83),
    vector3(810.34, -2157.46, 29.61)
}

Config["Weaponshop"]["PPAPrice"] = 250000

Config["Weaponshop"]["List"] = {
    ["White"] = {
        { label = "Couteau", name = "WEAPON_KNIFE", price = 5000 },
        { label = "Dague Antique", name = "WEAPON_DAGGER", price = 6500 },
        { label = "Batte de Baseball", name = "WEAPON_BAT", price = 7500 },
    },
    ["Letale"] = {
        { label = "Pistolet SNS", name = "WEAPON_SNSPISTOL", price = 130000 },
        { label = "Beretta", name = "WEAPON_PISTOL", price = 180000 },
    },
    ["Accessories"] = {
        { label = "Silencieux Leger", name = "at_suppressor_light", price = 20000, description = "Permet de réduire le bruit des armes légères" },
        { label = "Silencieux Lourd", name = "at_suppressor_heavy", price = 45000, description = "Permet de réduire le bruit des armes lourdes" },
        { label = "Poigné avant", name = "at_grip", price = 12500, description = "Permet de réduire le recul de l'arme" },
        { label = "Lampes", name = "at_flashlight", price = 12500, description = "Permet de voir dans les endroits sombres" },
    },
    ["Munitions"] = {
        { label = "Munitions de 9mm", name = "9mm_bullet", price = 10, description = "Munitions pour Pistolet" },
        { label = "Munitions de 45 ACP", name = "45_acp_bullet", price = 20, description = "Munitions pour Armes Automatiques" },
        { label = "Munitions de 12 gauge", name = "12_gauge_bullet", price = 30, description = "Munitions pour Fusil a Pompe" },
        { label = "Munitions de 5.56mm", name = "5.56mm_bullet", price = 40, description = "Munitions pour Fusil d'assaut" },
        { label = "Munitions de 7.62mm", name = "7.62mm_bullet", price = 50, description = "Munitions pour Fusil de Précision" }
    },
    ["VIP"] = {
        { label = "Pistolet SNS MK2", name = "WEAPON_SNSPISTOL_MK2", price = 200000 },
        { label = "Calibre 50", name = "WEAPON_PISTOL50", price = 385000 },
    }
}