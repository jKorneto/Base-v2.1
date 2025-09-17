---delete
---@param vehicleId number
---@public
function API_Vehicles:delete(vehicleId)
    if (not (DoesEntityExist(vehicleId))) then
        return print("Target vehicle doesn't exist")
    end

    SetEntityAsMissionEntity(vehicleId, 0, 1)
    DeleteVehicle(vehicleId)
end
