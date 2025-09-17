Engine["Config"]["ClothesShop"] = {}

Engine["Config"]["ClothesShop"]["Shop"] = {
    [165633] = {
        ["menuStyle"] = "ponsonbys",
        ["BlipName"] = "Magasin de vêtements | Ponsonbys",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-708.816, -151.411, 36.415),
            heading = 118.32,
        }
    },
    [235265] = {
        ["menuStyle"] = "ponsonbys",
        ["BlipName"] = "Magasin de vêtements | Ponsonbys",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-165.291, -303.360, 38.733),
            heading = 252.662,
        }
    },
    [166145] = {
        ["menuStyle"] = "ponsonbys",
        ["BlipName"] = "Magasin de vêtements | Ponsonbys",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-1448.682, -238.054, 48.814),
            heading = 46.535,
        }
    },
    [137217] = {
        ["menuStyle"] = "binco",
        ["BlipName"] = "Magasin de vêtements | Binco",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(427.144, -806.098, 28.491),
            heading = 88.258,
        }
    },
    [171265] = {
        ["menuStyle"] = "binco",
        ["BlipName"] = "Magasin de vêtements | Binco",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-823.577, -1072.493, 10.328),
            heading = 210.279,
        }
    },
    [179713] = {
        ["menuStyle"] = "discount",
        ["BlipName"] = "Magasin de vêtements | Discount",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(6.106, 6511.437, 30.877),
            heading = 40.099,
        }
    },
    [183553] = {
        ["menuStyle"] = "discount",
        ["BlipName"] = "Magasin de vêtements | Discount",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(1695.396, 4823.286, 41.063),
            heading = 95.457,
        }
    },
    [202497] = {
        ["menuStyle"] = "discount",
        ["BlipName"] = "Magasin de vêtements | Discount",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(1196.392, 2711.840, 37.222),
            heading = 179.197,
        }
    },
    [175361] = {
        ["menuStyle"] = "discount",
        ["BlipName"] = "Magasin de vêtements | Discount",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-1102.882, 2711.301, 18.107),
            heading = 219.821,
        }
    },
    [198145] = {
        ["menuStyle"] = "discount",
        ["BlipName"] = "Magasin de vêtements | Discount",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(73.650, -1392.999, 28.376),
            heading = 271.081,
        }
    },
    [169217] = {
        ["menuStyle"] = "suburban",
        ["BlipName"] = "Magasin de vêtements | Suburban",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-1194.752, -767.301, 16.315),
            heading = 216.090,
        }
    }, 
    [176129] = {
        ["menuStyle"] = "suburban",
        ["BlipName"] = "Magasin de vêtements | Suburban",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(-3168.889, 1043.849, 19.863),
            heading = 65.677,
        }
    },
    [201473] = {
        ["menuStyle"] = "suburban",
        ["BlipName"] = "Magasin de vêtements | Suburban",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(612.682617, 2761.633301, 41.088074),
            heading = 274.946,
        }
    },
    [140801] = {
        ["menuStyle"] = "suburban",
        ["BlipName"] = "Magasin de vêtements | Suburban",
        ["ped"] = {
            model = "a_f_y_hipster_02",
            position = vector3(127.419, -223.596, 53.557),
            heading = 68.545,
        }
    },
}

Engine["Config"]["ClothesShop"]["MaxOutfits"] = 5
Engine["Config"]["ClothesShop"]["MaxOutfitsVip"] = 40

Engine["Config"]["ClothesShop"]["Prices"] = {
    ["hats"] = 25,
    ["earrings"] = 25,
    ["glasses"] = 25,
    ["tops"] = 90,
    ["tshirts"] = 30,
    ["arms"] = 30,
    ["decals"] = 30,
    ["accessories"] = 30,
    ["bags"] = 30,
    ["watches"] = 50,
    ["bracelets"] = 25,
    ["pants"] = 35,
    ["shoes"] = 50,
    ["masks"] = 30,
    ["underwear"] = 20,
    ["saveOutfit"] = 100,
    ["takeOutfit"] = 5
}

Engine["Config"]["ClothesShop"]["Items"] = {
    ["helmet_1"] = "hat",
    ["shoes_1"] = "shoes",
    ["watches_1"] = "watches",
    ["ears_1"] = "earrings",
    ["glasses_1"] = "glasses",
    ["bracelets_1"] = "bracelets",
    ["bags_1"] = "bags",
    ["pants_1"] = "pants",
    ["chain_1"] = "chains",
    ["torso_1"] = "tops",
    ["mask_1"] = "masks"
}

