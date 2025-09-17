function _OneLifeZones:addZoneToClient(source)
    TriggerClientEvent('OneLife:Zones:AddZone', source, self:minify())
end