function _OneLifeZones:removeZoneToClient(source)
    TriggerClientEvent('OneLife:Zones:RemoveZone', source, self.id)
end