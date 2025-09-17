---@return void
function _core_nui:SetRadioUse(bool)

    sendUIMessage({
        event = 'SetRadioUse',
        RadioUse = bool
    })

end