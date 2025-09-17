function _OneLifeVehicule:Request(handle, callback)
    CreateThread(function()
        while not DoesEntityExist(handle) do Wait(200); end

        self.handle = handle;

        while not NetworkGetNetworkIdFromEntity(handle) do Wait(200); end

        self.networkId = NetworkGetNetworkIdFromEntity(handle);

        if (self.plate ~= nil) then
            SetVehicleNumberPlateText(handle, self.plate);
        else
            self.plate = GetVehicleNumberPlateText(handle);
        end
        if (callback) then callback(handle); end
    end)
end

function _OneLifeVehicule:Spawn(callback)
    local vehicle = CreateVehicle(self.model, self.position.x or 0, self.position.y or 0, self.position.z or 0, self.heading or 0, true, true);
    self:Request(vehicle, callback)
end