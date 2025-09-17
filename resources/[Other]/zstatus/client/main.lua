local function toggleStatusUI(state)
    SendNUIMessage({
        type = "toggleVisibility",
        visible = state
    })
end

exports("toggleStatusUI", function(state)
    return toggleStatusUI(state)
end)

AddEventHandler("iZeyy:Hud:StateStatus", function(bool)
    if (type(bool) == "boolean") then
        toggleStatusUI(bool)
    end
end)

AddEventHandler("iZeyy:Hud:changeMicMode", function(mode)
    SendNUIMessage({
        type = "updateMicLevel",
        micLevel = mode
    })
end)

CreateThread(function()
    local isDisabled = false

    while true do
        local pauseMenuActive = IsPauseMenuActive()

        if (pauseMenuActive and not isDisabled) then
            toggleStatusUI(false)
            isDisabled = true
        elseif (not pauseMenuActive and isDisabled) then
            toggleStatusUI(true)
            isDisabled = false
        end

        Wait(1000)
    end
end)