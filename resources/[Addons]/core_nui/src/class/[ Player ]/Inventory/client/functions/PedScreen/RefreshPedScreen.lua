function _OneLifeInventory:RefreshPedScreen()
    if DoesEntityExist(self.CurrentPedPreview) then
        self:DeletePedScreen()
        Wait(500)
        self:CreatePedScreen(false)
    end
end