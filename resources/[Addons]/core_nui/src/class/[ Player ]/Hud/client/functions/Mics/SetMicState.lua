---@return void
function _core_nui:SetMicState(int)

    sendUIMessage({
        event = 'SetMicState',
        MicState = int
    })

end