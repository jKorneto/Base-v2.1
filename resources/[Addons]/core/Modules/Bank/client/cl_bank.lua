local main_menu = RageUI.AddMenu("", "Faits vos actions")
local bank_menu = RageUI.AddMenu("", "Faits vos actions")
local bank_sub_menu = RageUI.AddSubMenu(bank_menu, "", "Faits vos actions")

local Bank = {
    validCni = false,
    validContract = false,
    --
    cash = 0,
    bank = 0,
    accountLevel = 0,
    hasCard = false,
    placeHolder = 0
}

local function CheckAccLevel(accountLevel)
    if (accountLevel == 1) then
        Bank.placeHolder = 100000
    elseif (accountLevel == 2) then
        Bank.placeHolder = 200000
    elseif (accountLevel == 3) then
        Bank.placeHolder = 500000
    end
end

CreateThread(function()

    for k, v in pairs(Config["Bank"]["Pos"]) do
        Game.Blip("Bank#"..k,
        {
            coords = v.pos,
            label = v.label,
            sprite = 500,
            color = 2,
            scale = 0.4,
        })
    end

    Game.Blip("BankAcc",
    {
        coords = Config["Bank"]["AccPos"],
        label = "Pacific Banque",
        sprite = 374,
        color = 2,
        scale = 0.4,
    })

    local AccountZone = Game.Zone("AccountZone")

    AccountZone:Start(function()
        AccountZone:SetTimer(1000)
        AccountZone:SetCoords(Config["Bank"]["AccPos"])

        AccountZone:IsPlayerInRadius(10.0, function()
            AccountZone:SetTimer(0)
            AccountZone:Marker()

            AccountZone:IsPlayerInRadius(3.0, function()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                AccountZone:KeyPressed("E", function()
                    main_menu:Toggle()
                end)
            end, false, false)

        end, false, false)

        AccountZone:RadiusEvents(3.0, nil, function()
            main_menu:Close()
        end)
    end)

    main_menu:IsVisible(function(Items)
        Items:Button("Papier d'identité", nil, { RightLabel = "", RightBadge = Bank.validCni and RageUI.BadgeStyle.Tick or nil }, true, {
            onSelected = function()
                Bank.validCni = true
            end
        })
        Items:Button("Signé le contrat", nil, { RightLabel = "", RightBadge = Bank.validContract and RageUI.BadgeStyle.Tick or nil }, true, {
            onSelected = function()
                Bank.validContract = true
            end
        })
        Items:Line()
        if (Bank.validCni and Bank.validContract == true) then
            Items:Button("Crée votre Compte", nil, {}, true, {
                onSelected = function()
                    TriggerServerEvent("Core:Bank:CreateAcc")
                    main_menu:Close()
                end
            })
        else
            Items:Button("Crée votre Compte", "Validé toute les condition de création afin de recevoir votre Carte", {}, false, {})
        end

    end, nil, function()
        Bank.validCni = false
        Bank.validContract = false
    end)

    for k, v in ipairs(Config["Bank"]["Pos"]) do
        local BankZone = Game.Zone("BankZone")

        BankZone:Start(function()
            BankZone:SetTimer(1000)
            BankZone:SetCoords(v.pos)
    
            BankZone:IsPlayerInRadius(10.0, function()
                BankZone:SetTimer(0)
                BankZone:Marker()

                BankZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    BankZone:KeyPressed("E", function()
                        if (not exports.core:IsServerInBlackout()) then
                            TriggerServerEvent("Core:Bank:CheckAcc")
                        else
                            ESX.ShowNotification("Nous sommes actuellement fermé en raison de la situation actuelle desolé")
                        end
                    end)
                end, false, false)

            end, false, false)

            BankZone:RadiusEvents(3.0, nil, function()
                bank_menu:Close()
            end)
        end)

    end

    bank_menu:IsVisible(function(Items)
        Items:Button("Deposer de l'argent", nil, {}, true, {
            onSelected = function()
                local success, input = pcall(function()
                    return lib.inputDialog("Deposer", {
                        {type = "number", label = "Indiquez un montant", placeholder = Bank.placeHolder},
                    })
                end)
        
                if not success then
                    return
                elseif input == nil then
                    ESX.ShowNotification("Montant invalide")
                else
                    local amount = input[1]
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("Montant invalide")
                    else
                        if (Bank.cash >= amount) then
                            TriggerServerEvent("Core:Bank:AddAccMoney", amount)
                            bank_menu:Close()
                            
                        else
                            ESX.ShowNotification("Vous n'avez pas assez d'argent")
                        end
                    end
                end
            end
        })
        Items:Button("Retirer de l'argent", nil, {}, true, {
            onSelected = function()
                local success, input = pcall(function()
                    return lib.inputDialog("Retirer", {
                        {type = "number", label = "Indiquez un montant", placeholder = Bank.placeHolder},
                    })
                end)
        
                if not success then
                    return
                elseif input == nil then
                    return
                else
                    local amount = input[1]
                    if tonumber(amount) == nil then
                        return
                    else
                        if (Bank.bank >= amount) then
                            TriggerServerEvent("Core:Bank:RemoveAccMoney", amount)
                            bank_menu:Close()
                        else
                            ESX.ShowNotification("Vous n'avez pas assez d'argent")
                        end
                    end
                end
            end
        })
        Items:Button("Virement Bancaire", "Pour chaque Virement la FleecaBank prendra 1.5% de la sommes envoyé.", {}, true, {
            onSelected = function()
                local success, inputs = pcall(function()
                    return lib.inputDialog("Virement Bancaire", {
                        {type = "number", label = "ID (Temp) du destinataire", placeholder = "1"},
                        {type = "number", label = "Combien voulez vous envoyé ?", placeholder = "10000"}
                    })
                end)
        
                if not success then
                    return
                elseif inputs == nil then
                    return
                end
        
                local id = tonumber(inputs[1])
                local money = tonumber(inputs[2])
        
                if not id or id < 0 then
                    ESX.ShowNotification("ID incorrect")
                    return
                end
        
                if not money or money < 1 then
                    ESX.ShowNotification("Montant incorrect")
                    return
                end

                TriggerServerEvent("Core:Bank:Transfer", id, money)
            end
        })
        Items:Button("Niveau de Comptes", nil, {}, true, {}, bank_sub_menu)
        if (Bank.hasCard == true) then
            local CardDesc = "~r~Vous avez perdu ou vous vous êtes fait voler votre carte? Rachetez-en une ici afin d'accéder à nos ATM présents dans tout Los Santos"
            Items:Button("Re commander une Carte de Credit", CardDesc, { RightLabel = "500~g~$"}, true,  {
                onSelected = function()
                    TriggerServerEvent("Core:Bank:BuyCard")
                    bank_menu:Close()
                end
            })
        elseif (Bank.hasCard == false) then
            Items:Button("Re commander une Carte de Credit", nil, {}, false,  {})
        end
    end, function(Panels)
        Panels:info("FleecaBank", {
            "Argent Liquide : ~s~" .. ESX.Math.GroupDigits(Bank.cash) .. "~g~$~c~",
            "Argent en Banque : ~s~" .. ESX.Math.GroupDigits(Bank.bank) .. "~g~$~c~",
            "Niveau de Compte : ~s~" .. ESX.Math.GroupDigits(Bank.accountLevel),
        })
    end)

    bank_sub_menu:IsVisible(function(Items)
        for k, v in pairs(Config["Bank"]["AccType"]) do
            Items:Button(v.label, v.description, {}, true, {
                onSelected = function()
                    if (v.level == 3) then
                        local PlayerIsVip = exports["engine"]:isPlayerVip()
                        if not PlayerIsVip then
                            return ESX.ShowNotification("Vous devez etre VIP pour acheter cette offre")
                        end
                    end
                    TriggerServerEvent("Core:Bank:ChangeAccLevel", v.label, v.description, v.subprice, v.level)
                    bank_menu:Close()
                end
            })
        end
    end)

