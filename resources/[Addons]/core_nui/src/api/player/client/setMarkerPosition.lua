---setMarkerPosition
---@public
function API_Player:setMarkerPosition()
    local blipPos = GetFirstBlipInfoId(8)
    if (not DoesBlipExist(blipPos)) then
        return print("No blip present")
    else
        local blipCoords = GetBlipInfoIdCoord(blipPos)
        local foundGround, zCoords, zPos = false, -500.0, 0.0
        while (not foundGround) do
            zCoords = zCoords + 10.0
            RequestCollisionAtCoord(blipCoords.x, blipCoords.y, zCoords)
            Wait(0)
            foundGround, zPos = GetGroundZFor_3dCoord(blipCoords.x, blipCoords.y, zCoords)
            if (not foundGround) and (zCoords >= 2000.0) then
                foundGround = true
            end
        end
        SetPedCoordsKeepVehicle(PlayerPedId(), blipCoords.x, blipCoords.y, zPos)
    end
end