Engine["Config"]["ClothesShop"]["Animation"] = {
    ["masks"] = {
        id = 1,
        dict = "mp_masks@standard_car@ds@",
        anim = "put_on_mask",
        flag = 51,
        time = 800
    },
    ["pants"] = {
        id = 4,
        dict = "re@construction",
        anim = "out_of_breath",
        flag = 51,
        time = 1300
    },
    ["bags"] = {
        id = 5,
        dict = "anim@heists@ornate_bank@grab_cash",
        anim = "intro",
        flag = 51,
        time = 1600
    },
    ["shoes"] = {
        id = 6,
        dict = "random@domestic",
        anim = "pickup_low",
        flag = 0,
        time = 1200
    },
    ["chains"] = {
        id = 7,
        dict = "clothingtie",
        anim = "try_tie_positive_a",
        flag = 51,
        time = 2100
    },
    ["bullet-proof"] = {
        id = 9,
        dict = "clothingtie",
        anim = "try_tie_negative_a",
        flag = 51,
        time = 1200
    },
    ["decals"] = {
        id = 10,
        dict = "clothingtie",
        anim = "try_tie_negative_a",
        flag = 51,
        time = 1200
    },
    ["tops"] = {
        id = 11,
        dict = "clothingtie",
        anim = "try_tie_negative_a",
        flag = 51,
        time = 1200
    },
    ["hats"] = {
        id = 0,
        prop = true,
        dict = "mp_masks@standard_car@ds@",
        anim = "put_on_mask",
        flag = 51,
        time = 600
    },
    ["glasses"] = {
        id = 1,
        prop = true,
        dict = "clothingspecs",
        anim = "take_off",
        flag = 51,
        time = 1400
    },
    ["earrings"] = {
        id = 2,
        prop = true,
        dict = "mp_cp_stolen_tut",
        anim = "b_think",
        flag = 51,
        time = 900
    },
    ["watches"] = {
        id = 6,
        prop = true,
        dict = "nmt_3_rcm-10",
        anim = "cs_nigel_dual-10",
        flag = 51,
        time = 1200
    },
    ["bracelets"] = {
        id = 7,
        prop = true,
        dict = "nmt_3_rcm-10",
        anim = "cs_nigel_dual-10",
        flag = 51,
        time = 1200
    }
}

Engine["Config"]["ClothesShop"]["MenuStyle"] = {
    ["binco"] = "interaction_binco",
    ["discount"] = "interaction_discount",
    ["ponsonbys"] = "interaction_ponsonbys",
    ["suburban"] = "interaction_suburban"
}

Engine["Config"]["ClothesShop"]["Underwear"] = {
    ["male"] = {
        [1] = {label = "Caleçon par défaut", texture = 18, variant = 6},
        [2] = {label = "Caleçon avec cœur rouge", texture = 21, variant = 0},
        [3] = {label = "Caleçon blanc", texture = 61, variant = 0},
        [4] = {label = "Caleçon noir", texture = 61, variant = 1},
        [5] = {label = "Caleçon gris", texture = 61, variant = 2},
        [6] = {label = "Caleçon léopard", texture = 61, variant = 3},
        [7] = {label = "Caleçon blanc avec cœur rose", texture = 61, variant = 4},
        [8] = {label = "Caleçon noir avec cœur rose", texture = 61, variant = 5},
        [9] = {label = "Caleçon rouge avec cœur noir", texture = 61, variant = 6},
        [10] = {label = "Caleçon à trait violet", texture = 61, variant = 7},
        [11] = {label = "Caleçon à trait gris", texture = 61, variant = 8},
        [12] = {label = "Caleçon à trait rouge", texture = 61, variant = 10},
        [13] = {label = "Caleçon à point blanc", texture = 61, variant = 11}
    },
    ["female"] = {
        [1] = {label = "Tanga par défaut", texture = 56, variant = 5},
        [2] = {label = "Tanga avec monogramme Sessanta Nove", texture = 56, variant = 2},
        [3] = {label = "Tanga rose", texture = 56, variant = 0},
        [4] = {label = "Tanga Le Chien", texture = 56, variant = 1},
        [5] = {label = "Tanga Blanc", texture = 17, variant = 0},
        [6] = {label = "Tanga bleu", texture = 17, variant = 2},
        [7] = {label = "Tanga léopard", texture = 17, variant = 3},
        [8] = {label = "Tanga rouge", texture = 17, variant = 4},
        [9] = {label = "Shorty Blanc", texture = 62, variant = 1},
        [10] = {label = "Shorty noir", texture = 62, variant = 2},
        [11] = {label = "Shorty à point blanc", texture = 62, variant = 3},
        [12] = {label = "Shorty dentelle rouge foncé", texture = 62, variant = 4},
        [13] = {label = "Shorty dentelle noire", texture = 62, variant = 6},
        [14] = {label = "Shorty dentelle rouge clair", texture = 62, variant = 7},
        [15] = {label = "Shorty dentelle rose", texture = 62, variant = 8}
    }
}

