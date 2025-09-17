---@return void
function _core_nui:onEnterSafeZone(time)
    
    sendUIMessage({
        event = 'EnterSafeZone',
        time = time
    })

end