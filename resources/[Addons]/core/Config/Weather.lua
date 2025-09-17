Config["Weather"] = {}

Config["Weather"]["Zones"] = {
    {
        name = "Los Santos", 
        coords = {x1 = -3700, y1 = -4000, x2 = 4000, y2 = 1000},
        currentWeather = nil,
        lastUpdateTime = nil
    },
    {
        name = "Sandy Shores", 
        coords = {x1 = -3700, y1 = 1000, x2 = 4000, y2 = 4500},
        currentWeather = nil,
        lastUpdateTime = nil
    },
    {
        name = "Paleto Bay", 
        coords = {x1 = -3700, y1 = 4500, x2 = 4000, y2 = 8000},
        currentWeather = nil,
        lastUpdateTime = nil
    }
}

Config["Weather"]["Chances"] = {
    ['morning'] = {
        {weather = 'EXTRASUNNY', weight = 0.5},
        {weather = 'CLEAR', weight = 0.4},
        {weather = 'SMOG', weight = 0.3},
        {weather = 'FOGGY', weight = 0.1},
        {weather = 'OVERCAST', weight = 0.1},
        {weather = 'CLOUDS', weight = 0.2},
        {weather = 'RAIN', weight = 0.05},
        {weather = 'THUNDER', weight = 0.01},
    },
    ['day'] = {
        {weather = 'EXTRASUNNY', weight = 0.7},
        {weather = 'CLEAR', weight = 0.5},
        {weather = 'SMOG', weight = 0.2},
        {weather = 'FOGGY', weight = 0.05},
        {weather = 'OVERCAST', weight = 0.1},
        {weather = 'CLOUDS', weight = 0.2},
        {weather = 'RAIN', weight = 0.05},
        {weather = 'THUNDER', weight = 0.01},
    },
    ['evening'] = {
        {weather = 'EXTRASUNNY', weight = 0.4},
        {weather = 'CLEAR', weight = 0.5},
        {weather = 'SMOG', weight = 0.3},
        {weather = 'FOGGY', weight = 0.1},
        {weather = 'OVERCAST', weight = 0.2},
        {weather = 'CLOUDS', weight = 0.3},
        {weather = 'RAIN', weight = 0.1},
        {weather = 'THUNDER', weight = 0.02},
    },
    ['night'] = {
        {weather = 'EXTRASUNNY', weight = 0.1},
        {weather = 'CLEAR', weight = 0.5},
        {weather = 'SMOG', weight = 0.3},
        {weather = 'FOGGY', weight = 0.2},
        {weather = 'OVERCAST', weight = 0.2},
        {weather = 'CLOUDS', weight = 0.3},
        {weather = 'RAIN', weight = 0.05},
        {weather = 'THUNDER', weight = 0.01},
    },
}