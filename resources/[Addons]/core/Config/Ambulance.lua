Config["AmbulanceJob"] = {}

Config["AmbulanceJob"]["RespawnTime"] = 360 -- secondes
Config["AmbulanceJob"]["BlipsPos"] = vector3(336.857208, -1392.989136, 32.509247)

Config["AmbulanceJob"]["DoctorPed"] = {
    { pos = vector3(344.297, -1406.576, 31.422), heading = 319.08 },
    { pos = vector3(1831.939941, 3673.058105, 33.159985), heading = 213.83457946777 },
    { pos = vector3(-248.150, 6331.917, 31.426), heading = 232.64 }
}

Config["AmbulanceJob"]["DoctorPedBlips"] = {
    vector3(1831.939941, 3673.058105, 34.159985),
    vector3(-248.150, 6331.917, 31.426)
}

Config["AmbulanceJob"]["RespawnPosition"] = {
    vector3(348.223053, -1402.208252, 32.42253),
    vector3(1840.957153, 3680.425781, 34.159954),
    vector3(-248.150, 6331.917, 32.42622)
}

Config["AmbulanceJob"]["PharmacyShop"] = {
    {label = "Bandage", item = "bandage", price = 500, utility = "small"},
    {label = "Medikit", item = "medikit", price = 1250, utility = "big"},
    {label = "Défibrillateur", item = "defibrillateur", price = 2000, utility = "resuscitation"}
}

Config["AmbulanceJob"]["Price"] = {
    ["small"] = 1000,
    ["big"] = 2500,
    ["resuscitation"] = 4000
}

Config["AmbulanceJob"]["ATA"] = { -- time in minutes
    ["other"] = 10,
    ["melee"] = 15,
    ["weapon"] = 30,
    ["decoreco"] = 30,
} 

Config["AmbulanceJob"]["Garage"] = vector3(311.849487, -1439.116455, 29.805668)
Config["AmbulanceJob"]["GarageSpawn"] = vector3(297.326752, -1441.293457, 29.801003)
Config["AmbulanceJob"]["GarageHeading"] = 230.02484130859
Config["AmbulanceJob"]["DeleteCar"] = vector3(297.326752, -1441.293457, 29.801003)
Config["AmbulanceJob"]["Cloakroom"] = vector3(378.331299, -1410.993652, 32.936226)
Config["AmbulanceJob"]["Pharmacy"] = vector3(352.37307739258, -1406.2397460938, 32.422588348389)
Config["AmbulanceJob"]["Cooldown"] = 10 -- secondes

Config["AmbulanceJob"]["GarageVehicle"] = {
    {label = "Declasse Alamo", vehicle = "emsalamo", grade = 0},
    {label = "Cheval Fugitive", vehicle = "emsfugitive", grade = 0},
    {label = "Vapid Caracara", vehicle = "emscara", grade = 0},
    {label = "Nagaski BF400", vehicle = "emsbf400", grade = 0},
    {label = "Vapind Sandstorm", vehicle = "emsamb3", grade = 0},
}

Config["AmbulanceJob"]["Uniform"] = {
    Uniforms = {
        male = {
            ['tshirt_1'] = 212, ['tshirt_2'] = 0,
            ['torso_1'] = 250, ['torso_2'] = 1,
            ['arms'] = 85,
            ['pants_1'] = 327, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ["decals_1"] = 58, ["decals_2"] = 1,
            ['chain_1'] = 126, ['chain_2'] = 0,
        },
        female = {
            ['tshirt_1'] = 6, ['tshirt_2'] = 0,
            ['torso_1'] = 330, ['torso_2'] = 0,
            ['arms'] = 236,
            ['pants_1'] = 3, ['pants_2'] = 1,
            ['shoes_1'] = 148, ['shoes_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ["decals_1"] = 0, ["decals_2"] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
        }
    }
}