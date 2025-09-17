local hospitalBed = {
    [-708683881] = true
}

local inBed = false

local function GetNearestBed()
    local player_coords = Client.Player:GetCoords()
    local hospital_beds = hospitalBed
    
    for hospital_bed in pairs(hospital_beds) do
        if (hospital_bed ~= nil) then
            local bed_entity = GetClosestObjectOfType(player_coords.x, player_coords.y, player_coords.z, 3.5, hospital_bed, true, true, true)
    
            if (bed_entity ~= 0) then
                return bed_entity
            end
        end
    end
    
    return false
end

local function PlayLayDownAnimation(bedCoords)
    local animDict = "anim@gangops@morgue@table@"
    local animName = "body_search"
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end

    SetEntityCoords(PlayerPedId(), bedCoords.x, bedCoords.y, bedCoords.z)
    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 80)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    inBed = true
end

local function StopLayDownAnimation()
    if (inBed) then
        inBed = false
        ClearPedTasksImmediately(PlayerPedId())
        ESX.ShowNotification("Vous vous êtes relevé du lit")
    end
end

CreateThread(function()

    local HospitalBed = Game.Zone("HospitalBed")
    local contextUi_hospital = nil
    local radius = 5.0

    HospitalBed:Start(function()
        HospitalBed:SetTimer(1000)
        local bed_near_entity = GetNearestBed()

        if (bed_near_entity and DoesEntityExist(bed_near_entity)) then
            local bedCoords = GetEntityCoords(bed_near_entity)

            if (type(bedCoords) == "vector3") then
                HospitalBed:SetCoords(bedCoords)
                HospitalBed:IsPlayerInRadius(radius, function()
                    HospitalBed:SetTimer(0)
                    local dist = #(Client.Player:GetCoords() - bedCoords)

                    if (not contextUi_hospital) then
                        if (dist <= radius) then
                            contextUi_hospital = Game.InteractContext:AddButton("object_menu", "S'allonger sur le lit", nil, function(onSelected, Entity)
                                if (onSelected) then
                                    if (dist <= radius) then
                                        PlayLayDownAnimation(bedCoords)
                                        ESX.ShowNotification("Vous êtes allongé sur le lit")
                                        CreateThread(function()
                                            if (inBed) then
                                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vous relever")
                                            end
                                            while inBed do
                                                if IsControlJustReleased(0, 38) then
                                                    StopLayDownAnimation()
                                                end
                                                Wait(0)
                                            end
                                        end)
                                    end
                                end
                            end, function(Entity)
                                return Entity.ID == bed_near_entity and not Client.Player:IsInAnyVehicle()
                            end)
                        end
                    end
                    
                end, false, false)

                HospitalBed:RadiusEvents(radius, nil, function()
                    if (contextUi_hospital) then
                        Game.InteractContext:RemoveButton(contextUi_hospital)
                        contextUi_hospital = nil
                    end
                end)

            end

        end

    end)
    
end)
