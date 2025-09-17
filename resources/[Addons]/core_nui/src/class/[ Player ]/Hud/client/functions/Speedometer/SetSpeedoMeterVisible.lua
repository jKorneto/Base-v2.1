---@return void
function _core_nui:SetSpeedoMeterVisible(bool)

    sendUIMessage({
        ShowSpeedoMeter = bool
    })

    self.StateSpeedoMeter = bool

end