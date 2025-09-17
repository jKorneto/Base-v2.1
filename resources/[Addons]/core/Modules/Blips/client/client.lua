local Blips = {
    {
        name = "Pont de Cayo Perico",
        coords = vector3(1454.602783, -2582.300781, 48.380878),
        color = 17,
        sprite = 858,
        scale = 0.5,
        shortRange = true,
    },
    -- Activité
    {
        name = "Zone de Recontre - Beach Club",
        coords = vector3(-1519.614624, -1495.630005, 6.243513),
        color = 2,
        sprite = 836,
        scale = 0.5,
        shortRange = true,
    },
    {
        name = "Zone de Recontre - LS Festival",
        coords = vector3(687.055603, 556.870850, 129.046219),
        color = 44,
        sprite = 136,
        scale = 0.5,
        shortRange = true,
    },
    {
        name = "Zone de Recontre - Pacif Bluffs",
        coords = vector3(-2835.126953, 34.685665, 14.363436),
        color = 32,
        sprite = 267,
        scale = 0.4,
        shortRange = true,
    },
    {
        name = "Zone de Recontre - Karting",
        coords = vector3(-155.319153, -2137.567627, 16.705013),
        color = 59,
        sprite = 735,
        scale = 0.5,
        shortRange = true,
    },
}

CreateThread(function()
    for _, blip in pairs(Blips) do
        local Blip = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
        SetBlipSprite(Blip, blip.sprite)
        SetBlipScale(Blip, blip.scale)
        SetBlipAsShortRange(Blip, blip.shortRange)
        SetBlipColour(Blip, blip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blip.name)
        EndTextCommandSetBlipName(Blip)
    end
end)
