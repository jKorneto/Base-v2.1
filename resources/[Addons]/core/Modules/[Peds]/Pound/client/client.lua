for k, v in ipairs(Config["CustomPed"]["Pound"]) do
    
    Game.Peds:Spawn(GetHashKey(v.model), v.position, v.heading, true, true, function(ped)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end)

end