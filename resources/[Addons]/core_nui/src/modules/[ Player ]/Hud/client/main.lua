MOD_HUD.ready = false

function MOD_HUD:onReady(callback)
    if (self.ready) then
        callback()
    else
        AddEventHandler('OneLife:Hud:ReadyHudClient', callback)
    end
end

MOD_HUD.class = _core_nui()