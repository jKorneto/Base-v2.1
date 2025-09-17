local hasEntered = true
local playerLastPosition = {} 

Shared.Events:OnNet(Engine["Enums"].EnterSpawn.Events.startMusic, function(xPlayer, position)
    if (type(xPlayer) == "table" and type(position) == "vector3") then
        local soundInstance = exports["spatial_audio"]:Play(xPlayer.source, "EnterSpawnMusic", position)

        hasEntered = true
        playerLastPosition[xPlayer.identifier] = xPlayer.getLastPosition()
        exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, xPlayer.source + 1)
    end
end)

Shared.Events:OnNet(Engine["Enums"].EnterSpawn.Events.stopMusic, function(xPlayer)
    if (type(xPlayer) == "table") then
        hasEntered = false
        playerLastPosition[xPlayer.identifier] = nil
        TriggerEvent("engine:enterspawn:finish", xPlayer.source)
        exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 0)
        exports["spatial_audio"]:Stop(xPlayer.source, xPlayer.source)
    end
end)

AddEventHandler("playerDropped", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (hasEntered) then
            if (playerLastPosition[xPlayer.identifier] ~= nil) then
                local lastPosition = playerLastPosition[xPlayer.identifier]
                xPlayer.setLastPosition(vector3(lastPosition.x, lastPosition.y, lastPosition.z))
            end
        end
    end
end)

exports("inEnterSpawn", function()
    return hasEntered
end)