---@return void
function _core_nui:SetRadioSound(sound, valume)

    sendUIMessage({
        event = 'SetRadioSound',
        dataSound = {
            sound = sound,
            volume = valume
        }
    })

end