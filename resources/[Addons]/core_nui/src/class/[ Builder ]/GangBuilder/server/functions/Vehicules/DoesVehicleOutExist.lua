function _OneLifeGangBuilder:DoesVehicleOutExist(plate)
    return self.vehiclesOut[plate] ~= nil and DoesEntityExist(self.vehiclesOut[plate])
end