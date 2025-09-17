local PedScreen = {}
---@type number
PedScreen.ped = nil

ScriptClient.PedScreen = PedScreen

function PedScreen:HideHUD()
    TriggerEvent("iZeyy::Hud::StateHud", false)
    TriggerEvent("iZeyy:Hud:StateStatus", false)
end

function PedScreen:ShowHUD()
    TriggerEvent("iZeyy::Hud::StateHud", true)
    TriggerEvent("iZeyy:Hud:StateStatus", true)
end

function PedScreen:Create()

    PedScreen:HideHUD()

    if DoesEntityExist(self.ped) or GetFollowPedCamViewMode() == 4 or IsCamActive(GetRenderingCam()) or IsCinematicCamInputActive() then return end
    
    local player = PlayerPedId()
    clonedPed = CreatePed(26 , GetEntityModel(PlayerPedId()), nil, nil, nil, 0, false, false)
    SetEntityCollision(clonedPed, false, false)
    SetEntityInvincible(clonedPed, true)
    NetworkSetEntityInvisibleToNetwork(clonedPed, true)
    ClonePedToTarget(PlayerPedId(), clonedPed)
    SetEntityCanBeDamaged(clonedPed, false)
    SetBlockingOfNonTemporaryEvents(clonedPed, true)
    RequestAnimDict("anim@amb@nightclub@peds@")
    DisableIdleCamera(true)
    showPed = true

    local positionBuffer = {}
    local bufferSize = 5
    
    while showPed do 
        if (GetEntitySpeed(player) * 3.6) < 50 then
            local world, normal = GetWorldCoordFromScreenCoord(0.5, 0.75)
            local depth = 4.0
            local target = world + normal * depth
            local camRot = GetGameplayCamRot(2)

            table.insert(positionBuffer, target)
            if #positionBuffer > bufferSize then
                table.remove(positionBuffer, 1)
            end

            local averagedTarget = vector3(0, 0, 0)
            for _, position in ipairs(positionBuffer) do
                averagedTarget = averagedTarget + position
            end
            averagedTarget = averagedTarget / #positionBuffer

            SetEntityVisible(clonedPed, true)
            SetEntityCoords(clonedPed, averagedTarget.x, averagedTarget.y, averagedTarget.z, false, false, false, false)
            SetEntityHeading(clonedPed, camRot.z + 180.0)
            SetEntityRotation(clonedPed, camRot.x*(-1), 0, camRot.z + 180.0, false, false)
            SetEntityCollision(clonedPed, false, true)
            TaskPlayAnim(clonedPed, "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", 1.0,-1.0, 5000, 1, 1, true, true, true)

            self.ped = clonedPed
        else
            SetEntityVisible(clonedPed, false)
        end

        Wait(0)
    end

end

function PedScreen:Delete()
    if DoesEntityExist(self.ped) then
        showPed = false
        DeleteEntity(self.ped)
        PedScreen:ShowHUD()
    else
        showPed = false
        PedScreen:ShowHUD()
    end
end