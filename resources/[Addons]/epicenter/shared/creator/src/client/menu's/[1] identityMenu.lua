--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@author Razzway
---@version 3.0
---@type function _Client.open:identityMenu
function _Client.open:identityMenu()
    local identityMenu = RageUIClothes.CreateMenu("", __["put_your_info"])
    identityMenu.Closable = false;

    RageUIClothes.Visible(identityMenu, (not RageUIClothes.Visible(identityMenu)))
    FreezeEntityPosition(PlayerPedId(), true)

    while identityMenu do
        Wait(0)

        RageUIClothes.IsVisible(identityMenu, function()
            RageUIClothes.Button((__["firstname"]), nil, {RightLabel = playerIdentity.firstname}, true, {
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Veuillez indiquer votre prénom", {
                            {type = "input", label = "Entrez votre prénom", placeholder = "iZeyy"}
                        })
                    end)
                
                    if not success then
                        return
                    elseif input == nil or input[1] == "" or input[1] == __["undefinited"] or tonumber(input[1]) then
                        ESX.ShowNotification("Il semblerait que vous n'ayez pas entré de prénom valide.")
                    else
                        local firstname = input[1]
                        if #firstname < 3 or tonumber(firstname) then
                            ESX.ShowNotification("Le prénom doit contenir au moins 3 lettres et ne pas être un nombre.")
                        else
                            firstname = firstname:sub(1, 1):upper() .. firstname:sub(2):lower()
                            playerIdentity.firstname = firstname
                        end
            
                    end
                end
                
            })
            if playerIdentity.firstname ~= __["undefinited"] then
                RageUIClothes.Button((__["name"]), nil, {RightLabel = playerIdentity.name}, true, {
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Veuillez indiquer votre nom", {
                                {type = "input", label = "Entrez votre nom", placeholder = "Tanglo"}
                            })
                        end)
                    
                        if not success then
                            return
                        elseif input == nil or input[1] == "" or input[1] == __["undefinited"] or tonumber(input[1]) then
                            ESX.ShowNotification("Il semblerait que vous n'ayez pas entré de nom valide.")
                        else
                            local name = input[1]
                            if #name < 3 or tonumber(name) then
                                ESX.ShowNotification("Le prénom doit contenir au moins 3 lettres et ne pas être un nombre.")
                            else
                                name = name:sub(1, 1):upper() .. name:sub(2):lower()
                                playerIdentity.name = name
                            end
                
                        end
                    end                    
                })
            else
                RageUIClothes.Button((__["name"]), nil, {RightLabel = playerIdentity.name}, false, {})
            end
            if playerIdentity.firstname ~= __["undefinited"] and playerIdentity.name ~= __["undefinited"] then
                RageUIClothes.Button((__["height"]), nil, {RightLabel = playerIdentity.height}, true, {
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Veuillez indiquer votre taille", {
                                {type = "number", label = "Entrez votre taille en cm", placeholder = "180"}
                            })
                        end)
                    
                        if not success then
                            return
                        elseif input == nil or input[1] == nil or tonumber(input[1]) == nil then
                            ESX.ShowNotification("Il semblerait que vous n'ayez pas entré de taille valide. Assurez-vous qu'il s'agisse bien d'un nombre.")
                        else
                            local height = tonumber(input[1])
                            if height < 140 or height > 200 then
                                ESX.ShowNotification("La taille doit être comprise entre 140 cm et 200 cm.")
                            else
                                playerIdentity.height = height
                            end
                        end
                    end
                })                
            else
                RageUIClothes.Button((__["height"]), nil, {RightLabel = playerIdentity.height}, false, {})
            end
            
            if playerIdentity.firstname ~= __["undefinited"] and playerIdentity.name ~= __["undefinited"] and playerIdentity.height ~= __["undefinited"] then
                RageUIClothes.Button((__["date_of_birth"]), nil, {RightLabel = playerIdentity.birthday}, true, {
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Veuillez indiquer votre date de naissance", {
                                {type = "input", label = "Entrez votre date de naissance", placeholder = "jj/mm/aaaa"}
                            })
                        end)
                    
                        if not success then
                            return
                        elseif input == nil or input[1] == nil or not input[1]:match("^%d%d/%d%d/%d%d%d%d$") then
                            ESX.ShowNotification("Il semblerait que vous n'ayez pas entré de date de naissance valide. Assurez-vous d'utiliser le format jj/mm/aaaa.")
                        else
                            local birthday = input[1]
                            local day, month, year = birthday:match("^(%d%d)/(%d%d)/(%d%d%d%d)$")
                            year = tonumber(year)
                
                            if year == nil or year < 1940 or year > 2010 then
                                ESX.ShowNotification("L'année de naissance doit être comprise entre 1940 et 2010.")
                            else
                                playerIdentity.birthday = birthday
                            end
                        end
                    end                    
                })                
            else
                RageUIClothes.Button((__["date_of_birth"]), nil, {RightLabel = playerIdentity.birthday}, false, {})
            end
            if playerIdentity.firstname ~= __["undefinited"] and playerIdentity.name ~= __["undefinited"] and playerIdentity.height ~= __["undefinited"] and playerIdentity.birthday ~= __["undefinited"] then
                RageUIClothes.Button((__["sex"]), nil, {RightLabel = playerIdentity.sex}, true, {
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Veuillez indiquer votre sexe", {
                                {type = "input", label = "Entrez votre sexe", placeholder = "M ou F"}
                            })
                        end)
                    
                        if not success then
                            return
                        elseif input == nil or (input[1] ~= "M" and input[1] ~= "F") then
                            ESX.ShowNotification("Il semblerait que vous n'ayez pas entré de sexe valide. Assurez-vous que ce soit bien 'M' ou 'F'.")
                            playerIdentity.sex = __["undefinited"]
                        else
                            local sex = input[1]
                            playerIdentity.sex = sex
                        end
                    end
                    
                })
            else
                RageUIClothes.Button((__["sex"]), nil, {RightLabel = playerIdentity.sex}, false, {})
            end           
            RageUIClothes.Line()
            if playerIdentity.firstname ~= __["undefinited"] and playerIdentity.name ~= __["undefinited"] and playerIdentity.height ~= __["undefinited"] and playerIdentity.birthday ~= __["undefinited"] and playerIdentity.sex ~= __["undefinited"] then
                RageUIClothes.Button(__["valid_&_continue"], __["advert_continue"], {RightBadge = RageUIClothes.BadgeStyle.Tick, Color = { HightLightColor = {39, 227, 45, 160}, BackgroundColor = {39, 227, 45, 160} }}, true, {
                    onSelected = function()
                        TriggerEvent(_Prefix..':saveSkin')
                        TriggerServerEvent(_Prefix..':identity:setIdentity', playerIdentity)
                        -- UtilsCreator:goCloak()
                        RageUIClothes.CloseAll()
                        TriggerEvent('creator:openCreator')
                        UtilsCreator:endIdentity()
                    end
                })
            else
                RageUIClothes.Button(__["valid_&_continue"], __["not_filled"], {RightBadge = RageUIClothes.BadgeStyle.Tick, Color = { HightLightColor = {209, 31, 46, 160}, BackgroundColor = {209, 31, 46, 160} }}, false, {})
            end
        end)

        if not RageUIClothes.Visible(identityMenu) then
            identityMenu = RMenuClothes:DeleteType("identityMenu", true)
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end
end