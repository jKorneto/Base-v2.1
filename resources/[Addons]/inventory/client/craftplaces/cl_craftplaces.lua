local function OpenNearCraftPlaces()
    local localPlayer = PlayerPedId()
    local playerCoords = GetEntityCoords(localPlayer)

    local closeToAny = false

    for k, v in pairs(ScriptShared.CraftPlaces) do
        for i = 1, #v.locations do
            local locationCoords = v.locations[i].coords
            local locationMaxRange = v.locations[i].range

            local dist = #(playerCoords - locationCoords)
            if dist < locationMaxRange then
                closeToAny = true
                break
            end
        end
    end

    if closeToAny then
        TriggerServerEvent("inventory:OPEN_NEAR_CRAFTPLACES")
    end
end

AddEventHandler("inventory:onInventoryOpen", function()
    OpenNearCraftPlaces()
end)
