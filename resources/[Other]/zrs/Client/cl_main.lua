local isFirstSpawn = false

RegisterNetEvent("playerSpawned")
AddEventHandler("playerSpawned", function()
    if not isFirstSpawn then
        SetTimeout(3500, function()
            exports["engine"]:enterSpawn()
        end)
        SetTimeout(9500, function()
            isFirstSpawn = true
        end)
    end
end)