---setVehiclePower
---@param vehicleId number
---@param speed number
---@public
function API_Vehicles:setVehiclePower(vehicleId, speed)
    if (not (DoesEntityExist(vehicleId))) then
        return print("Target vehicle doesn't exist")
    end

    return SetVehicleEnginePowerMultiplier(vehicleId, speed)
end
