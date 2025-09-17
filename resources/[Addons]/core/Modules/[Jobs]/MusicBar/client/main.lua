local MainMenu = RageUI.AddMenu("", "Faites vos actions")

MainMenu:SetSpriteBanner("commonmenu", "interaction_legal")
MainMenu:SetButtonColor(0, 137, 201, 255)

local BarStatus = {
    List = {
        "~s~Ouvert",
        "~s~Fermer",
        "~s~Recrutement"
    },
    Index = 1
}

CreateThread(function()
    
    MainMenu:IsVisible(function(Items)
        Items:Button("Faire une annonces", "~r~Cette action est reservé au Patron d'entreprise~s~", {}, true, {
            onSelected = function()             
                local success, inputs = pcall(function()
                    return lib.inputDialog("Annonce(s) Bar", {
                        {type = "input", label = "Tapez votre Annonce", placeholer = "Ici"},
                    })
                end)
        
                if not success then
                    return
                elseif inputs == nil then
                    return
                end
        
                local announcements = inputs[1]

                if not announcements or #announcements < 10 then
                    return ESX.ShowNotification("Votre annonces doit contenir minimum 10 caractères")
                end

                TriggerServerEvent("izeyy:bar:sendAnnouncementperso", announcements)
            end
        })
        Items:List("Status entreprise", BarStatus.List, BarStatus.Index, nil, {}, true, {
            onListChange = function(index)
                BarStatus.Index = index
            end,
            onSelected = function(index)
                TriggerServerEvent("iZeyy:Bar:sendAnnouncement", BarStatus.Index)
            end
        })
        Items:Button("Faire une facture", nil, {}, true, {
            onSelected = function()
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance < 5.0 then
                    local success, input = pcall(function()
                        return lib.inputDialog("Montant", {
                            {type = "number", label = "Entrez votre prix"},
                        })
                    end)

                    if not success then
                        return
                    elseif input == nil then
                        ESX.ShowNotification("Entrez un texte Valide")
                    else
                        local price = input[1]
                        local job = Client.Player:GetJob().name
                        local label = Client.Player:GetJob().label

                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), job, label, price)
                    end
                else
                    ESX.ShowNotification("Aucun joueurs a coté de vous.")
                end
            end
        })

        local ped = PlayerPedId()
        local player, distance = ESX.Game.GetClosestPlayer()
        local coords = GetEntityCoords(ped)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local getPlayerSearch = GetPlayerPed(player)
        local isHandsUP = IsEntityPlayingAnim(getPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3)
    
        Items:Button("Fouiller le joueur", nil, {}, true, {
            onSelected = function()
                if player ~= -1 and distance <= 5.0 then
                    if isHandsUP then
                        ExecuteCommand("me fouille l'individue")
                        TriggerServerEvent("iZeyy:Bar:frisk", GetPlayerServerId(player))
                        RageUI.CloseAll()
    
                        CreateThread(function()
                            local Bool = true

                            while Bool do
                                local getPlayerSearch = GetPlayerPed(player)
                                local coords = GetEntityCoords(GetPlayerPed(-1))
                                local dist = #(GetEntityCoords(getPlayerSearch) - coords)

                                if (dist > 3) then
                                    Bool = false
                                    TriggerServerEvent("iZeyy:Bar:close:frisk", GetPlayerServerId(player))
                                end
                                if not IsEntityPlayingAnim(getPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3) then
                                    Bool = false
                                    TriggerServerEvent("iZeyy:Bar:close:frisk", GetPlayerServerId(player))
                                end

                                Wait(1000)
                            end
                        end)
                    else
                        ESX.ShowNotification("La personne en face ne lève pas les mains")
                    end
                else
                    ESX.ShowNotification("Personne autour de vous")
                end
            end
        })
        
    end)
end)

-- F6
Shared:RegisterKeyMapping("iZeyy:Bar:OpenMenu", { label = "open_menu_interactBar" }, "F6", function()
    local job = Client.Player:GetJob().name

    for k,v in pairs(Config["Bar"]["List"]) do

        if job == k then
            MainMenu:Toggle()
        end
    end
end)