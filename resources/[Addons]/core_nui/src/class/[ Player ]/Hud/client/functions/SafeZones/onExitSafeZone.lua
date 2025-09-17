---@return void
function _core_nui:onExitSafeZone(time)

    sendUIMessage({
        event = 'ExitSafeZone',
        time = time
    })

end