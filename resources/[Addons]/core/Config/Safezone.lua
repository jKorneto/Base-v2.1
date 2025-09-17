Config["SafeZone"] = {}

Config["SafeZone"]["Coords"] = {
    -- Garage
    { position = vector3(215.800, -810.057, 30.727), radius = 100.0 }, -- Central LS
    { position = vector3(1737.59, 3710.2, 34.14), radius = 40.0 }, -- Sandy
    { position = vector3(106.72, 6613.56, 31.99), radius = 40.0 }, -- Paleto
    { position = vector3(1846.56, 2585.86, 45.67), radius = 40.0 }, -- Prison
    { position = vector3(-1904.46, -333.84, 49.43), radius = 50.0 }, -- Hospital Ocean
    { position = vector3(-1148.96, 2682.05, 18.09), radius = 40.0 }, -- Military
    { position = vector3(-505.50, -611.76, 30.30), radius = 50.0 }, -- Garage Rouge
    { position = vector3(892.86, -44.15, 78.76), radius = 50.0 }, -- Casino
    { position = vector3(-283.95, -887.25, 31.08), radius = 50.0 }, -- Parking Rouge
    { position = vector3(-800.690125, -1494.606567, 1.578735), radius = 40.0 }, -- LS Dock (Bateau)
    { position = vector3(1333.3187255859, 4270.4702148438, 31.487182617188), radius = 40.0 }, -- Sandy Dock (Bateau)
    { position = vector3(-284.26812744141, 6629.0639648438, 7.2572021484375), radius = 40.0 }, -- Paleto Dock (Bateau)
    { position = vector3(4898.2153320312, -5168.9799804688, 2.4549560546875), radius = 40.0 }, -- Cayo Perico Dock (Bateau)
    { position = vector3(-1242.2901611328, -3393.1252441406, 13.9296875), radius = 40.0 }, -- LS (Plane)
    { position = vector3(1726.6153564453, 3291.3361816406, 41.17578125), radius = 40.0 }, -- Sandy (Plane)
    { position = vector3(4462.2329101562, -4468.6943359375, 4.240966796875), radius = 40.0 }, -- Cayo Perico (Plane)
    -- Fourrieres
    { position = vector3(-219.02, -1162.38, 23.02), radius = 40.0 }, -- Position 1
    { position = vector3(1644.10, 3808.20, 35.09), radius = 40.0 }, -- Position 2
    { position = vector3(-223.6, 6243.37, 31.49), radius = 40.0 }, -- Position 3
    { position = vector3(-866.7601, -2367.3723, 14.0244), radius = 40.0 }, -- Position 4
    { position = vector3(-1151.388, -205.2902, 37.95996), radius = 40.0 }, -- Position 5
    { position = vector3(-795.87, -1511.31, 1.59), radius = 40.0 }, -- Position 6
    { position = vector3(1338.94, 4225.45, 33.91), radius = 40.0 }, -- Position 7
    { position = vector3(-278.21, 6620.71, 7.5), radius = 40.0 }, -- Position 8
    { position = vector3(4906.80, -5172.02, 2.477), radius = 40.0 }, -- Position 9
    { position = vector3(-1254.21, -3401.60, 13.94), radius = 40.0 }, -- Position 10
    { position = vector3(1742.41, 3300.02, 41.22), radius = 40.0 }, -- Position 11
    { position = vector3(4443.55, -4480.67, 4.30), radius = 40.0 }, -- Position 12
    { position = vector3(120.3433, 6625.924, 31.95438), radius = 40.0 }, -- Position 13
    { position = vector3(484.04, -1319.47, 29.20), radius = 40.0 }, -- Position 14
    -- Entreprise
    { position = vector3(107.406990, -381.104126, 41.765842), radius = 90.0 }, -- SASP
    { position = vector3(336.857208, -1392.989136, 32.509247), radius = 60.0 }, -- SAMS
    -- Spawn
    { position = vector3(-1038.042236, -2737.847412, 13.797659); radius = 70.0 }, -- Spawn
    -- Other
    { position = vector3(129.278885, -1299.527710, 29.232737), radius = 60.0 }, -- Unicorn
    { position = vector3(-193.785522, -1328.445557, 42.777283), radius = 60.0 }, -- Bennys
    { position = vector3(-589.322815, -1120.282104, 22.178251), radius = 70.0 }, -- LS Customs
    { position = vector3(-1186.308960, -901.056396, 19.973478), radius = 40.0 }, -- Burger Shot
    { position = vector3(-68.488914, 76.767082, 79.325928), radius = 55.0 }, -- Concession
    { position = vector3(-700.419067, 267.299713, 94.302811), radius = 40.0 }, -- Agence Immo
    { position = vector3(331.088959, 287.145966, 115.006470), radius = 50.0 }, -- Galaxy
    { position = vector3(-1898.744751, 2081.283691, 150.080673), radius = 80.0 }, -- Vignoble
    { position = vector3(204.394150, -3164.843506, 5.511573), radius = 40.0 }, -- Nightclub
}



Config["SafeZone"]["DisableKey"] = {
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
    {group = 0, key = 165}, -- Racourcis clavier n*5
}

Config["SafeZone"]["BypassJob"] = {
    ["police"] = true,
    ["gouv"] = true
}