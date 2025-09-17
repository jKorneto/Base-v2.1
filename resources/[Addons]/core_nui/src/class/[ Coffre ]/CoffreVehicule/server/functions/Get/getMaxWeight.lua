function _OneLifeCoffreVehicule:getMaxWeight()
    local vehicleModel = self:getModel()
    if (vehicleModel) then
        return Configcore_nui.VehiculeMaxWeight[vehicleModel] or 150.0
    end
end