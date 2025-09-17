local cached_players = {}

RegisterNetEvent("utils:playerDisconnect")
AddEventHandler("utils:playerDisconnect", function(player, info)
    CreateThread(function()
        cached_players[player] = info
        Wait(20000)
        if cached_players[player] ~= nil then
            cached_players[player] = nil
        end
    end)
end)

CreateThread(function()
    while true do
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local pNear = false

        for k,v in pairs(cached_players) do
            if #(v.coords - pCoords) < 15 then
                pNear = true
                DrawText3DTop(v.coords.x, v.coords.y, v.coords.z+0.12, "~r~Une personne a quitté la ville")
                DrawText3DBottom(v.coords.x, v.coords.y, v.coords.z, "~s~Raison: "..v.res.. "\nJoueurs: "..v.date) 
            end
        end


        if pNear then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)

function DrawText3DTop(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - camCoords)

    local scale = 1 / dist * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(ServerFontStyle or 4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function DrawText3DBottom(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - camCoords)

    local scale = 1 / dist * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.30 * scale)
        SetTextFont(ServerFontStyle or 4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
