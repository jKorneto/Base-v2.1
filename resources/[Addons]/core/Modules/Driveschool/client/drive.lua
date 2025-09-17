local CurrentCheckPoint = 0
local EliminationFouls = 0
local LastCheckPoint = -1
local CurrentBlip = nil
local InExam = false
local eliminated = false

function iZeyy:StopExam(success)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if success then
        TriggerServerEvent("iZeyy:DrivingSchool:AddDriverLicense", "drive")
        ESX.ShowNotification('Bravo ! Vous avez reçu votre permis !')
        
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
            SetVehicleAsNoLongerNeeded(vehicle)
        end
    else
        ESX.ShowNotification('Malheureusement, vous avez raté le test !')
    end
    
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
end

local CheckPoints = {
    { blipPos = vector3(270.77, -1356.34, 31.42), showNotif = function() ESX.ShowNotification("Continuez comme ça") end },
    { blipPos = vector3(221.77, -1405.34, 29.14), showNotif = function() ESX.ShowNotification("Super, continuez vos efforts !") end },
    { blipPos = vector3(178.49, -1402.38, 28.83), showNotif = function() ESX.ShowNotification("Très bien, vous êtes sur la bonne voie !") end },
    { blipPos = vector3(-80.36, -1364.51, 29.42), showNotif = function() ESX.ShowNotification("Excellent travail, continuez comme ça !") end },
    { blipPos = vector3(-218.34, -1428.44, 31.35), showNotif = function() ESX.ShowNotification("Vous êtes formidable, gardez le rythme !") end },
    { blipPos = vector3(-49.25, -1598.67, 29.25), showNotif = function() ESX.ShowNotification("Bien joué ! Restez concentré !") end },
    { blipPos = vector3(153.48, -1769.21, 28.99), showNotif = function() ESX.ShowNotification("Parfait ! Continuez à bien conduire !") end },
    { blipPos = vector3(269.12, -1684.42, 29.28), showNotif = function() ESX.ShowNotification("Bravo, vous faites du bon travail !") end },
    { blipPos = vector3(455.09, -1659.63, 29.30), showNotif = function() ESX.ShowNotification("Superbe conduite, continuez !") end },
    { blipPos = vector3(257.12, -1446.90, 29.27), showNotif = function() ESX.ShowNotification("Vous gérez bien, continuez comme ça !") end },
    { blipPos = Config["DriveSchool"]["EndExamPos"], showNotif = function()
        local success = EliminationFouls < 5
        iZeyy:StopExam(success)
    end }
}

function iZeyy:StartDrivingInfo()
    eliminated = false
    InExam = true
    while InExam do
        Wait(0)

        local nextCheckPoint = CurrentCheckPoint + 1

        if CheckPoints[nextCheckPoint] == nil then
            RemoveBlip(CurrentBlip)
            InExam = false
            return
        end

        if CurrentCheckPoint ~= LastCheckPoint then
            if DoesBlipExist(CurrentBlip) then RemoveBlip(CurrentBlip) end
            CurrentBlip = AddBlipForCoord(CheckPoints[nextCheckPoint].blipPos.x, CheckPoints[nextCheckPoint].blipPos.y, CheckPoints[nextCheckPoint].blipPos.z)
            SetBlipRoute(CurrentBlip, true)
            SetBlipRouteColour(CurrentBlip, 3)
            SetBlipColour(CurrentBlip, 3)
            SetBlipScale(CurrentBlip, 0.8)
            LastCheckPoint = CurrentCheckPoint
        end

        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CheckPoints[nextCheckPoint].blipPos.x, CheckPoints[nextCheckPoint].blipPos.y, CheckPoints[nextCheckPoint].blipPos.z - 0.90, true)

        if distance <= 3.0 then
            CheckPoints[nextCheckPoint].showNotif()
            CurrentCheckPoint = CurrentCheckPoint + 1
        end

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            local speedLimits = 100

            if EliminationFouls < 5 then
                if speed > speedLimits then
                    EliminationFouls = EliminationFouls + 1
                    ESX.ShowNotification('Vous avez fait une erreur ! Vous roulez trop vite !\nNombre d\'erreurs: ' .. EliminationFouls .. '/5')
                    Wait(2000)
                end
            end

            if EliminationFouls >= 5 then
                if (not eliminated) then
                    iZeyy:StopExam(false)
                    eliminated = true
                end
            end

        end
    end
end

function iZeyy:StartExam()
    CurrentCheckPoint = 0
    EliminationFouls = 0
    
    -- ESX.Game.SpawnVehicle(Config["DriveSchool"]["VehModel"], Config["DriveSchool"]["StartExamPos"], Config["DriveSchool"]["StartExamHeading"], function(vehicle)
    --     local newPlate = Vehicle:GeneratePlate()
    --     SetVehicleNumberPlateText(vehicle, newPlate)
    --     exports["core_nui"]:SetFuel(vehicle, 100)
    --     TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    --     iZeyy:StartDrivingInfo()
    -- end)
    iZeyy:StartDrivingInfo()
end

AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" and InExam then
        local victim = args[1]
        local attacker = args[2]

        if IsEntityAVehicle(victim) then
            local playerPed = PlayerPedId()
            local playerVehicle = GetVehiclePedIsIn(playerPed, false)

            if victim == playerVehicle then
                if EliminationFouls < 5 then
                    EliminationFouls = EliminationFouls + 5
                    ESX.ShowNotification("Vous avez fait une faute éliminatoire (accident) échec de l'épreuve")
                end
            end
        end
    end
end)
