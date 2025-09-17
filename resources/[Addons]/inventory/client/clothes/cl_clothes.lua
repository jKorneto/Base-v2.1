local Module = {}
Module.cooldown = false

ScriptClient.Clothes = Module

function Module:GetSex()
    local localPed = PlayerPedId()
    if GetEntityModel(localPed) == GetHashKey("mp_m_freemode_01") then
        return "male"
    elseif GetEntityModel(localPed) == GetHashKey("mp_f_freemode_01") then
        return "female"
    end
end

---@param dict string
---@param anim string
---@param flag number
---@param time number
---@param cb function
function Module:PlayEmote(dict, anim, flag, time, cb)
    local localPlayer = PlayerPedId()

    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(100)
    end

    if IsPedInAnyVehicle(localPlayer) then
        flag = 51
    end

    TaskPlayAnim(localPlayer, dict, anim, 3.0, 3.0, time, flag, 0, false, false, false)

    local waitMS = time - 500

    if waitMS < 500 then
        waitMS = 500
    end

    self.cooldown = true

    SetTimeout(waitMS, function()
        self.cooldown = false
    end)

    Wait(waitMS)

    cb()
end
