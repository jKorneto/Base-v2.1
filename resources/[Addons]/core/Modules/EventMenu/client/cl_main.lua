local eventMenu = RageUI.AddMenu("", "Event Creator")

local carPos = nil
local radiusPos = nil
local carName = ""
local eventDuration = 0
local rewardAmount = 0

local carNameValidated = false
local carPosValidated = false
local radiusPosValidated = false
local eventDurationValidated = false
local rewardAmountValidated = false
local eventLaunched = false

local validVehicleNames = {
    "Adder", 
    "Futo", 
    "Panto",
    "Faggio",
    "Bati",
    "Blista",
    "Buffalo",
    "Carbonizzare",
    "Comet",
    "Coquette",
    "Dominator",
}

local function isVehicleNameValid(name)
    for _, validName in ipairs(validVehicleNames) do
        if name:lower() == validName:lower() then
            return true
        end
    end
    return false
end

eventMenu:IsVisible(function(Items)

    Items:Button("Clear les préreglages", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            -- Réinitialiser les checks
            carNameValidated = false
            carPosValidated = false
            radiusPosValidated = false
            eventDurationValidated = false
            rewardAmountValidated = false
            eventLaunched = false
            -- Reset les variables
            carPos = nil
            radiusPos = nil
            carName = ""
            reward = 0
            ESX.ShowNotification("~r~Administration\n~s~Les préreglages ont été réinitialisés.")
        end
    })

    Items:Line()
    
    Items:Button("Nom du vehicule", nil, { RightLabel = carNameValidated and carName or "" }, true, {
        onSelected = function()
            local success, input = pcall(function()
                return lib.inputDialog("Nom du vehicule", {
                    {type = "input", label = "Entrez le nom du véhicule"},
                })
            end)

            if not success then
                return
            elseif input == nil or not isVehicleNameValid(input[1]) then
                ESX.ShowNotification("~r~Erreur\n~s~Nom du véhicule invalide. Veuillez réessayer.")
            else
                carName = input[1]
                ESX.ShowNotification("~r~Administration\n~s~Nom du vehicule sauvegardé: "..carName)
                carNameValidated = true
            end
        end
    })


    Items:Button("Position du vehicule", nil, { RightLabel = "", RightBadge = carPosValidated and RageUI.BadgeStyle.Tick or nil }, true, {
        onSelected = function()
            carPos = GetEntityCoords(PlayerPedId())
            if carPos ~= nil then
                ESX.ShowNotification("~r~Administration\n~s~Position du vehicule sauvegardé: (" .. carPos.x .. ", " .. carPos.y .. ", " .. carPos.z .. ")")
                carPosValidated = true
            end
        end
    })

    Items:Button("Blips de l'évènement", nil, { RightLabel = "", RightBadge = radiusPosValidated and RageUI.BadgeStyle.Tick or nil }, true, {
        onSelected = function()
            radiusPos = GetEntityCoords(PlayerPedId())
            if radiusPos ~= nil then
                ESX.ShowNotification("~r~Administration\n~s~Position du radius sauvegardé: (" .. radiusPos.x .. ", " .. radiusPos.y .. ", " .. radiusPos.z .. ")")
                radiusPosValidated = true
            end
        end
    })

    Items:Button("Durée de l'évènement", nil, { RightLabel = eventDurationValidated and eventDuration.." Minutes" or "" }, true, {
        onSelected = function()
            local success, input = pcall(function()
                return lib.inputDialog("Durée de l'évènement en minutes", {
                    {type = "number", label = "Entrez la durée en minutes"},
                })
            end)
            
            if not success then
                return
            elseif input == nil or tonumber(input[1]) == nil or tonumber(input[1]) <= 0 then
                ESX.ShowNotification("~r~Erreur\n~s~Durée de l'évènement invalide. Veuillez réessayer.")
            elseif tonumber(input[1]) > 30 then
                ESX.ShowNotification("~r~Erreur\n~s~La durée maximale de l'évènement est de 30 minutes.")
            else
                eventDuration = tonumber(input[1])
                ESX.ShowNotification("~r~Administration\n~s~Durée de l'évènement sauvegardée: "..eventDuration.." minutes")
                eventDurationValidated = true
            end
        end
    })

    Items:Button("Montant de la récompense", nil, { RightLabel = rewardAmountValidated and rewardAmount.." $" or "" }, true, {
        onSelected = function()
            local success, input = pcall(function()
                return lib.inputDialog("Montant de la récompense", {
                    {type = "number", label = "Entrez le montant en $"},
                })
            end)

            if not success then
                return
            elseif input == nil or tonumber(input[1]) == nil or tonumber(input[1]) <= 0 then
                ESX.ShowNotification("~r~Erreur\n~s~Montant de la récompense invalide. Veuillez réessayer.")
            elseif tonumber(input[1]) > 100000 then
                ESX.ShowNotification("~r~Erreur\n~s~Le montant de la récompense maximale est de 100 000 $.")
            else
                rewardAmount = tonumber(input[1])
                ESX.ShowNotification("~r~Administration\n~s~Montant de la récompense sauvegardé: "..rewardAmount.." $")
                rewardAmountValidated = true
            end
        end
    })

    Items:Line()

    if carNameValidated == true and carPosValidated == true and radiusPosValidated == true and eventDurationValidated == true and rewardAmountValidated == true then
        Items:Button("Lancer l'évènement", nil, { RightBadge = RageUI.BadgeStyle.Tick }, true, {
            onSelected = function()
                ESX.ShowNotification("~r~Administration\n~s~Les évevements ne sont pas disponibles pour le moment.");
                -- eventLaunched = true
                -- TriggerServerEvent("iZeyy_EventMenu:LaunchEvent", carName, carPos, radiusPos, eventDuration, rewardAmount)
                -- -- Réinitialiser les checks
                -- carNameValidated = false
                -- carPosValidated = false
                -- radiusPosValidated = false
                -- eventDurationValidated = false
                -- rewardAmountValidated = false
                -- -- Reset les variables
                -- carPos = nil
                -- radiusPos = nil
                -- carName = ""
                -- reward = 0
                eventMenu:Close()
            end
        })
    else
        Items:Button("Lancer l'évènement", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, {})
    end

