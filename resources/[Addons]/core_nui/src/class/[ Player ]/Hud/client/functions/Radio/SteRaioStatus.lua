---@return void
function _core_nui:SetRadioStatus(bool)

    sendUIMessage({
        event = 'SetRadioStatus',
        RadioStatus = bool
    })

end