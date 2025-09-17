---getClosest
---@param coords table<number, number, number>
---@return number, number
---@public
function API_Vehicles:getClosest(coords)
    local vehicles  = API_Vehicles.getVehicles()
    local closestDistance = -1
    local closestVehicle = -1

    if (not coords) then
        local playerPed  = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end

    for i = 1, #vehicles, 1 do
        local vehicleCoords  = GetEntityCoords(vehicles[i])
        ---@type number
        local distance  = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

        if (closestDistance == -1 or closestDistance > distance) then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end

    return (closestVehicle), (closestDistance)
end