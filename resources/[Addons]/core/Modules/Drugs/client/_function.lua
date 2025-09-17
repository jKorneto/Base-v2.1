Drugs = {}

-- function Drugs:CalculateDistance(pos1, pos2)

--     local dx = pos2.x - pos1.x
--     local dy = pos2.y - pos1.y
--     local dz = pos2.z - pos1.z
--     return math.sqrt(dx * dx + dy * dy + dz * dz)

-- end

function Drugs:StartHarvestAnim(label)
    local PlayerPed = Client.Player.GetPed()

    if not IsPedInAnyVehicle(PlayerPed, false) then
        local AnimDict, AnimName = "amb@medic@standing@kneel@idle_a", "idle_a"
        Game.Streaming:RequestAnimDict(AnimDict, function()
            TaskPlayAnim(PlayerPed, AnimDict, AnimName, 8.0, -8.0, -1, 0, 0, false, false, false)
            HUDProgressBar("Recolte de " .. label .. " en cours...", 2, function()
                ClearPedTasks(PlayerPed)
                Shared.Events:ToServer(Enums.Drugs.Harvest, label)
            end)
        end)
    else
        ESX.ShowNotification("Vous ne pouvez pas récolter en voiture")
    end
end

function Drugs:StartProcesstAnim(label)
    local PlayerPed = Client.Player.GetPed()
    local AnimDict, AnimName = "amb@medic@standing@kneel@idle_a", "idle_a"
    if not IsPedInAnyVehicle(PlayerPed, false) then
        Game.Streaming:RequestAnimDict(AnimDict, function()
            TaskPlayAnim(PlayerPed, AnimDict, AnimName, 8.0, -8.0, -1, 0, 0, false, false, false)
            HUDProgressBar("Traitement de " .. label .. " en cours...", 2, function()
                ClearPedTasks(PlayerPed)
                Shared.Events:ToServer(Enums.Drugs.Process, label)
            end)
        end)
    else
        ESX.ShowNotification("Vous ne pouvez pas traiter en voiture")
    end
end

-- function Drugs:Ressel(pos)
--     local closetDrugs = nil
--     local closestDistance = math.huge

--     for k, v in ipairs(Config["Drugs"]["Resell"]) do
--         local drugsPos = v.pedPos
--         local distance = Drugs:CalculateDistance(pos, drugsPos)

--         if (distance < closestDistance and distance <= 12.5) then
--             closestDistance = distance
--             closetDrugs = v.drugs
--         end
--     end

--     if closetDrugs then
--         Shared.Events:ToServer(Enums.Drugs.Sell, closetDrugs)
--     end

--     return closetDrugs
-- end
