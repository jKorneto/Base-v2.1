Config["Gamemaster"] = {}


Config["Gamemaster"]["BlipsPos"] = vector3(385.538055, -63.303288, 103.363197)
Config["Gamemaster"]["BlipsLabel"] = "F.Clinton & Partner"
Config["Gamemaster"]["BlipsSprite"] = 88
Config["Gamemaster"]["BlipsColor"] = 2

Config["Gamemaster"]["RequiredJob"] = "clintongm"

Config["Gamemaster"]["Annoucement"] = {
    ["open"] = "F.Clinton & Partner est desormais ouvert",
    ["close"] = "F.Clinton & Partner est desormais fermé merci de repasser plus tard",
    ["recruitment"] = "F.Clinton & Partner a lancé une session de recrutement presenter vous afin de participer"
}

Config["Gamemaster"]["Peds"] = {
    { model = "u_m_m_jewelthief", position = vector3(384.392303, -69.750076, 103.363197 - 1.0), heading = 352.30914306641 }, -- Caméra
    { model = "u_m_m_aldinapoli", position = vector3(388.070984, -68.054176, 103.363281 - 1.0), heading = 63.658187866211 }, -- Garage
}

Config["Gamemaster"]["EnterCoords"] = vector3(388.921265, -76.303398, 68.180527)
Config["Gamemaster"]["EnterHeading"] = 162.39596557617

Config["Gamemaster"]["InteriorCoords"] = vector3(370.687927, -56.455414, 103.363197)
Config["Gamemaster"]["InteriorHeading"] = 253.36306762695

Config["Gamemaster"]["GarageInteractPos"] = vector3(388.070984, -68.054176, 103.363281)
Config["Gamemaster"]["GarageSpawnPos"] = vector3(363.523560, -76.041016, 67.303993)
Config["Gamemaster"]["GarageSpawnHeading"] = 251.90121459961
Config["Gamemaster"]["GarageSpawnPedCoords"] = vector3(364.369385, -73.002350, 67.301910)
Config["Gamemaster"]["GarageSpawnPedHeding"] = 169.6021270752

Config["Gamemaster"]["VehList"] = {
    { label = "Bisons HF", desc = "Ce véhicule possède 4 places, il est de catégorie 4x4",  model = "gbbisonhf" },
    { label = "Sultan RSX", desc = "Ce véhicule possède 4 places, il est de catégorie sportive",  model = "gbsultanrsx" },
    { label = "Neon CT", desc = "Ce véhicule possède 4 places, il est de catégorie sportive",  model = "gbneonctss" },
    { label = "Sentinel GTS", desc = "Ce véhicule possède 4 places, il est de catégorie sportive",  model = "gbsentinelgts" },
}

Config["Gamemaster"]["CameraInteractPos"] = vector3(384.392303, -69.750076, 103.363197)

Config["Gamemaster"]["Cam"] = vector3(431.326263, -118.358994, 77.920372)
Config["Gamemaster"]["CamRot"] = vector3(-10.0, 0.0, 46.561145782471)