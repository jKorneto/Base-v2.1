local isPlayerDead = false
local lastActivationTime = 0

AddEventHandler("esx:playerLoaded", function()
    ESX.TriggerServerCallback('OneLifeRP:GetDeath', function(theisDead)
        isDead = theisDead
    end)
end)

function GetDeath()
    return isDead
end

function ShowDeathMessage()
    local scaleform = RequestScaleformMovie("mp_big_message_freemode")
    
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString("~s~VOUS ÊTES DANS LE COMA~s~")
    PushScaleformMovieFunctionParameterString("Appuyez sur [~s~ENTRÉE~s~] pour envoyer un signal de détresse")
    EndScaleformMovieMethod()

    return scaleform
end

-- Fonction pour afficher du texte à l'écran
-- Fonction pour dessiner du texte à l'écran
function DrawTextOnScreen(text, x, y, scale, r, g, b, a)
    SetTextFont(ServerFontStyle or 0) -- Choix de la police
    SetTextProportional(1)
    SetTextScale(scale, scale) -- Définit la taille du texte
    SetTextColour(r, g, b, a) -- Définit la couleur du texte
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true) -- Centre le texte
    SetTextEntry("STRING")
    AddTextComponentString(text) -- Ajoute le texte
    DrawText(x, y) -- Dessine le texte aux coordonnées spécifiées
end

OpenDeathUI = function()
    CreateThread(function()
        local scaleform = ShowDeathMessage()
        DisplayRadar(false)
        local lastActivationTime = GetGameTimer() -- Initialise lastActivationTime
        local lastActivationTimeAfterDie = GetGameTimer() -- Initialise lastActivationTimeAfterDie

        while isPlayerDead do
            Wait(0)
            DisableAllControlActions()
            EnableControlAction(0, 191, true) -- Touche ENTRÉE
            EnableControlAction(0, 38, true)  -- Touche E

            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

            local currentTime = GetGameTimer()
            if IsControlJustPressed(0, 191) then -- Si la touche ENTRÉE est pressée
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
                local playerDead = GetPlayerServerId(PlayerId())
                TriggerServerEvent('ambulance:sendsignal', playerDead, x, y, z)
                -- print("ID : "..playerDead.." | Position : "..x..","..y..","..z)
            end

            -- Affiche le message directement sans utiliser ESX.SetTimeout
            local currentTimeAfterDie = GetGameTimer()
            if currentTimeAfterDie - lastActivationTimeAfterDie > Config.TimeToRespawn then -- 900 Seconde
                DrawTextOnScreen("Appuyez sur [~s~E~s~] pour reapparaitre", 0.5, 0.95, 0.3, 255, 255, 255, 255)
                if IsControlJustPressed(0, 38) then
                    SetEntityCoords(PlayerPedId(), Config.RespawningPlace)
                    TriggerServerEvent('réanimerafterdie')
                    isPlayerDead = false
                    currentTimeAfterDie = currentTimeAfterDie
                end
            end
        end

        SetScaleformMovieAsNoLongerNeeded(scaleform)
    end)
end


-- local timer = Config.TimeToRespawn
-- local timerVip = Config.TimeToRespawnVip
-- local gotpressed = false
-- local noptmort = false

