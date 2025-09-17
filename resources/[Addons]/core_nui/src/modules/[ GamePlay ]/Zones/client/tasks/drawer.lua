local AlreadyRun = false

function MOD_Zones:loadDrawer()
    if (AlreadyRun) then return end

    AlreadyRun = true

    CreateThread(function()
        while (AlreadyRun) do
            local PlayerPos = GetEntityCoords(PlayerPedId())
            local Interval = 2500

            if (next(self.drawing) == nil) then
                goto Skip
            end

            Interval = 1000

            for id, zone in pairs(self.drawing) do
                local distance = #(PlayerPos - zone.coords)

                if (distance <= zone.drawDistance) then
                    Interval = 0
                    DrawMarker(23, zone.coords.x, zone.coords.y, (zone.coords.z - 0.97), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 200, false, true, 2, false, false, false, false)

                    if (distance <= zone.interactDistance) then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                    end
                end
            end

            :: Skip ::

            Wait(Interval)
        end
    end)
end