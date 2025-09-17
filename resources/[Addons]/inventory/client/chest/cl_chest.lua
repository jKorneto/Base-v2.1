local Chest = {}

RegisterNetEvent("inventory:allChest:receive", function(data)
    CONFIG.CHEST_INVENTORIES = data
end)

RegisterNetEvent("inventory:chest:receive", function(name, data)
    CONFIG.CHEST_INVENTORIES[name] = data
end)

function Chest:openNearSafes()
    local localPlayer = PlayerPedId()
    local playerCoords = GetEntityCoords(localPlayer)

    local closeToAny = false
    for k, v in pairs(CONFIG.CHEST_INVENTORIES) do
        local safeCoords = vector3(v.x, v.y, v.z)

        local dist = #(playerCoords - safeCoords)
        if dist < CONFIG.CHEST_OPEN_RANGE then
            closeToAny = true
            break
        end
    end

    if closeToAny then
        TriggerServerEvent("inventory:OPEN_NEAR_CHEST_SAFES")
    end
end

AddEventHandler("inventory:onInventoryOpen", function()
    Chest:openNearSafes()
end)