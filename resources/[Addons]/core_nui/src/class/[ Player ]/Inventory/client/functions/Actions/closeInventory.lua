function _OneLifeInventory:closeInventory()

    -- SetTimecycleModifier()

    self:DeletePedScreen()
 
    self:SetKeepInputMode(false)
    DisplayRadar(true)
    TriggerEvent('iZeyy:Hud:StateStatus', true)
    TriggerEvent("iZeyy::Hud::StateHud", true)

    self:setInventoryVisible(false)
    SetNuiFocus(false, false)

end