-- openDeathMenuWlh = function()
--     local mainMenu = RageUI.CreateMenu("", "Vous êtes mort")
--     mainMenu.Closable = false
--     RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
--     gotpressed = false
--     noptmort = false
--     CreateThread(function()
--         local playerVip = exports.epicenter:GetVipLevel()
--         if playerVip == 1 then
--             CreateThread(function()
--                 while mainMenu do
--                     timerVip = timerVip - 1
--                     if (timerVip <= 0) then
--                         timerVip = Config.TimeToRespawnVip;
--                         noptmort = true;
--                     end
--                     Wait(1000)
--                 end
--             end)
--             while mainMenu do
--                 DisableAllControlActions();
--                 EnableControlAction(0, 245, true);
--                 RageUI.IsVisible(mainMenu, function()
--                     if (not gotpressed) then
--                         RageUI.Button("Envoyer un signal de détresse", nil, {RightLabel = "→"}, true, {
--                             onSelected = function()
--                                 x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
--                                 local playerDead = GetPlayerServerId(PlayerId())
--                                 TriggerServerEvent('ambulance:sendsignal',playerDead, x, y, z)
--                             end
--                         })
--                     else
--                         ESX.SetTimeout(300000, function()
--                             gotpressed = false
--                         end)
--                         RageUI.Button("Loading...", "Vous venez d'envoyer un signal patienter 5 minutes avant d'en envoyer un nouveau...", {RightLabel = ""}, true, {
--                             onSelected = function()
--                           end
--                         })
--                     end
--                     if (not noptmort) then
--                         RageUI.Button("~s~[VIP]~s~ Réaparition possible dans "..timerVip.." secondes", nil, {RightLabel = ""}, false, {
--                             onSelected = function()
--                             end
--                         })
--                     else
--                         RageUI.Button("Réapparaître", nil, {}, true, {
--                             onSelected = function()
--                                 SetEntityCoords(PlayerPedId(), Config.RespawningPlace)
--                                 TriggerServerEvent('réanimerafterdie')
                            
--                                 Wait(1000)
--                                 gotpressed = false
--                                 noptmort = false
--                             end
--                         })
--                     end
--                 end)
--                 if (not RageUI.Visible(mainMenu)) then
--                     mainMenu = RMenu:DeleteType(mainMenu, true)
--                     gotpressed = false
--                     noptmort = false
--                     timerVip = Config.TimeToRespawnVip
--                 end
--                 Wait(0)
--             end
--         else
--             CreateThread(function()
--                 while mainMenu do
--                     timer = timer - 1
--                     if (timer <= 0) then
--                         timer = Config.TimeToRespawn;
--                         noptmort = true;
--                     end
--                     Wait(1000)
--                 end
--             end)
--             while mainMenu do
--                 DisableAllControlActions();
--                 EnableControlAction(0, 245, true);
--                 RageUI.IsVisible(mainMenu, function()
--                     if (not gotpressed) then
--                         RageUI.Button("Envoyer un signal de détresse", nil, {RightLabel = "→"}, true, {
--                             onSelected = function()
--                                 x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
--                                 local playerDead = GetPlayerServerId(PlayerId())
--                                 TriggerServerEvent('ambulance:sendsignal',playerDead, x, y, z)
--                                 -- print(playerDead)
--                                 gotpressed = true
--                             end
--                         })
--                     else
--                         ESX.SetTimeout(300000, function()
--                             gotpressed = false
--                         end)
--                         RageUI.Button("Loading...", "Vous venez d'envoyer un signal patienter 5 minutes avant d'en envoyer un nouveau...", {RightLabel = ""}, true, {
--                             onSelected = function()
--                           end
--                         })
--                     end
--                     if (not noptmort) then
--                         RageUI.Button("Réaparition possible dans "..timer.." secondes", nil, {RightLabel = ""}, false, {
--                             onSelected = function()
--                             end
--                         })
--                     else
--                         RageUI.Button("Réapparaître", nil, {}, true, {
--                             onSelected = function()
--                                 SetEntityCoords(PlayerPedId(), Config.RespawningPlace)
--                                 TriggerServerEvent('réanimerafterdie')
                            
--                                 Wait(1000)
--                                 gotpressed = false
--                                 noptmort = false
--                             end
--                         })
--                     end
--                 end)
--                 if (not RageUI.Visible(mainMenu)) then
--                     mainMenu = RMenu:DeleteType(mainMenu, true)
--                     gotpressed = false
--                     noptmort = false
--                     timer = Config.TimeToRespawn
--                 end
--                 Wait(0)
--             end
--         end
--     end)
-- end