Engine["Config"]["ClothesShop"]["Undress"] = {
    ["male"] = {
        ["pants_1"] = 18, ["pants_2"] = 6, 
        ["tshirt_1"] = 15, ["tshirt_2"] = 0, 
        ["bproof_1"] = 0, ["bproof_2"] = 0, 
        ["torso_1"] = 15, ["torso_2"] = 0, 
        ["arms"] = 15, ["arms_2"] = 0, 
        ["decals_1"] = 0, ["decals_2"] = 0,
        ["mask_1"] = 0, ["mask_2"] = 0,
        ["helmet_1"] = 8, ["helmet_2"] = 0,
        ["shoes_1"] = 34, ["shoes_2"] = 0, 
        ["chain_1"] = 0, ["chain_2"] = 0,
        ["ears_1"] = -1, ["ears_2"] = -1,
        ["watches_1"] = 2, ["watches_2"] = 0,
        ["glasses_1"] = 0, ["glasses_2"] = 0,
        ["bracelets_1"] = 11, ["bracelets_2"] = 0,
        ["bags_1"] = 0, ["bags_2"] = 0
    },
    ["female"] = {
        ["pants_1"] = 56, ["pants_2"] = 5,
        ["tshirt_1"] = 15, ["tshirt_2"] = 0, 
        ["bproof_1"] = 0, ["bproof_2"] = 0, 
        ["torso_1"] = 14, ["torso_2"] = 0, 
        ["arms"] = 15, ["arms_2"] = 0, 
        ["decals_1"] = 0, ["decals_2"] = 0,
        ["mask_1"] = 0, ["mask_2"] = 0,
        ["helmet_1"] = 57, ["helmet_2"] = 0,
        ["shoes_1"] = 35, ["shoes_2"] = 0, 
        ["chain_1"] = 0, ["chain_2"] = 0,
        ["ears_1"] = -1, ["ears_2"] = -1,
        ["watches_1"] = 2, ["watches_2"] = 0,
        ["glasses_1"] = 5, ["glasses_2"] = 0,
        ["bracelets_1"] = 21, ["bracelets_2"] = 0,
        ["bags_1"] = 0, ["bags_2"] = 0
    }
}

Engine["Config"]["ClothesShop"]["MenuColors"] = {
    ["binco"] = {
        R = 248,
        G = 176,
        B = 4,
        A = 255
    },
    ["discount"] = {
        R = 52,
        G = 123,
        B = 200,
        A = 255
    },
    ["ponsonbys"] = {
        R = 165,
        G = 133,
        B = 84,
        A = 255
    },
    ["suburban"] = {
        R = 214,
        G = 39,
        B = 45,
        A = 255
    }
}

Engine["Config"]["ClothesShop"]["DisableKey"] = {
	{group = 0, key = 25}, -- Clique droit
    {group = 0, key = 24}, -- Clique gauche
    {group = 0, key = 69}, -- Clique gauche
    {group = 0, key = 92}, -- Clique gauche
    {group = 0, key = 106}, -- Clique gauche
	{group = 0, key = 168}, -- F7
	{group = 0, key = 45}, -- R
	{group = 0, key = 140}, -- R
	{group = 0, key = 263}, -- R
    {group = 0, key = 157}, -- Racourcis clavier n*1
    {group = 0, key = 158}, -- Racourcis clavier n*2
    {group = 0, key = 160}, -- Racourcis clavier n*3
    {group = 0, key = 164}, -- Racourcis clavier n*4
    {group = 0, key = 165} -- Racourcis clavier n*5
}
