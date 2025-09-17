Engine["Config"]["Mecano"] = {}

Engine["Config"]["Mecano"]["Zones"] = {
    ["mecano"] = {
        jobName = "mecano",
        jobLabel = "Benny's",
        minPercentage = 5,
        maxPercentage = 20,
        customType = "esthetics", -- esthetics / performance / all
        menuStyle = "bennys", -- mecano / bennys / lscustom
        flatbedModel = "flatbed",
        cloakRoom = vector3(-198.761, -1372.232, 30.590),
        craftZone = vector3(-193.790253, -1328.442871, 30.586998),
        customZones = {
            vector3(-213.580, -1328.302, 30.690),
            vector3(-213.512, -1339.0109, 30.690),
            vector3(-213.287, -1350.382, 30.690),
            vector3(-196.598, -1334.181, 30.690),
            vector3(-196.520, -1322.848, 30.690)
        },
        announcements = {
            ["open"] = "Nous sommes maintenant ouverts ! Venez découvrir nos services et repartez avec un style unique sur la route.",
            ["close"] = "Nous sommes actuellement fermés. Revenez bientôt pour des améliorations de qualité et un service exceptionnel.",
            ["recruitment"] = "Une session de recrutement est en cours ! Si vous êtes passionné de mécanique, rendez-vous directement à notre garage pour postuler et faire partie de l'aventure.",
        },
        blip = {
            label = "Mecano | Benny's",
            sprite = 446,
            color = 5
        }
    },
    ["mecano2"] = {
        jobName = "mecano2",
        jobLabel = "Ls Custom",
        minPercentage = 5,
        maxPercentage = 20,
        customType = "performance", -- esthetics / performance / all
        menuStyle = "lscustom", -- mecano / bennys / lscustom
        flatbedModel = "flatbed",
        cloakRoom = vector3(-622.408, -1125.674, 22.335),
        craftZone = vector3(-622.264, -1144.896, 22.335),
        customZones = {
            vector3(-605.210, -1118.234, 22.352),
            vector3(-612.827, -1118.720, 22.352),
            vector3(-617.173, -1145.225, 22.335),
            vector3(-617.297729, -1151.087036, 22.335917),
            vector3(-617.467651, -1157.163940, 22.335917),
            vector3(-617.412415, -1163.134399, 22.335917)
        },
        announcements = {
            ["open"] = "Nous sommes maintenant ouverts ! Venez découvrir nos services et repartez avec un style unique sur la route.",
            ["close"] = "Nous sommes actuellement fermés. Revenez bientôt pour des améliorations de qualité et un service exceptionnel.",
            ["recruitment"] = "Une session de recrutement est en cours ! Si vous êtes passionné de mécanique, rendez-vous directement à notre garage pour postuler et faire partie de l'aventure.",
        },
        blip = {
            label = "Mecano | Ls Custom",
            sprite = 777,
            color = 29
        }
    },
}

Engine["Config"]["Mecano"]["Items"] = {
    ["clean"] = "chiffon_clean",
    ["repair"] = "repairkit",
    ["unlock"] = "kitcrochetage"
}

Engine["Config"]["Mecano"]["CraftItems"] = {
    [1] = {label = "Kit de nettoyage", item = "chiffon_clean", time = 3, price = 600}, -- time in seconds
    [2] = {label = "Kit de réparation", item = "repairkit", time = 5, price = 600},
    [3] = {label = "Kit de crochetage", item = "kitcrochetage", time = 4, price = 700}
}

Engine["Config"]["Mecano"]["MenuStyle"] = {
    ["mecano"] = "interaction_mecano",
    ["bennys"] = "interaction_bennys",
    ["lscustom"] = "interaction_lscustom"
}

Engine["Config"]["Mecano"]["MenuColors"] = {
    ["mecano"] = {
        R = 203,
        G = 202,
        B = 205,
        A = 255
    },
    ["bennys"] = {
        R = 73,
        G = 18,
        B = 28,
        A = 255
    },
    ["lscustom"] = {
        R = 49,
        G = 50,
        B = 97,
        A = 255
    }
}

Engine["Config"]["Mecano"]["Multiplier"] = {
    ["compacts"] = 1.1,
    ["sedans"] = 1.1,
    ["suvs"] = 1.2,
    ["coupes"] = 1.1,
    ["muscle"] = 1.3,
    ["sports_classics"] = 1.4,
    ["sports"] = 1.4,
    ["super"] = 1.5,
    ["motorcycles"] = 1.2,
    ["offroad"] = 1.2,
    ["industrial"] = 1.1,
    ["utility"] = 1.1,
    ["vans"] = 1.1,
    ["cycles"] = 1.0,
    ["boats"] = 1.3,
    ["helicopters"] = 1.4,
    ["planes"] = 1.5,
    ["service"] = 1.1,
    ["emergency"] = 1.1,
    ["military"] = 1.5,
    ["commercial"] = 1.1,
    ["trains"] = 1.1,
    ["open_wheel"] = 1.6
}

Engine["Config"]["Mecano"]["Prices"] = {
    ["cleanVehicle"] = 1200,
    ["repairVehicle"] = 1200,
    ["bumperFront"] = 3500,
    ["bumperBack"] = 3500,
    ["chassis"] = 4000,
    ["exhaust"] = 1100,
    ["grill"] = 600,
    ["hood"] = 2000,
    ["horn"] = 1000,
    ["fender"] = 850,
    ["mirror"] = 100,
    ["xenon"] = 750,
    ["xenonColor"] = 350,
    ["neon_support"] = {
        [0] = 1000,
        [1] = 2000,
        [2] = 3000,
        [3] = 4000,
        [4] = 5000,
        [5] = 6000,
        [6] = 7000,
        [7] = 8000,
    },
    ["neonColor"] = 100,
    ["pattern"] = 500,
    ["plate"] = {
        [1] = 25,
        [2] = 50,
        [3] = 75,
        [4] = 100,
        [5] = 125,
    },
    ["primaryColor"] = {
        [1] = 750, -- classic
        [2] = 750, -- mat
        [3] = 750, -- metallic
        [4] = 750, -- metals
        [5] = 750, -- pearl
    },
    ["secondaryColor"] = {
        [1] = 750, -- classic
        [2] = 750, -- mat
        [3] = 750, -- metallic
        [4] = 750, -- metals
    },
    ["finishingColor"] = 750,
    ["roof"] = 250,
    ["sideSkirt"] = 1350,
    ["spoiler"] = 1625,
    ["wheels"] = {
        [1] = 1550, -- high
        [2] = 1550, -- lowrider
        [3] = 1550, -- muscle
        [4] = 1550, -- offroad
        [5] = 1550, -- sport
        [6] = 1550, -- suv
        [7] = 1550, -- tunning
        [8] = 1550, -- street
        [9] = 1550, -- track
    },
    ["wheels_color"] = 750,
    ["wheels_fume"] = 500,
    ["window"] = {
        [0] = 1500,
        [1] = 2000,
        [2] = 2500,
        [3] = 3000
    },
    ["brake"] = {
        [0] = 30000,
        [1] = 35000,
        [2] = 40000,
        [3] = 50000,
    },
    ["engine"] = {
        [0] = 35000,
        [1] = 45000,
        [2] = 60000,
        [3] = 75000,
    },
    ["suspension"] = {
        [0] = 10000,
        [1] = 15000,
        [2] = 20000,
        [3] = 25000,
    },
    ["transmission"] = {
        [0] = 10000,
        [1] = 20000,
        [2] = 30000,
        [3] = 40000,
    },
    ["turbo"] = {
        [0] = 65000,
        [1] = 80000,
    },
}