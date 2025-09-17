local Shops = {}

function Shops:openNearShops()
    local localPlayer = PlayerPedId()
    local playerCoords = GetEntityCoords(localPlayer)

    local closeToAny = false

    for k, v in pairs(ScriptShared.Shops) do
        for i = 1, #v.locations, 1 do
            local shopCoords = v.locations[i]

            local dist       = #(playerCoords - shopCoords)
            if dist < CONFIG.SHOP_OPEN_RANGE then
                closeToAny = true
                break
            end
        end
    end

    if closeToAny then
        TriggerServerEvent("inventory:OPEN_NEAR_SHOPS")
    end
end

AddEventHandler("inventory:onInventoryOpen", function()
    Shops:openNearShops()
end)

AddEventHandler("inventory:onInventoryClose", function()

end)
