ScriptShared.Items:Add("cash", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Espèces",
    weight = 0.0,
    category = "Devises"
})

ScriptShared.Items:Add("dirtycash", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Argent Sale",
    weight = 0.0,
    category = "Devises"
})

ScriptShared.Items:Add("idcard", {
    stackable = false,
    deletable = false,
    tradable = false,
    label = "Carte d'identité",
    weight = 0.01,
    usable = true,
    category = "Identité",
    event = {
        client_event = "izeyy:idcard:use",
    }
})

ScriptShared.Items:Add("drive", {
    stackable = false,
    deletable = false,
    tradable = false,
    label = "Permis voiture",
    weight = 0.01,
    usable = true,
    category = "Identité",
    event = {
        client_event = "izeyy:drive:use",
    }
})

ScriptShared.Items:Add("weapon", {
    stackable = false,
    deletable = false,
    tradable = false,
    label = "Permis port d'armes",
    weight = 0.01,
    usable = true,
    category = "Identité",
    event = {
        client_event = "izeyy:weapon:use",
    }
})

ScriptShared.Items:Add("fishingrod", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Canne a Peche",
    weight = 1.5,
    usable = false,
    category = "Outils",
})

ScriptShared.Items:Add("fish_bait", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Appât a poisson",
    weight = 0.2,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("fish", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Poisson",
    weight = 1.0,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("jewels", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Bijoux",
    weight = 0.5,
    usable = false,
    category = "Bijoux",
})

ScriptShared.Items:Add("id_card_f", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Carte de sécurité",
    weight = 0.01,
    usable = false,
    category = "Carte",
})

ScriptShared.Items:Add("oxygen_mask", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Masque à oxygène",
    weight = 1.5,
    usable = false,
    category = "Utilitaire",
})

ScriptShared.Items:Add("radio", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Radio",
    weight = 0.5,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("phone", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Téléphone",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("tabac", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Tabac",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("tomates", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Tomates",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("bandage", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Bandage",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("medikit", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Medikit",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("defibrillateur", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Defibrillateur",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("weed_og_leaf", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Feuille de weed",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("weed_bag_og", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Pochon de weed",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("meth", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Meth",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("meth_pooch", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Pochon de meth",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("coke", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Coke",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("coke_pooch", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Pochon de coke",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("fentanyl", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Fentanyl",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("fentanyl_pooch", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Fentanyl Traité",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("bmx", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "BMX",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("cb", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Carte bancaire",
    weight = 0.6,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("chiffon_clean", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Kit de nettoyage",
    weight = 0.3,
    usable = false,
    category = "Outillage",
})

ScriptShared.Items:Add("repairkit", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Kit de réparation",
    weight = 0.3,
    usable = false,
    category = "Outillage",
})

ScriptShared.Items:Add("kitcrochetage", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Kit de déverrouillage",
    weight = 0.3,
    usable = false,
    category = "Outillage",
})

ScriptShared.Items:Add("hat", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Chapeau",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("shoes", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Chaussures",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("earrings", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Accessoires d'oreille",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("glasses", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Lunettes",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("bracelets", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Bracelet",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("bags", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Sac",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("pants", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Pantalon",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("chains", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Chaine",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("masks", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Masque",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:use",
    }
})

ScriptShared.Items:Add("tops", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Haut",
    weight = 0.1,
    usable = true,
    category = "Vêtement",
    event = {
        client_event = "engine:clothes:top",
    }
})

ScriptShared.Items:Add("burger", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Burger",
    weight = 0.25,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "prop_cs_burger_01", type = "hunger", nutrition = 50}
    }
})

ScriptShared.Items:Add("frites", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Frites",
    weight = 0.15,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "prop_food_chips", type = "hunger", nutrition = 30}
    }
})

ScriptShared.Items:Add("fanta", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Fanta",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 40}
    }
})

ScriptShared.Items:Add("vodka", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vodka",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 40}
    }
})

ScriptShared.Items:Add("vodkaenergy", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vodka Energy",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 40}
    }
})

ScriptShared.Items:Add("vodkafruit", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vodka Jus de fruits",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 40}
    }
})

ScriptShared.Items:Add("vodkaredbull", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vodka Redbull",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 40}
    }
})

ScriptShared.Items:Add("jager", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Jägermeister",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "h4_prop_battle_whiskey_bottle_s", type = "thirst", nutrition = 20}
    }
})

ScriptShared.Items:Add("martini", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Martini",
    weight = 0.5,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "prop_tequila", type = "thirst", nutrition = 20}
    }
})

ScriptShared.Items:Add("redbull", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Redbull",
    weight = 0.05,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 40}
    }
})

ScriptShared.Items:Add("bread", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Pain",
    weight = 0.4,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "prop_food_burg2", type = "hunger", nutrition = 30}
    }
})

ScriptShared.Items:Add("water", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Eau",
    weight = 0.05,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 20}
    }
})

ScriptShared.Items:Add("icetea", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "IceTea",
    weight = 0.05,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {type = "thirst", nutrition = 50, isVip = true}
    }
})

ScriptShared.Items:Add("chocolat", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Chocolat",
    weight = 0.1,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "prop_choc_meto", type = "hunger", nutrition = 25}
    }
})

ScriptShared.Items:Add("donuts", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Donut",
    weight = 0.1,
    usable = false,
    category = "Consommable",
    event = {
        server_event = "engine:item:use",
        param_event = {prop = "prop_donut_01", type = "hunger", nutrition = 100, isVip = true}
    }
})

