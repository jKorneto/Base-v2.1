RegisterNetEvent('OneLife:Zones:AddZones')
AddEventHandler('OneLife:Zones:AddZones', function(zones)
    for _, zone in pairs(zones) do
        MOD_Zones:add(zone)
    end
end)