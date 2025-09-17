function _OneLifeInventory:openInventory(bool, func)
    if (bool) then func() end

    -- SetTimecycleModifier("hud_def_blur")

    if (self.settings.PedEnable) then
        self:CreatePedScreen(true)
    end

    self:SetKeepInputMode(true)
    DisplayRadar(false)
    TriggerEvent('iZeyy:Hud:StateStatus', false)
    TriggerEvent("iZeyy::Hud::StateHud", false)

    self:setInventoryVisible(true)
    SetNuiFocus(true, true)

end