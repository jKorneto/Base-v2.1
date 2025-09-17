Config["Bar"] = {}

Config["Bar"]["List"] = {
    ["unicorn"] = {
        jobLabel = "Unicorn",
        jobName = "unicorn",
        zoneMusicId = "UnicornMusicZone",
        announcements = {
            ["open"] = "Le Unicorn est desormais ouvert et nous vous attendons avec impatience",
            ["close"] = "Le Unicorn est désormais fermé, repasser plus tard",
            ["recruitment"] = "Le Unicorn commence une session de recrutement, venez afin de postuler",
        },
        items = {
            -- ["vodka"] = {label = "Vodka", price = 2},
            -- ["vodkaenergy"] = {label = "Vodka-Energy", price = 4},
            -- ["vodkafruit"] = {label = "Vodka-Jus de fruits", price = 3},
            -- ["vodkaredbull"] = {label = "Vodka-Redbull", price = 4},
            -- ["jager"] = {label = "Jägermeister", price = 2},
            -- ["martini"] = {label = "Martini Blanc", price = 2},
            -- ["redbull"] = {label = "Redbull", price = 1},
        },
        barPos = vector3(129.67, -1283.82, 29.27),
        djTablePos = vector3(121.36, -1281.52, 29.48),
        vestiairePos = vector3(107.326500, -1304.987671, 28.768785)
        -- for edit action patron pos & logs go to (core_nui/src/enums/[Gameplay]/Society/eSociety.lua)
    },
    ["galaxy"] = {
        jobLabel = "Galaxy",
        jobName = "galaxy",
        zoneMusicId = "GalaxyMusicZone",
        announcements = {
            ["open"] = "Le Galaxy est desormais ouvert et nous vous attendons avec impatience",
            ["close"] = "Le Galaxy est désormais fermé, repasser plus tard",
            ["recruitment"] = "Le Galaxy commence une session de recrutement, venez afin de postuler",
        },
        items = {
            -- ["vodka"] = {label = "Vodka", price = 2},
            -- ["vodkaenergy"] = {label = "Vodka-Energy", price = 4},
            -- ["vodkafruit"] = {label = "Vodka-Jus de fruits", price = 3},
            -- ["vodkaredbull"] = {label = "Vodka-Redbull", price = 4},
            -- ["jager"] = {label = "Jägermeister", price = 2},
            -- ["martini"] = {label = "Martini Blanc", price = 2},
            -- ["redbull"] = {label = "Redbull", price = 1},
        },
        barPos = vector3(357.57, 280.85, 94.19),
        djTablePos = vector3(375.481232, 275.719513, 92.399979),
        vestiairePos = vector3(107.326500, -1304.987671, 28.768785)
        -- for edit action patron pos & logs go to (core_nui/src/enums/[Gameplay]/Society/eSociety.lua)
    },
    ["night77"] = {
        jobLabel = "Night 77",
        jobName = "night77",
        zoneMusicId = "GalaxyMusicZone",
        announcements = {
            ["open"] = "Le Night 77 est desormais ouvert et nous vous attendons avec impatience",
            ["close"] = "Le Night 77 est désormais fermé, repasser plus tard",
            ["recruitment"] = "Le Night 77 commence une session de recrutement, venez afin de postuler",
        },
        items = {
            ["vodka"] = {label = "Vodka", price = 2},
            ["vodkaenergy"] = {label = "Vodka-Energy", price = 4},
            ["vodkafruit"] = {label = "Vodka-Jus de fruits", price = 3},
            ["vodkaredbull"] = {label = "Vodka-Redbull", price = 4},
            ["jager"] = {label = "Jägermeister", price = 2},
            ["martini"] = {label = "Martini Blanc", price = 2},
            ["redbull"] = {label = "Redbull", price = 1},
        },
        barPos = vector3(247.50, -3161.60, -0.18),
        djTablePos = vector3(247.244202, -3187.988037, 0.501505),
        vestiairePos = vector3(107.326500, -1304.987671, 28.768785)
        -- for edit action patron pos & logs go to (core_nui/src/enums/[Gameplay]/Society/eSociety.lua)
    },
}

Config["Bar"]["Clothes"] = {
    service = {
        male = {
            ['tshirt_1'] = 21, ['tshirt_2'] = 0,
            ['torso_1'] = 30, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 4,
            ['pants_1'] = 24, ['pants_2'] = 0,
            ['shoes_1'] = 7, ['shoes_2'] = 0,
            ['helmet_1'] = 8, ['helmet_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = -1, ['ears_2'] = 0,
        },
        female = {
            ['tshirt_1'] = 57, ['tshirt_2'] = 0,
			['torso_1'] = 31, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 0,
			['arms'] = 3,
			['pants_1'] = 53, ['pants_2'] = 0,
			['shoes_1'] = 21, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['mask_1'] = -1, ['mask_2'] = 0,
			['bproof_1'] = 143,  ['bproof_2'] = 0,
			['bags_1'] = 9, ['bags_2'] = 0,
			['chain_1'] = 8, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0,
        }
    },
    danse = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 21, ['pants_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['helmet_1'] = 8, ['helmet_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = -1, ['ears_2'] = 0,
        },
        female = {
            ['tshirt_1'] = 57, ['tshirt_2'] = 0,
			['torso_1'] = 31, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 0,
			['arms'] = 3,
			['pants_1'] = 53, ['pants_2'] = 0,
			['shoes_1'] = 21, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['mask_1'] = -1, ['mask_2'] = 0,
			['bproof_1'] = 143,  ['bproof_2'] = 0,
			['bags_1'] = 9, ['bags_2'] = 0,
			['chain_1'] = 8, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0,
        }
    }
}