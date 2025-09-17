---@return void
function _core_nui:SetMicStatus(bool)

    sendUIMessage({
        event = 'SetMicStatus',
        MicStatus = bool
    })

end