Engine["Config"]["Shop"] = {}

Engine["Config"]["Shop"]["tebexUrl"] = "https://boutique.oneliferp.net/"
Engine["Config"]["Shop"]["vehiclePreview"] = vector4(-1072.466919, -74.795967, -94.599785, 0.43852466344833)
Engine["Config"]["Shop"]["containerPreview"] = vector4(-1072.466919, -74.795967, -94.599785, 0.43852466344833)
Engine["Config"]["Shop"]["containerZone"] = vector3(-1072.588379, -67.383080, -94.599785)
Engine["Config"]["Shop"]["vipReduction"] = 15

Engine["Config"]["Shop"]["weapons"] = {
    [1] = {label = "Couteau Cran d'Arrêt", name = "weapon_switchblade", price = 1000},
    [2] = {label = "Pistolet MK-2", name = "weapon_pistol_mk2", price = 1500},
    [3] = {label = "ADP - Arme de Défense Personnel", name = "weapon_combatpdw", price = 3500},
    [4] = {label = "Ak-47", name = "weapon_assaultrifle", price = 5000},
}

Engine["Config"]["Shop"]["ex_weapons"] = {
    [1] = {label = "RPG Tah les Oufs", name = "weapon_rpg", price = 1337},
}

Engine["Config"]["Shop"]["vehicles"] = {
    { label = "Pfister 811 S", name = "gb811s2", price = 2500 },
    { label = "Obey Argento 7F", name = "gbargento7f", price = 2500 },
    { label = "Karin Mogul RS", name = "gbmogulrs", price = 2750 },
    { label = "Karin Sultan RSX", name = "gbsultanrsx", price = 2750 },
    { label = "Bravado Banshee S", name = "gbbanshees", price = 1500 },
    { label = "Bravado Bison HF", name = "gbbisonhf", price = 2500 },
    { label = "Burgerfahrzeug Club XR", name = "gbclubxr", price = 1500 },
    { label = "Pfister Comet S 1T", name = "gbcomets1t", price = 2000 },
    { label = "Comet S 2R", name = "gbcomets2r", price = 3000 },
    { label = "Grotti Brioso S", name = "gbbriosof", price = 1250},
    { label = "Vapid Dominator GSX", name = "gbdominatorgsx", price = 2000 },
    { label = "Progen TR3", name = "gbtr3s", price = 2500 },
    { label = "Pegassi Prospero", name = "gbprospero", price = 3000 },
    { label = "Enus Sapphire", name = "gbsapphire", price = 2500 },
    { label = "Benefactor Schlagen R", name = "gbschlagenr", price = 2500 },
    { label = "Benefactor Schlagen SP", name = "gbschlagensp", price = 2000 },
    { label = "Benefactor Schrauber", name = "gbschrauber", price = 2000 },
    { label = "Benefactor Schwartzer", name = "gbschwartzers", price = 2500 },
    { label = "Lampadati Sentinel GTS", name = "gbsentinelgts", price = 2000 },
    { label = "Dewbauchee Solace", name = "gbsolace", price = 1500 },
    { label = "Dewbauchee Solace V", name = "gbsolacev", price = 2000 },
    { label = "Bordeaux Vivant", name = "gbvivant", price = 1000 },
}

Engine["Config"]["Shop"]["Package"] = {
    [1] = {label = "Création de gang", name = "gang", price = 4000},
    [2] = {label = "Création d'organisation", name = "organization", price = 5500},
    [3] = {label = "Vente d'arme illégal", name = "weapon", price = 10000},
    [4] = {label = "Certification InstaPic", name = "instapic", price = 1500},
    [5] = {label = "Certification Birdy", name = "birdy", price = 1500}
}

Engine["Config"]["Shop"]["Subscription"] = {
    [1] = {label = "Abonnement VIP (~b~1 mois~s~)", url = "https://boutique.oneliferp.net/category/abonnements", price = "10€"},
    [2] = {label = "Abonnement VIP (~b~3 mois~s~)", url = "https://boutique.oneliferp.net/category/abonnements", price = "25€"},
    [3] = {label = "Abonnement VIP (~b~6 mois~s~)", url = "https://boutique.oneliferp.net/category/abonnements", price = "45€"},
}

