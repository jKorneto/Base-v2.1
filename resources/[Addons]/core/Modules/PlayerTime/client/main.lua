local PlayerTime = 0
local beafor = 0
local timerRunning = false

function ConvertirTemps(milliseconds)
    local temps = {}

    local secondes = math.floor(milliseconds / 1000)
    local minutes = math.floor(secondes / 60)
    local heures = math.floor(minutes / 60)

    temps.heures = heures
    temps.minutes = minutes % 60
    temps.secondes = secondes % 60

    return temps
end 

RegisterNetEvent("iZeyy:PlayerTime:StartTimer", function(PlayedTime)
    PlayerTime = PlayedTime
    beafor = PlayedTime

    if not timerRunning then
        StartTimer()
    end
end)

function StartTimer()
    timerRunning = true
    Citizen.CreateThread(function()
        while timerRunning do
            PlayerTime = PlayerTime + 1000
            if PlayerTime - beafor >= 60000 then
                TriggerServerEvent("iZeyy:PlayerTime:UpdateTimer", PlayerTime)
                beafor = PlayerTime
            end
            Wait(1000)
        end
    end)
end

RegisterNetEvent("iZeyy:CheckTime")
AddEventHandler("iZeyy:CheckTime", function()
    local time = ConvertirTemps(PlayerTime)
    ESX.ShowNotification("Vous avez joué "..time.heures.." heures, "..time.minutes.." minutes et "..time.secondes.." secondes")
end)

RegisterCommand("time", function()
    local time = ConvertirTemps(PlayerTime)
    ESX.ShowNotification("Vous avez joué "..time.heures.." heures, "..time.minutes.." minutes et "..time.secondes.." secondes a OneLife")
end)
