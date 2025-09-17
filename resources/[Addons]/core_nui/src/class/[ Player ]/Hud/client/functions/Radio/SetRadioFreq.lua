---@return void
function _core_nui:SetRadioFreq(string)

    sendUIMessage({
        event = 'SetRadioFreq',
        RadioFreq = string
    })

end