Engine["Config"]["Shop"]["Chance"] = {
    ["COMMON"] = 7.5,
    ["RARE"] = 6,
    ["EPIC"] = 4,
    ["LENGENDARY"] = 2
}

Engine["Config"]["Shop"]["mystery"] = {
    [1] = {
        name = "case_legendary",
        label = "Conteneur Légendaire",
        price = 2000,
        reward = {
            { label = "ADP - Arme de Défense Personnel", rarety = "LENGENDARY", type = "weapon", reward = "weapon_combatpdw", preview = "weapon_combatpdw" },
            { label = "Bison HF", rarety = "LENGENDARY", type = "vehicle", reward = "gbbisonhf", preview = "gbbisonhf" },
            { label = "1500 OneCoins", rarety = "LENGENDARY", type = "coins", reward = 1500, preview = "coins" },
            { label = "250 000$", rarety = "EPIC", type = "money", reward = 2500000, preview = "money" },
            { label = "Special Hammer", rarety = "EPIC", type = "weapon", reward = "weapon_specialhammer", preview = "weapon_specialhammer" },
            { label = "10X Kevlar", rarety = "EPIC", type = "items", reward = "kevlar", quantity = 10, preview = "kevlar" },
            { label = "700 OneCoins", rarety = "COMMON", type = "coins", reward = 700, preview = "coins" },
            { label = "Grotti Brioso", rarety = "COMMON", type = "vehicle", reward = "gbbriosof", preview = "gbbriosof" },
            { label = "Bordeaux Vivant", rarety = "COMMON", type = "vehicle", reward = "gbvivant", preview = "gbvivant" },
        }
    },
    [2] = {
        name = "case_ultimate",
        label = "Conteneur Ultime",
        price = 3000,
        reward = {
            { label = "Ak-47", rarety = "LENGENDARY", type = "weapon", reward = "weapon_assaultrifle", preview = "weapon_assaultrifle" },
            { label = "Karin Mogul RS", rarety = "LENGENDARY", type = "vehicle", reward = "gbmogulrs", preview = "gbmogulrs" },
            { label = "2000 OneCoins", rarety = "LENGENDARY", type = "coins", reward = 2000, preview = "coins"},
            { label = "400 000$", rarety = "EPIC", type = "money", reward = 400000, preview = "money" },
            { label = "Parabatte", rarety = "EPIC", type = "weapon", reward = "weapon_penis", preview = "weapon_penis" },
            { label = "20X Kevlar", rarety = "EPIC", type = "items", reward = "kevlar", quantity = 20, preview = "kevlar" },
            { label = "1000 OneCoins", rarety = "COMMON", type = "coins", reward = 1000, preview = "coins" },
            { label = "Lampadati Sentinel GTS", rarety = "COMMON", type = "vehicle", reward = "gbsentinelgts", preview = "gbsentinelgts" },
            { label = "Vapid Dominator GSX", rarety = "COMMON", type = "vehicle", reward = "gbdominatorgsx", preview = "gbdominatorgsx" },
        }
    },
    [3] = {
        name = "case_infinity",
        label = "Conteneur Infinity",
        price = 6000,
        reward = {
            { label = "SCAR 17", rarety = "LENGENDARY", type = "weapon", reward = "weapon_scar17", preview = "weapon_scar17" },
            { label = "TEC 9", rarety = "LENGENDARY", type = "weapon", reward = "weapon_tec9m", preview = "weapon_tec9m" },
            { label = "3500 OneCoins", rarety = "LENGENDARY", type = "coins", reward = 3500, preview = "coins"},
            { label = "Karin Mogul RS", rarety = "EPIC", type = "vehicle", reward = "gbmogulrs", preview = "gbmogulrs" },
            { label = "700 000$", rarety = "EPIC", type = "money", reward = 700000, preview = "money"},
            { label = "40X Kevlar", rarety = "EPIC", type = "items", reward = "kevlar", quantity = 40, preview = "kevlar" },
            { label = "2000 OneCoins", rarety = "COMMON", type = "coins", reward = 2000, preview = "coins" },
            { label = "Lampadati Sentinel GTS", rarety = "COMMON", type = "vehicle", reward = "gbsentinelgts", preview = "gbsentinelgts" },
            { label = "Karin Sultan RSX", rarety = "COMMON", type = "vehicle", reward = "gbsultanrsx", preview = "gbsultanrsx" },
        }
    }
}
