Engine["Config"]["Heist"] = {}

Engine["Config"]["Heist"]["Ped"] = {
    model = "ig_lestercrest",
    position = vector3(705.908936, -964.089600, 29.401098),
    heading = 225.26681518555,
    dictionary = "missheist_jewellester_waitidles",
    animation = "lester_waitidle_base",
    bone = 28422,
    prop = "prop_cs_walking_stick"
}

Engine["Config"]["Heist"]["Blip"] = {
    label = "Braquage",
    sprite = 96,
    color = 2,
    coords = vector3(705.908936, -964.089600, 29.401098)
}

Engine["Config"]["Heist"]["HouseHeistHours"] = {
    start = 23,
    ending = 5
}

Engine["Config"]["Heist"]["ResellPed"] = {
    model = "g_m_y_lost_01",
    position = vector3(402.203033, 2585.547363, 42.519550),
    heading = 106.2215,
    dictionary = "anim@amb@nightclub@peds@",
    animation = "rcmme_amanda1_stand_loop_cop",
}

Engine["Config"]["Heist"]["SleepingPed"] = {
    ["high"] = {
        model = "a_m_m_hasjew_01",
        position = vector3(-163.613556, 483.469879, 133.560806),
        heading = 189.783,
    },
    ["high-mid"] = {
        model = "a_f_y_hiker_01",
        position = vector3(-36.414463, -576.681519, 83.635925),
        heading = 337.647,
    },
    ["medium"] = {
        model = "a_m_m_bevhills_01",
        position = vector3(349.750275, -996.121704, -99.539810),
        heading = 358.671,
    },
    ["low"] = {
        model = "a_f_y_rurmeth_01",
        position = vector3(262.650665, -1004.262451, -99.262711),
        heading = 178.021,
    }
}

Engine["Config"]["Heist"]["Houses"] = {
    ["high"] = {
        [1] = {position = vector3(-175.019135, 502.548981, 137.420624), image = "https://i.ibb.co/smsSnM3/image.png"},
        [2] = {position = vector3(-912.280518, 777.489990, 187.010666), image = "https://i.ibb.co/nwmT1kM/image.png"},
        [3] = {position = vector3(228.812912, 765.771851, 204.976334), image = "https://i.ibb.co/cN4kDFN/image.pngc"},
        [4] = {position = vector3(57.648632, 450.009216, 147.031677), image = "https://i.ibb.co/1QZTyBr/image.png"},
        [5] = {position = vector3(-409.374237, 341.530548, 108.907745), image = "https://i.ibb.co/xJL5jyF/image.png"}
    },
    ["high-mid"] = {
        [1] = {position = vector3(-36.435539, -570.594177, 38.833363), image = "https://i.ibb.co/0fZhfn8/image.png"},
        [2] = {position = vector3(-794.022034, 352.055145, 87.998199), image = "https://i.ibb.co/99ZdGQB/image.png"},
        [3] = {position = vector3(-586.374146, -748.851685, 29.487047), image = "https://i.ibb.co/5nMYCrb/image.png"},
        [4] = {position = vector3(-83.897285, 116.535889, 81.491577) , image = "https://i.ibb.co/6v1ndnG/image.png"},
        [5] = {position = vector3(-1371.128784, -460.489288, 34.477573), image = "https://i.ibb.co/DYsrnWG/image.png"}
    },
    ["medium"] = {
        [1] = {position = vector3(965.290161, -542.070129, 59.721558), image = "https://i.ibb.co/H4ZzwLS/image.png"},
        [2] = {position = vector3(1271.042969, -683.005432, 66.031776), image = "https://i.ibb.co/TwHSFy0/image.png"},
        [3] = {position = vector3(1251.227905, -515.385559, 69.349174), image = "https://i.ibb.co/JtvVHD1/image.png"},
        [4] = {position = vector3(1051.923096, -470.621918, 63.898960), image = "https://i.ibb.co/LYt3k06/image.png"},
        [5] = {position = vector3(1060.810425, -378.369873, 68.231087), image = "https://i.ibb.co/4NmL8Vp/image.png"}
    },
    ["low"] = {
        [1] = {position = vector3(1683.157959, 4689.537109, 43.065762), image = "https://i.ibb.co/RbWYkZc/image.png"},
        [2] = {position = vector3(-407.223877, 6314.116699, 28.941446), image = "https://i.ibb.co/ZX4bzvQ/image.png"},
        [3] = {position = vector3(-366.700958, 6213.883789, 31.842285), image = "https://i.ibb.co/q1HpN0p/image.png"},
        [4] = {position = vector3(35.257664, 6662.919922, 32.190464), image = "https://i.ibb.co/wd5TFqV/image.png"},
        [5] = {position = vector3(741.517822, 4170.443359, 41.087933), image = "https://i.ibb.co/xmrtgkH/image.png"}
    },
}

Engine["Config"]["Heist"]["HousesInterior"] = {
    ["high"] = vector3(-174.387695, 497.553864, 137.666870),
    ["high-mid"] = vector3(-18.581125, -591.518372, 90.114853),
    ["medium"] = vector3(348.099304, -999.068665, -99.196304),
    ["low"] = vector3(266.093048, -1007.305237, -101.008499)
}

Engine["Config"]["Heist"]["GlobalHouseTimer"] = {
    ["high"] = 13,
    ["high-mid"] = 13,
    ["medium"] = 15,
    ["low"] = 20
}

