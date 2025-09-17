local Settings = {}
Settings.blurEnabled = false
Settings.screenFX = false
Settings.radarEnabled = false
Settings.characterEnabled = false

ScriptClient.Settings = Settings

---@param state boolean
function Settings:SetBlurState(state)
    self.blurEnabled = state

    if ScriptClient.Player.State.inventoryOpened then
        if self.blurEnabled then
            TransitionToBlurred(0)
        else
            TransitionFromBlurred(0)
        end
    else
        TransitionFromBlurred(0)
    end
end

---@param state boolean
function Settings:SetScreenFxState(state)
    self.screenFX = state

    if ScriptClient.Player.State.inventoryOpened then
        if self.screenFX then
            StartScreenEffect("SwitchHUDIn", 0, true)
        else
            StopScreenEffect("SwitchHUDIn")
        end
    else
        StopScreenEffect("SwitchHUDIn")
    end
end

---@param state boolean
function Settings:SetRadarState(state)
    self.radarEnabled = state

    if ScriptClient.Player.State.inventoryOpened then
        if self.radarEnabled then
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
    else
        DisplayRadar(true)
    end
end

---@param state boolean
function Settings:SetCharacterState(state)
    self.characterEnabled = state

    if ScriptClient.Player.State.inventoryOpened then
        if self.characterEnabled then
            ScriptClient.PedScreen:Create()
        else
            ScriptClient.PedScreen:Delete()
        end
    else
        ScriptClient.PedScreen:Delete()
    end
end

AddEventHandler("inventory:onInventoryOpen", function()
    --Settings:SetBlurState(Settings.blurEnabled)
    Settings:SetRadarState(Settings.radarEnabled)
    --Settings:SetScreenFxState(Settings.screenFX)
    Settings:SetCharacterState(Settings.characterEnabled)
end)

AddEventHandler("inventory:onInventoryClose", function()
    --Settings:SetBlurState(Settings.blurEnabled)
    Settings:SetRadarState(Settings.radarEnabled)
    --Settings:SetScreenFxState(Settings.screenFX)
    Settings:SetCharacterState(Settings.characterEnabled)
end)

RegisterNUICallback("SETTINGS_BLUR_ENABLED", function(state, cb)
    -- Settings:SetBlurState(state)
    cb({})
end)
RegisterNUICallback("SETTINGS_SCREENFX_ENABLED", function(state, cb)
    -- Settings:SetScreenFxState(state)
    cb({})
end)
RegisterNUICallback("SETTINGS_RADAR_ENABLED", function(state, cb)
    Settings:SetRadarState(state)
    cb({})
end)
RegisterNUICallback("SETTINGS_CHARACTER_ENABLED", function(state, cb)
    Settings:SetCharacterState(state)
    cb({})
end)