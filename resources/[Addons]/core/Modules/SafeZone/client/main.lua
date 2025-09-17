local SafeZone = {}
local playerIsInSafeZone = false

function SafeZone:IsPlayerInRadius()
    return playerIsInSafeZone or false
end

function SafeZone:checkControls()
    if (playerIsInSafeZone) then
        local player = Client.Player:GetPed()
        local disabledKeys = Config["SafeZone"]["DisableKey"]

        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
        for i = 1, #disabledKeys do
            local currentKey = disabledKeys[i]
            
            if (currentKey ~= nil) then
                DisableControlAction(currentKey.group, currentKey.key, true)
                if IsDisabledControlJustPressed(currentKey.group, currentKey.key) then
                    if IsControlPressed(0, 19) or IsDisabledControlPressed(0, 19) then
                        return
                    else
                        ESX.ShowNotification("Action non autorisé en zone safe")
                    end
                end
            end
        end
    end
end

function SafeZone:checkVehicles()
    if (playerIsInSafeZone) then
        local player = Client.Player:GetPed()

        if (player) then
            local vehicleList = GetGamePool("CVehicle")
            
            for i = 1, #vehicleList do
                local currentVehicle = vehicleList[i]
                if (currentVehicle ~= 0 and DoesEntityExist(currentVehicle)) then
                    if not IsVehicleSeatFree(currentVehicle, -1) then
                        SetEntityNoCollisionEntity(player, currentVehicle, true)
                        SetEntityNoCollisionEntity(currentVehicle, player, true)
                    end
                end
            end
        end
    end
end

function SafeZone:onEntered()
    if (not playerIsInSafeZone) then
        local player = Client.Player:GetPed()

        if (player) then
            NetworkSetFriendlyFireOption(false)
            SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
            DisablePlayerFiring(player, true)
            exports['szone']:ShowNuiInSafeZone()
            ESX.ShowNotification("Vous entrez en zone sécurisée")
            playerIsInSafeZone = true
            return true
        end
    end

    return false
end

function SafeZone:onExited()
    if (playerIsInSafeZone) then
        local player = Client.Player:GetPed()

        if (player) then
            NetworkSetFriendlyFireOption(true)
            DisablePlayerFiring(player, false)
            exports['szone']:ShowNuiNotInSafeZone()
            ESX.ShowNotification("Vous sortez d'une zone sécurisée")
            playerIsInSafeZone = false
            return true
        end
    end

    return false
end

CreateThread(function()
    for k, v in pairs(Config["SafeZone"]["Coords"]) do
        local zone = Game.Zone("SafeZone"..k)

        zone:Start(function()
            zone:SetTimer(1000)
            zone:SetCoords(v.position)

            zone:IsPlayerInRadius(v.radius, function()
                zone:SetTimer(0)
                local player = Client.Player

                if (player) then
                    local job = player:GetJob().name

                    if (Config["SafeZone"]["BypassJob"][job] == nil) then
                        SafeZone:checkVehicles()
                        SafeZone:checkControls()
                        if (not playerIsInSafeZone) then
                            SafeZone:onEntered()
                        end
                    else
                        playerIsInSafeZone = true
                    end
                end
            end, true, false)

            zone:RadiusEvents(v.radius, nil, function()
                if (playerIsInSafeZone) then
                    SafeZone:onExited()
                end
            end)
        end)
    end
end)

exports("PlayerIsInSafeZone", function()
    return SafeZone:IsPlayerInRadius()
end)