Engine["Config"]["Heist"]["HouseReward"] = {
    ["high"] = {
        [1] = {label = "Vase deluxe", item = "vase_deluxe", price = 8910, position = vector3(-164.263260, 487.083954, 137.443405)},
        [2] = {label = "Tableau Picasso", item = "tableau_picasso", price = 6804, position = vector3(-176.011276, 491.940552, 133.843826)},
        [3] = {label = "Tablette", item = "tablette", price = 1134, position = vector3(-163.277603, 485.119598, 133.869492)},
        [4] = {label = "Vêtements deluxe", item = "vetements_deluxe", price = 648, position = vector3(-167.443420, 488.020325, 133.843842)},
        [5] = {label = "Bijoux en or", item = "bijoux_or", price = 4050, position = vector3(-170.433853, 482.002533, 133.843887)},
        [6] = {label = "Ordinateur Portable", item = "ordinateur_portable", price = 2673, position = vector3(-170.052383, 490.859497, 130.043640)},
        [7] = {label = "Ordinateur fixe", item = "ordinateur_fixe", price = 4050, position = vector3(-169.981445, 493.365845, 130.043640)},
        [8] = {label = "Console de salon", item = "console_salon", price = 972, position = vector3(-162.804535, 481.826355, 137.244415)},
        [9] = {label = "Cookeo", item = "cookeo", price = 1458, position = vector3(-167.108185, 496.495758, 137.653427)},
        [10] = {label = "Jouet sexuel de Para", item = "jouet_sexuel_de_para", price = 486, position = vector3(-162.748108, 481.656799, 133.869522)}
    },
    ["high-mid"] = {
        [1] = {label = "Console de salon", item = "console_salon", price = 1749, position = vector3(-40.644997, -571.944336, 88.712288)},
        [2] = {label = "Vin de qualité", item = "vin_de_qualite", price = 1166, position = vector3(-36.402054, -583.194397, 88.712296)},
        [3] = {label = "Mixeur", item = "mixeur", price = 729, position = vector3(-30.928846, -587.764954, 88.712296)},
        [4] = {label = "Enceinte", item = "enceinte", price = 524, position = vector3(-44.653984, -586.695557, 88.712296)},
        [5] = {label = "Chicha", item = "chicha", price = 466, position = vector3(-33.948078, -576.072876, 88.712135)},
        [6] = {label = "Tablette", item = "tablette", price = 2041, position = vector3(-36.873657, -578.293030, 83.907570)},
        [7] = {label = "Vêtement de qualité", item = "vetement_de_qualite", price = 524, position = vector3(-38.321808, -584.524841, 83.907608)},
        [8] = {label = "Chaussure de qualité", item = "chaussure_de_qualite", price = 1458, position = vector3(-36.337803, -583.006775, 83.907570)},
        [9] = {label = "Sèche cheveux", item = "seche_cheveux", price = 349, position = vector3(-29.946831, -585.159363, 83.907570)},
        [10] = {label = "Shampooing de qualité", item = "shampooing_de_qualite", price = 297, position = vector3(-31.669205, -587.564514, 83.954788)}
    },
    ["medium"] = {
        [1] = {label = "Cafetière", item = "cafetiere", price = 640, position = vector3(342.966553, -1003.205566, -99.196144)},
        [2] = {label = "Micro-onde", item = "micro_onde", price = 640, position = vector3(344.065125, -1002.085999, -99.196144)},
        [3] = {label = "Console de salon", item = "console_salon", price = 1749, position = vector3(338.220612, -996.649902, -99.196144)},
        [4] = {label = "Préservatif de Para", item = "preservatif_de_para", price = 205, position = vector3(349.182617, -994.860352, -99.196098)},
        [5] = {label = "Sèche Cheveux", item = "seche_cheveux", price = 232, position = vector3(351.326385, -999.272583, -99.196136)},
        [6] = {label = "Brosse a dent électrique", item = "brosse_a_dent_electrique", price = 204, position = vector3(347.233246, -994.454895, -99.196129)},
        [7] = {label = "Magazine +18", item = "magazine_18", price = 290, position = vector3(346.260223, -1001.838257, -99.196175)},
        [8] = {label = "Vase", item = "vase", price = 263, position = vector3(345.300720, -993.700562, -99.196175)},
        [9] = {label = "Cigarette électronique", item = "cigarette_electronique", price = 291, position = vector3(340.464539, -996.112549, -99.196175)},
        [10] = {label = "Lampe de salon", item = "lampe_de_salon", price = 355, position = vector3(338.433380, -993.607239, -99.196144)}
    },
    ["low"] = {
        [1] = {label = "Bierre rouge", item = "bierre_rouge", price = 238, position = vector3(265.716522, -996.524597, -99.008545)},
        [2] = {label = "Téléphone cassé", item = "telephone_casse", price = 524, position = vector3(262.706329, -999.913025, -99.008530)},
        [3] = {label = "Crocs", item = "crocs", price = 252, position = vector3(260.858124, -1004.190002, -99.008636)},
        [4] = {label = "Paquet de cigarettes", item = "paquet_de_cigarettes", price = 268, position = vector3(264.113800, -995.478271, -99.008636)},
        [5] = {label = "Cassette VHS +18", item = "vhs_18", price = 225, position = vector3(256.936310, -995.858887, -99.008636)},
        [6] = {label = "Bijoux en plastique", item = "bijoux_en_plastique", price = 254, position = vector3(265.889862, -999.448792, -99.008537)},
        [7] = {label = "Sèche Cheveux", item = "seche_cheveux", price = 232, position = vector3(255.526505, -1000.560974, -99.009834)},
        [8] = {label = "Shampooing", item = "shampooing", price = 221, position = vector3(254.477341, -1001.169495, -98.927483)},
        [9] = {label = "Livre de recette", item = "livre_de_recette", price = 261, position = vector3(261.980469, -995.447144, -99.008537)},
        [10] = {label = "Tapis", item = "tapis", price = 297, position = vector3(259.543701, -998.595215, -99.008530)}
    }
}