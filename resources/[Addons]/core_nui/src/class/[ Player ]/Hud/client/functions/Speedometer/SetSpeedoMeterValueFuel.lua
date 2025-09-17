---@return void
function _core_nui:SetSpeedoMeterValueFuel(value)

    sendUIMessage({
        event = 'SetValueFuel',
        value = value
    })

end