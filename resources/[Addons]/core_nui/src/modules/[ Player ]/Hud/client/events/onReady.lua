CreateThread(function()
    while (MOD_HUD.class == nil) do
        Wait(100)
    end

    MOD_HUD.class:SetHudVisible(true)

    MOD_HUD.ready = true
    TriggerEvent("OneLife:Hud:ReadyHudClient")
end)