end)

-- RegisterNetEvent("iZeyy_EventMenu:CreateEvent")
-- AddEventHandler("iZeyy_EventMenu:CreateEvent", function(radiusPos, eventDuration, carName, carPos, rewardAmount)

--     local blip = AddBlipForCoord(radiusPos.x, radiusPos.y, radiusPos.z)
--     SetBlipSprite(blip, 38)
--     SetBlipScale(blip, 0.6)
--     SetBlipColour(blip, 0)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString("Événement")
--     EndTextCommandSetBlipName(blip)
--     SetBlipAsShortRange(blip, true)
--     local zoneBlip = AddBlipForRadius(radiusPos.x, radiusPos.y, radiusPos.z, 3500.0)
--     SetBlipSprite(zoneBlip, 1)
--     SetBlipColour(zoneBlip, 1)
--     SetBlipAlpha(zoneBlip, 100)

--     local vehicleHash = GetHashKey(carName)
--     RequestModel(vehicleHash)
--     while not HasModelLoaded(vehicleHash) do
--         Wait(1)
--     end

--     rewardAmount = tonumber(rewardAmount)

--     ESX.Game.SpawnVehicle(vehicleHash, carPos, 0.0, function(vehicle)
--         if DoesEntityExist(vehicle) then

--             CreateThread(function()
--                 while true do
--                     Wait(1000)
--                     if GetPedInVehicleSeat(vehicle, -1) ~= 0 then
--                         ESX.Game.DeleteVehicle(vehicle)
--                         RemoveBlip(blip)
--                         RemoveBlip(zoneBlip)
--                         TriggerServerEvent("iZeyy_EventMenu:EndEvent", rewardAmount)
--                         return
--                     end
--                 end
--             end)
    
--             CreateThread(function()
--                 Wait(eventDuration * 60 * 1000)
--                 if DoesEntityExist(vehicle) then
--                     ESX.Game.DeleteVehicle(vehicle)
--                 end
--             end)
--         end
--     end)

--     CreateThread(function()
--         Wait(eventDuration * 60 * 1000)
--         RemoveBlip(blip)
--         RemoveBlip(zoneBlip)
--     end)

-- end)

RegisterNetEvent("iZeyy_EventMenu:OpenMenu")
AddEventHandler("iZeyy_EventMenu:OpenMenu", function()
    eventMenu:Open()
end)