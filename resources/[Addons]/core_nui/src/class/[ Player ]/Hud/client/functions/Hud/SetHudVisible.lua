---@return void
function _core_nui:SetHudVisible(bool)

    sendUIMessage({
        ShowHud = bool
    })

    self.StateHud = bool

end