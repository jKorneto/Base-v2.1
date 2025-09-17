Config["Rental"] = {}

Config["Rental"]["Times"] = {
    [1] = {label = "30 minutes", time = 30, price = 800},
    [2] = {label = "1 heure", time = 60, price = 1400},
    [3] = {label = "2 heures", time = 120, price = 2800},
}

Config["Rental"]["Vehicles"] = {
    ["car"] = {
        blipName = "Location de véhicule",
        blipSprite = 811,
        blipColor = 15,

        [1] = {
            position = vector3(-964.301270, -2694.037598, 12.980821),
            pedModel = "a_m_m_prolhost_01",
            pedHeading = 152.57284545898,
            model = {
                ["panto"] = "Panto",
                ["club"] = "Club",
                ["kanjo"] = "Kanjo"
            },
            spawn = vector3(-966.821045, -2710.389648, 13.831878),
            spawnHeading = 12.858535766602,
        },
        [2] = {
            position = vector3(4881.644531, -5188.369141, 1.438294),
            pedModel = "a_m_m_prolhost_01",
            pedHeading = 328.80902099609,
            model = {
                ["panto"] = "Panto",
                ["club"] = "Club",
                ["kanjo"] = "Kanjo"
            },
            spawn = vector3(4889.165039, -5187.203125, 2.438293),
            spawnHeading = 244.28460693359,
        },
    },
    ["boat"] = {
        blipName = "Location de bateau",
        blipSprite = 471,
        blipColor = 3,

        [1] = {
            position = vector3(-1561.938, -1156.642, 1.288),
            pedHeading = 126.784,
            pedModel = "a_m_m_beach_01",
            model = {
                ["seashark"] = "SeaShark",
                ["suntrap"] = "Suntrap",
                ["tropic2"] = "Tropic",
                ["toro2"] = "Toro (Black)",
                ["dinghy"] = "Dinghy"
            },
            spawn = vector3(-1626.799, -1169.599, 0.215),
            spawnHeading = 146.587
        },
        [2] = {
            position = vector3(-1612.685, 5262.281, 2.974),
            pedHeading = 208.159,
            pedModel = "a_m_m_beach_01",
            model = {
                ["seashark"] = "SeaShark",
                ["suntrap"] = "Suntrap",
                ["tropic2"] = "Tropic",
                ["toro2"] = "Toro (Black)",
                ["dinghy"] = "Dinghy"
            },
            spawn = vector3(-1593.799, 5249.261, -0.474),
            spawnHeading = 37.212
        },
        [3] = {
            position = vector3(2815.578, -663.359, 0.398),
            pedHeading = 273.208,
            pedModel = "a_m_m_beach_01",
            model = {
                ["seashark"] = "SeaShark",
                ["suntrap"] = "Suntrap",
                ["tropic2"] = "Tropic",
                ["toro2"] = "Toro (Black)",
                ["dinghy"] = "Dinghy"
            },
            spawn = vector3(2849.110, -665.049, -0.474),
            spawnHeading = 273.462
        },
        [4] = {
            position = vector3(4889.998047, -5164.442871, 1.482047),
            pedHeading = 164.68908691406,
            pedModel = "a_m_m_beach_01",
            model = {
                ["seashark"] = "SeaShark",
                ["suntrap"] = "Suntrap",
                ["tropic2"] = "Tropic",
                ["toro2"] = "Toro (Black)",
                ["dinghy"] = "Dinghy"
            },
            spawn = vector3(4884.646973, -5165.962891, 0.418470),
            spawnHeading = 346.28689575195
        },
    }
}