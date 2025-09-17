---repair
---@param vehicleId number
---@public
function API_Vehicles:repair(vehicleId)
    if (not (DoesEntityExist(vehicleId))) then
        return print("Target vehicle doesn't exist")
    end

    SetVehicleFixed(vehicleId)
    SetVehicleDirtLevel(vehicleId, 0.0)
    SetVehicleDeformationFixed(vehicleId)
 end
