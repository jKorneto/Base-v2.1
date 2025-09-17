Config["Bank"] = {}

Config["Bank"]["Limit1"] = 100000
Config["Bank"]["Limit2"] = 200000
Config["Bank"]["Limit3"] = 500000

Config["Bank"]["AccPos"] = vector3(243.043427, 224.519073, 106.286819)
Config["Bank"]["Pos"] = {
    { pos = vector3(150.266, -1040.203, 29.374), label = "FleecaBank"},
    { pos = vector3(-1212.980, -330.841, 37.787), label = "FleecaBank"},
    { pos = vector3(-2962.582, 482.627, 15.703), label = "FleecaBank"},
    { pos = vector3(-112.202, 6469.295, 31.626), label = "FleecaBank"},
    { pos = vector3(314.187, -278.621, 54.170), label = "FleecaBank"},
    { pos = vector3(-351.534, -49.529, 49.042), label = "FleecaBank"},
    { pos = vector3(1175.064, 2706.643, 38.094), label = "FleecaBank"},
}

Config["Bank"]["AccType"] = {
    { 
        label = "Plan Basic", 
        subprice = 5000, 
        description = "Compte de base offrant des fonctionnalités essentielles. Limite de dépôt et de retrait de 25 000$. Parfait pour une gestion simple et efficace de votre argent.", 
        level = 1 
    },
    { 
        label = "Plan Gold", 
        subprice = 10000, 
        description = "Compte intermédiaire avec des avantages supplémentaires. Limite de dépôt et de retrait de 50 000$. Idéal pour les personnes ayant un besoin de gestion financière plus flexible.", 
        level = 2 
    },
    { 
        label = "[~b~VIP~s~] Formule Premium", 
        subprice = 15000, 
        description = "Compte premium avec des avantages exclusifs. Limite de dépôt et de retrait de 100 000$. Conçu pour les utilisateurs recherchant des services bancaires haut de gamme et une grande capacité de gestion de fonds.", 
        level = 3 
    },
}
