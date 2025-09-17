local shotCount = 0
local WaitShoot = false
local timeout = false

AddEventHandler('CEventGunShot', function(entities, eventEntity, args)
    if (eventEntity ~= PlayerPedId()) then return end

    if (not WaitShoot and not timeout) then
        WaitShoot = true

        if (shotCount >= 5) then
            shotCount = 0
            timeout = true

            SetTimeout(30000, function()
                timeout = false
            end)

            Shared.Events:ToServer(Enums.Shooting.Send)
        end

        CreateThread(function()
            Wait(20)
            WaitShoot = false
        end)

        shotCount += 1
    end
end)

Shared.Events:OnNet(Enums.Shooting.Receive, function(coords)
    local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 161)
	SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 0)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('[~r~Alerte~s~] Zone de Tir')
	EndTextCommandSetBlipName(blip)
    
    local blip2 = AddBlipForCoord(coords)
	SetBlipSprite(blip2, 119)
	SetBlipScale(blip2, 0.5)
    SetBlipColour(blip2, 1)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('[~r~Alerte~s~] Tir !')
	EndTextCommandSetBlipName(blip2)
    
    SetTimeout(80000, function()
        RemoveBlip(blip)
        RemoveBlip(blip2)
    end)
end)