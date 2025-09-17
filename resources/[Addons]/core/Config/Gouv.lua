Config["Gouv"] = {}

Config["Gouv"]["ServicePos"] = vector3(349.767609, -1658.129517, 38.500275)
Config["Gouv"]["Armory"] =  vector3(345.406372, -1654.485229, 38.500275)
Config["Gouv"]["Garage"] = vector3(342.848114, -1639.851929, 23.785049)
Config["Gouv"]["SpawnCarPos"] = vector3(344.085632, -1630.688721, 23.785049)
Config["Gouv"]["SpawnCarHeading"] = 229.59634399414
Config["Gouv"]["CarDeletePos"] = vector3(344.085632, -1630.688721, 23.785049)
Config["Gouv"]["BlipsPos"] = vector3(336.415894, -1639.562500, 98.495316)
Config["Gouv"]["OfficePos"] = vector3(352.853394, -1633.252319, 38.500275)

Config["Gouv"]["VehList"] = {
    { label = "Declasse Polala", model = "trualamo3" },
    { label = "Bravado Buffalo STX", model = "bufsxtrafpol" },
    { label = "Jackal", model = "jackal" },
    { label = "Exemplar", model = "exemplar" },
    { label = "XLS Blindé", model = "xls2" },
}

Config["Gouv"]["Uniform"] = {
    male = {
        ['tshirt_1'] = 31, ['tshirt_2'] = 0,
        ['torso_1'] = 31, ['torso_2'] = 0,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 24, ['pants_2'] = 2,
        ['shoes_1'] = 7, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['mask_1'] = -1, ['mask_2'] = 0,
        ['bproof_1'] = 0,  ['bproof_2'] = 0,
        ['bags_1'] = 0, ['bags_2'] = 0,
        ['chain_1'] = 115, ['chain_2'] = 0,
        ['ears_1'] = -1, ['ears_2'] = 0,
    },
    female = {
        ['tshirt_1'] = 216, ['tshirt_2'] = 0,
        ['torso_1'] = 57, ['torso_2'] = 0,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 3,
        ['pants_1'] = 6, ['pants_2'] = 0,
        ['shoes_1'] = 6, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['mask_1'] = 0, ['mask_2'] = 0,
        ['bproof_1'] = 0,  ['bproof_2'] = 0,
        ['bags_1'] = 0, ['bags_2'] = 0,
        ['chain_1'] = 86, ['chain_2'] = 0,
        ['ears_1'] = -1, ['ears_2'] = 0,
    }
}

Config["Gouv"]["ArmoryWeapon"] = {
	{label = "Pistolet de combat", weapon = "weapon_combatpistol", grade = 2},
	{label = "Carabine d'assault", weapon = "weapon_carbinerifle", grade = 2},
	{label = "Fusil a Pompe", weapon = "weapon_pumpshotgun", grade = 3},
}