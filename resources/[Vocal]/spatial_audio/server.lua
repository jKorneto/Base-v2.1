local Sounds = {}
local SoundIncrementer = 0

exports("Play", function(target, sound, coords)
    local soundInstanceTbl = {
        sound = sound,
        soundInstance = tonumber(target),
        creation = os.time(),
        position = coords
    }

    TriggerClientEvent("spatial_audio:addServerSound", target, soundInstanceTbl)

    Sounds[target] = soundInstanceTbl

    return soundInstance
end)

exports("Loop", function(target, soundInstance, loop)
    Sounds[soundInstance].position = loop
    TriggerClientEvent("spatial_audio:action", target, "Loop", soundInstance, loop)
end)

exports("Stop", function(target, soundInstance)
    Sounds[target] = nil
    TriggerClientEvent("spatial_audio:action", target, "Stop", tonumber(target))
end)