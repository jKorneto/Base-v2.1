local Factions = {}

RegisterNetEvent("inventory:faction:receive", function(data)
    CONFIG.FACTION_INVENTORIES = data
end)

function Factions:openNearSafes()
    local localPlayer = PlayerPedId()
    local playerCoords = GetEntityCoords(localPlayer)

    local closeToAny = false
    for k, v in pairs(CONFIG.FACTION_INVENTORIES) do
        
        local safeCoords = vector3(v.x, v.y, v.z)

        local dist = #(playerCoords - safeCoords)
        if dist < CONFIG.FACTION_SAFE_OPEN_RANGE then
            closeToAny = true
            break
        end
    end

    if closeToAny then
        TriggerServerEvent("inventory:OPEN_NEAR_FACTION_SAFES")
    end
end

AddEventHandler("inventory:onInventoryOpen", function()
    Factions:openNearSafes()
end)