ScriptShared.Items:Add("vase_deluxe", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vase deluxe",
    weight = 1.2,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("tableau_picasso", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Tableau Picasso",
    weight = 0.7,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("tablette", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Tablette",
    weight = 0.12,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("vetements_deluxe", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vêtements deluxe",
    weight = 0.25,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("bijoux_or", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Bijoux en or",
    weight = 0.25,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("ordinateur_portable", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Ordinateur Portable",
    weight = 0.35,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("ordinateur_fixe", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Ordinateur fixe",
    weight = 2.0,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("console_salon", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Console de salon",
    weight = 0.8,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("cookeo", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Cookeo",
    weight = 1.0,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("jouet_sexuel_de_para", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Jouet sexuel de Para",
    weight = 0.01,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("vin_de_qualite", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vin de qualité",
    weight = 0.4,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("mixeur", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Mixeur",
    weight = 0.75,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("enceinte", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Enceinte",
    weight = 0.4,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("chicha", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Chicha",
    weight = 0.3,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("vetement_de_qualite", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vêtement de qualité",
    weight = 0.25,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("chaussure_de_qualite", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Chaussure de qualité",
    weight = 0.30,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("seche_cheveux", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Sèche Cheveux",
    weight = 0.09,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("shampooing_de_qualite", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Shampooing de qualité",
    weight = 0.5,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("cafetiere", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Cafetière",
    weight = 0.3,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("micro_onde", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Micro-onde",
    weight = 0.5,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("preservatif_de_para", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Préservatif de Para",
    weight = 0.1,
    usable = false,
    category = "Objet de braquage",
})  

ScriptShared.Items:Add("bierre_rouge", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Bierre rouge",
    weight = 0.2,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("telephone_casse", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Téléphone cassé",
    weight = 0.25,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("crocs", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Crocs",
    weight = 0.2,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("paquet_de_cigarettes", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Paquet de cigarettes",
    weight = 0.01,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("vhs_18", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Cassette VHS +18",
    weight = 0.015,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("bijoux_en_plastique", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Bijoux en plastique",
    weight = 0.015,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("tapis", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Tapis",
    weight = 0.3,
    usable = false,
    category = "Objet de braquage",
})  

ScriptShared.Items:Add("vase", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vase",
    weight = 0.75,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("cigarette_electronique", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Cigarette électronique",
    weight = 0.08,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("lampe_de_salon", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Lampe de salon",
    weight = 0.70,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("brosse_a_dent_electrique", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Brosse a dent électrique",
    weight = 0.20,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("magazine_18", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Magazine +18",
    weight = 0.01,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("livre_de_recette", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Livre de recette",
    weight = 0.015,
    usable = false,
    category = "Objet de braquage",
})  

ScriptShared.Items:Add("shampooing", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Shampooing",
    weight = 0.05,
    usable = false,
    category = "Objet de braquage",
})

ScriptShared.Items:Add("kevlar", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Kevlar",
    weight = 2.0,
    usable = true,
    category = "Kevlar",
    event = {
        client_event = "Core:Kevlar:Check",
    }
})

ScriptShared.Items:Add("card_alert_hack", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Carte de sécurité #2",
    weight = 2.0,
    usable = true,
    category = "Illégal",
    event = {
        server_event = "core:sasp:hack",
    }
})

ScriptShared.Items:Add("fidelitycase", {
    stackable = true,
    deletable = false,
    tradable = false,
    label = "Caisses de Fidelité",
    weight = 0.0,
    usable = true,
    category = "HRP",
    event = {
        server_event = "iZeyy:Case:Fidelity",
    }
})

ScriptShared.Items:Add("raisin", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Raisin",
    weight = 0.2,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("vin", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Vin",
    weight = 1.0,
    usable = false,
    category = "Consommable",
})

ScriptShared.Items:Add("kq_outfitbag", {
    stackable = true,
    deletable = true,
    tradable = true,
    label = "Sac de Poches",
    weight = 1.0,
    usable = false,
    category = "Consommable",
    event = {
        client_event = "kq_outfitbag:placeBag",
    }
})

ScriptShared.Items:Add("hostel_card", {
    stackable = false,
    deletable = true,
    tradable = true,
    label = "Pass",
    weight = 0.1,
    usable = true,
    category = "Clé",
    event = {
        server_event = "fowlmas:hostel:scanKey",
    }
})

-- Caises Mysteres
ScriptShared.Items:Add("case_legendary", {
    stackable = true,
    deletable = false,
    tradable = false,
    label = "Caisse Légendaire",
    weight = 0.5,
    usable = false,
    category = "Caisse",
    event = {
        server_event = "izeyy:case:open",
        param_event = {index = 1}
    }
})

ScriptShared.Items:Add("case_ultimate", {
    stackable = true,
    deletable = false,
    tradable = false,
    label = "Caisse Ultime",
    weight = 0.5,
    usable = false,
    category = "Caisse",
    event = {
        server_event = "izeyy:case:open",
        param_event = {index = 2}
    }
})

ScriptShared.Items:Add("case_infinity", {
    stackable = true,
    deletable = false,
    tradable = false,
    label = "Caisse Infinity",
    weight = 0.5,
    usable = false,
    category = "Caisse",
    event = {
        server_event = "izeyy:case:open",
        param_event = {index = 3}
    }
})