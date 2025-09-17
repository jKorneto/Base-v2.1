---lockVehicle
---@param vehicleId number
---@return void
---@public
function API_Vehicles:lock(vehicleId)
    if (not (DoesEntityExist(vehicleId))) then
        return print("Target vehicle doesn't exist")
    end

    return SetVehicleDoorsLocked(vehicleId, 2)
end