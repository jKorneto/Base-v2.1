--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@author Razzway
---@version 3.0
local grrRazzway = false

---@type function _Client.open:createCharacteRMenuClothes
function _Client.open:createCharacteRMenuClothes()
    local createCharacteRMenuClothes = RageUIClothes.CreateMenu("", __["welcome"])
    createCharacteRMenuClothes.Closable = false

    RageUIClothes.Visible(createCharacteRMenuClothes, (not RageUIClothes.Visible(createCharacteRMenuClothes)))

    while createCharacteRMenuClothes do
        TriggerEvent('iZeyy:Hud:StateStatus', false)
        RageUIClothes.IsVisible(createCharacteRMenuClothes, function()
            Wait(0)
            RageUIClothes.Button("Crée votre carte d'identité", nil, {RightLabel = "→"}, not grrRazzway, {
                onSelected = function()
                    grrRazzway = true
                end
            })
            RageUIClothes.Line()
            RageUIClothes.Button("Rejoindre le Discord", nil, {RightLabel = "→"}, not grrRazzway, {
                onSelected = function()
                    SendNUIMessage({
                        action = 'openLink',
                        url = 'https://discord.gg/onelife'
                    })
                end
            })
            RageUIClothes.Button("Lire le Règlements", nil, {RightLabel = "→"}, not grrRazzway, {
                onSelected = function()
                    SendNUIMessage({
                        action = 'openLink',
                        url = 'https://discord.gg/onelife'
                    })
                end
            })

            if grrRazzway then
                DoScreenFadeOut(2000)
                while not IsScreenFadedOut() do Wait(1) end
                Wait(1200)
                UtilsCreator:KillCam()
                SetEntityCoords(PlayerPedId(), CreatorConfig.firstSpawn.pos, false, false, false, false)
                SetEntityHeading(PlayerPedId(), CreatorConfig.firstSpawn.heading)
                UtilsCreator:SetPlayerBuckets(true)
                UtilsCreator:PlayAnimeCreator()
                UtilsCreator:CreatePlayerCam()
                SetEntityInvincible(PlayerPedId(), false)
                FreezeEntityPosition(PlayerPedId(), false)
                DoScreenFadeIn(750)
                _Client.open:identityMenu()
            end
        end)

        if not RageUIClothes.Visible(createCharacteRMenuClothes) then
            createCharacteRMenuClothes = RMenuClothes:DeleteType('createCharacteRMenuClothes', true)
        end
    end
end

local function openCreatorMenu()
    SetEntityCoords(PlayerPedId(), CreatorConfig.firstSpawn.pos, false, false, false, false)
    SetEntityHeading(PlayerPedId(), CreatorConfig.firstSpawn.heading)
    UtilsCreator:SetPlayerBuckets(true)
    UtilsCreator:PlayAnimeCreator()
    UtilsCreator:CreatePlayerCam()
    SetEntityInvincible(PlayerPedId(), false)
    FreezeEntityPosition(PlayerPedId(), false)
    DoScreenFadeIn(750)
    _Client.open:identityMenu()
end

exports('openCreatorMenu', function()
    return openCreatorMenu()
end)