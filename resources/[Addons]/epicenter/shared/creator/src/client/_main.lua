--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@author Razzway
---@version 3.0


playerIdentity = {
    firstname = __["undefinited"],
    name = __["undefinited"],
    height = __["undefinited"],
    birthday = __["undefinited"],
    sex = __["undefinited"],
}

CreateThread(function()
    while ESX == nil do
        Wait(10)
    end
end)

local FirstSpawn, PlayerLoaded = true, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
end)

local function LoadCreator()
    CreateThread(function()
        RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
        while not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a") do
            Citizen.Wait(100)
        end
        TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetPedComponentVariation(PlayerPedId(), 2, 1, 4, 0) 
        SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2) 
        SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2) 
        SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 
        SetPedComponentVariation(PlayerPedId(), 4, 61, 0, 2)
        SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 2)
        UtilsCreator:spawnCinematic()
        _Client.open:createCharacteRMenuClothes()
    end);
end

AddEventHandler('playerSpawned', function()
    CreateThread(function()
        while not PlayerLoaded do
            Wait(10)
        end
        if FirstSpawn then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    -- LoadCreator();
                    --ESX.ShowAdvancedNotification("Événement", "~s~Purge", "Le serveur est en mode ~s~PURGE cela veut dire qu'aucune regle RP sera respectée !", nil, 8)
                else
                    TriggerEvent('skinchanger:loadSkin', skin)
                    --ESX.ShowAdvancedNotification("Événement", "~s~Purge", "Le serveur est en mode ~s~PURGE cela veut dire qu'aucune regle RP sera respectée !", nil, 8)
                end
            end)
            FirstSpawn = false
        end
    end)
end)

RegisterNetEvent("JustGod:RegisterPlayerIdentity", function()
    LoadCreator();
end);

RegisterNetEvent(_Prefix..':saveSkin')
AddEventHandler(_Prefix..':saveSkin', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)
