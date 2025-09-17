function MOD_Player:Process()
    local playerPed = PlayerPedId();
    MOD_Player.death = true;

    CreateThread(function()
        while IsPedFatallyInjured(playerPed) do
            Wait(300);
        end

        TriggerServerEvent("OneLife:Player:onRevive")
        MOD_Player.death = false;
    end);
end