local main_menu = RageUI.AddMenu("", "Faites vos actions")
local isWaiting = false

local function DrawLoadingText(text, x, y)
    SetTextFont(ServerFontStyle)
    SetTextProportional(1)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255) 
    SetTextCentre(true)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

local function changeStation(stationPos, player)
    if (isWaiting) then
        local timeout = 10000
        local transitionTime = 38000
        local maxDist = 50
        local initialPos = GetEntityCoords(player)
        local startTime = GetGameTimer()
    
        ESX.ShowNotification("Vous avez été débité de " .. Config["Lstransit"]["Price"] .. "$ merci, bon voyage temps de voyage estimé a 40 secondes")

        CreateThread(function()
            local teleported = false
            
            while (GetGameTimer() - startTime < timeout) do
                Wait(1000)
                local currentPos = GetEntityCoords(player)
                local distance = #(currentPos - initialPos)
    
                if (distance > maxDist) then
                    isWaiting = false
                    ESX.ShowNotification("Vous êtes trop loin de la gare afin de prendre votre train")
                    return
                end
            end
        end)

        SetTimeout(timeout, function()
            CreateThread(function()

                while (GetGameTimer() - startTime < timeout) do
                    Wait(1000)
                    local currentPos = GetEntityCoords(player)
                    local distance = #(currentPos - initialPos)
        
                    if (distance > maxDist) then
                        isWaiting = false
                        ESX.ShowNotification("Vous êtes trop loin de la gare afin de prendre votre train")
                        return
                    end
                end
        
                if (isWaiting) then

                    CreateDui("https://cfx-nui-engine/Nui/assets/sounds/metro.mp3", 1, 1)

                    DoScreenFadeOut(1000)
                    Wait(1000)
                    FreezeEntityPosition(Client.Player:GetPed(), true)
                    SetEntityVisible(Client.Player:GetPed(), false)

                    TriggerEvent('iZeyy:Hud:StateStatus', false)
                    TriggerEvent("iZeyy::Hud::StateHud", false)

                    Wait(transitionTime)
                    SetEntityCoords(player, stationPos)
                    FreezeEntityPosition(Client.Player:GetPed(), false)
                    SetEntityVisible(Client.Player:GetPed(), true)
                    DoScreenFadeIn(1000)
                    Wait(1000)

                    ESX.ShowNotification("Vous êtes arrivé à destination")

                    TriggerEvent('iZeyy:Hud:StateStatus', true)
                    TriggerEvent("iZeyy::Hud::StateHud", true)

                    isWaiting = false
                end
            end)
        end)
    end
end

CreateThread(function()
    
    local function IsPlayerInZone(targetPos)
        local PlayerPed = Client.Player:GetPed()
        local PlayerCoords = GetEntityCoords(PlayerPed)
        return #(PlayerCoords - targetPos) < 10.0
    end

    main_menu:IsVisible(function(Items)
        local PlayerPed = Client.Player:GetPed()
        local PlayerCoords = GetEntityCoords(PlayerPed)
    
        for k, v in pairs(Config["Lstransit"]["Station"]) do
            local InZone = IsPlayerInZone(v.pedPos)
            local Desc = InZone and "~r~Vous êtes déjà à cette station" or nil
    
            Items:Button(v.label, Desc, { RightLabel = not InZone and (Config["Lstransit"]["Price"] .. "~g~$") or nil }, not InZone, {
                onSelected = function()
                    local playerPed = Client.Player:GetPed()
                    isWaiting = true
                    TriggerServerEvent("Core:Lstransit:BuyTicket", v.spawnPos, v.label)
                    main_menu:Close()
                end
            })            
        end
    end)
    

    for k, v in pairs(Config["Lstransit"]["Station"]) do

        Game.Peds:Spawn(GetHashKey("a_m_m_prolhost_01"), v.pedPos, v.pedHeading, true, true, function(ped)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
        end)

        local blip = AddBlipForCoord(v.pedPos)
        SetBlipSprite(blip, 280)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gare de Los Santos")
        EndTextCommandSetBlipName(blip)

        local LsTransit = Game.Zone("LsTransit")

        LsTransit:Start(function()
            LsTransit:SetTimer(1000)
            LsTransit:SetCoords(v.pedPos)

            LsTransit:IsPlayerInRadius(8.0, function()
                LsTransit:SetTimer(0)

                LsTransit:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                    LsTransit:KeyPressed("E", function()
                        if (not exports.core:IsServerInBlackout()) then
                            main_menu:Toggle()
                        else
                            ESX.ShowNotification("Nous sommes actuellement fermé en raison de la situation actuelle desolé")
                        end
                    end)

                end, false, false)

            end, false, false)

            LsTransit:RadiusEvents(3.0, nil, function()
                main_menu:Close()
            end)
        end)
    end

end)

RegisterNetEvent("Core:Lstransit:Pay", function(pos, station)
    if (isWaiting) then
        local playerPed = Client.Player:GetPed()
        changeStation(pos, playerPed)
        ExecuteCommand("me a pris un ticket direction " .. station)
    end
end)