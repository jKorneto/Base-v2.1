-- local isAfk = false

-- RegisterCommand("afk", function()
--     if not isAfk and not exports["core"]:PlayerIsInSafeZone() then
--         ESX.ShowNotification("Vous ne pouvez entrer en mode AFK qu'en SafeZone")
--         return
--     end
    
--     isAfk = not isAfk
--     TriggerServerEvent("iZeyy:Afk:State", isAfk)
-- end)

-- local function DrawTextOnScreen(text, x, y, scale, r, g, b)
--     SetTextFont(ServerFontStyle)
--     SetTextProportional(1)
--     SetTextScale(scale, scale)
--     SetTextColour(r, g, b, 255)
--     SetTextEdge(1, 0, 0, 0, 255)
--     SetTextCentre(true)
--     SetTextEntry("STRING")
--     AddTextComponentString(text)
--     DrawText(x, y)
-- end

-- local function Blur(bool)
--     if (bool) then
--         SetTimecycleModifier("hud_def_blur")
--         SetTimecycleModifierStrength(1.0)
--         DisplayRadar(false)
--         TriggerEvent('iZeyy:Hud:StateStatus', false)
--         TriggerEvent("iZeyy::Hud::StateHud", false)
--     else
--         ClearTimecycleModifier()
--         SetTimecycleModifierStrength(0.0)
--         DisplayRadar(true)
--         TriggerEvent('iZeyy:Hud:StateStatus', true)
--         TriggerEvent("iZeyy::Hud::StateHud", true)
--     end
-- end

-- local function Afk(bool)
--     Blur(bool)
--     while isAfk do
--         Wait(0)
--         local player = PlayerPedId()
--         local coords = GetEntityCoords(player)
--         SetEntityInvincible(player, true)
--         DrawTextOnScreen("Vous êtes en mode AFK", 0.50, 0.42, 1.0, 255, 255, 255)
--         DrawTextOnScreen("Vous gagné 1 Jetons par minute", 0.50, 0.52, 0.50, 200, 200, 200)

--         if #(coords - Config["Afk"]["AfkCoords"]) > 75.0 then
--             SetEntityCoords(player, Config["Afk"]["AfkCoords"])
--         end
--     end
-- end

-- RegisterNetEvent("iZeyy:Afk:State", function(state)
--     isAfk = state
--     Afk(state)
-- end)