end)

local atmObjects = {
    [506770882] = true,
    [-870868698] = true,
    [-1364697528] = true,
    [-1126237515] = true
}

local function GetNearestATM()
    local player_coords = Client.Player:GetCoords()
    local atm_models = atmObjects
    
    for atm_model in pairs(atm_models) do
        if (atm_model ~= nil) then
            local atm_entity = GetClosestObjectOfType(player_coords.x, player_coords.y, player_coords.z, 3.5, atm_model, true, true, true)
    
            if (atm_entity ~= 0) then
                return atm_entity
            end
        end
    end
    
    return false
end

CreateThread(function()

    local AtmZone = Game.Zone("AtmZone")
    local contextUi = nil
    local radius = 5.0

    AtmZone:Start(function()
        AtmZone:SetTimer(1000)
        local atm_near_entity = GetNearestATM()

        if (atm_near_entity and DoesEntityExist(atm_near_entity)) then
            local atmCoords = GetEntityCoords(atm_near_entity)

            if (type(atmCoords) == "vector3") then
                AtmZone:SetCoords(atmCoords)
                AtmZone:IsPlayerInRadius(radius, function()
                    AtmZone:SetTimer(0)
                    local dist = #(Client.Player:GetCoords() - atmCoords)

                    if (not contextUi) then
                        if (dist <= radius) then
                            contextUi = Game.InteractContext:AddButton("object_menu", "Accéder a vos comptes", nil, function(onSelected, Entity)
                                if (onSelected) then
                                    if (dist <= radius) then
                                        TriggerServerEvent("Core:Bank:CheckCard")
                                    end
                                end
                            end, function(Entity)
                                return Entity.ID == atm_near_entity and not Client.Player:IsInAnyVehicle()
                            end)
                        end
                    end
                    
                end, false, false)

                AtmZone:RadiusEvents(radius, nil, function()
                    if (contextUi) then
                        Game.InteractContext:RemoveButton(contextUi)
                        contextUi = nil
                    end
                end)

            end

        end

    end)
    
end)

RegisterNetEvent("Core:Bank:HasAcc", function(cash, bank, level, hasCard)
    Bank.cash = cash
    Bank.bank = bank
    Bank.accountLevel = level
    Bank.hasCard = hasCard
    CheckAccLevel(level)
    bank_menu:Toggle()
end)