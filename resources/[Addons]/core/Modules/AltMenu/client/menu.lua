local bill_menu = RageUI.AddMenu("", "Factures")
local pass_menu = RageUI.AddMenu("", Config["BattlePass"]["name"])

local InteractMenu = {
    billing = {}
}

local function RefreshBills()
    ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
        InteractMenu.billing = bills
    end)
end

local function getVipState()
    local PlayerIsVip = exports["engine"]:isPlayerVip()

    if not PlayerIsVip then
        return "Aucun"
    else
        return "~b~Avantage VIP"
    end
end


local function getCurrentXP()
    return exports["epicenter"]:getPlayerLevel()
end

bill_menu:IsVisible(function(Items)
	if not InteractMenu.billing then
		Items:Separator("Chargement des factures...")
    else
		if #InteractMenu.billing == 0 then
			Items:Separator("")
			Items:Separator("Vous n'avez aucune facture")
			Items:Separator("")
		end

		for i = 1, #InteractMenu.billing, 1 do
			Items:Button(""..InteractMenu.billing[i].label, nil, {RightLabel = ESX.Math.GroupDigits(InteractMenu.billing[i].amount.."~g~$")}, true, {
				onSelected = function()
					ESX.TriggerServerCallback('esx_billing:payBill', function()
					end, InteractMenu.billing[i].id)
					RageUI.GoBack()
				end
			})
		end
	end
end)

-- CreateThread(function()
--     pass_menu:IsVisible(function(Items)
--         local PlayerLevel = getCurrentXP()
        
--         Items:Separator("Votre Niveau :"..Shared:ServerColorCode().." "..PlayerLevel.."")
--         Items:Separator("Début : "..Shared:ServerColorCode()..""..Config["BattlePass"]["Date1"].."~w~ - Fin : "..Shared:ServerColorCode()..""..Config["BattlePass"]["Date2"].."")
--         Items:Line()
    
--         for k, v in pairs(Config["BattlePass"]["Gift"]) do
    
--             if tonumber(PlayerLevel) >= tonumber(v.level) then
    
--                 Items:Button(Config["ServerColorCode"].."Niveau "..v.level.."~w~ - "..v.label, nil, {}, true, {
--                     onSelected = function()
--                         TriggerServerEvent('izeyy:pass:gift', tonumber(v.level))
--                     end
--                 })
                
--             else
--                 Items:Button(Config["ServerColorCode"].."Niveau "..v.level.."~w~ - "..v.label, nil, {}, false, {})
--             end
    
--         end
--     end)
-- end)

local function loadInteractMenuPocket()
    CreateThread(function()
        while Client.Player == nil do
            Wait(100)
        end

        InteractMenuPocket = Game.InteractContext:AddButton("ped_menu", "Poches", nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractMenuSubPocket = Game.InteractContext:AddSubMenu(InteractMenuPocket, "Argent en Banque", nil, function(onSelected, Entity)
            if (onSelected) then
                local PlayerBankMoney = Client.Player:GetBank()
                Game.Notification:showNotification("Vous avez %s~g~$~s~ en banque", false, Shared.Math:GroupDigits(PlayerBankMoney))
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractMenuSubPocket = Game.InteractContext:AddSubMenu(InteractMenuPocket, "Facture(s)", nil, function(onSelected, Entity)
            if (onSelected) then
                RefreshBills()
                bill_menu:Toggle()
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        -- InteractMenuInfoMenu = Game.InteractContext:AddSubMenu(InteractMenuPocket, "Papier", nil, function(onSelected, Entity)
        --     if (onSelected) then end
        -- end, function(Entity)
        --     return Entity.ID == Client.Player:GetPed()
        -- end)
        InteractMenuGestion = Game.InteractContext:AddButton("ped_menu", "Gestion", nil, function(onSelected, Entity)
            if (onSelected) then
                -- TriggerServerEvent("iZeyy:Request:Job")
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractMenuInformation = Game.InteractContext:AddButton("ped_menu", "Informations", nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractMenuOther = Game.InteractContext:AddButton("ped_menu", "Autres", nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
    end)
end

local function loadInteractMenuInfoMenu()
    CreateThread(function()
        while Client.Player == nil do
            Wait(100)
        end
    
        InteractMenuInfoSub = Game.InteractContext:AddSubMenu(InteractMenuInfoMenu, "Voir votre d'identité", nil, function(onSelected, Entity)
            if (onSelected) then
                PlayIDCardAnimation()
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractMenuInfoSub = Game.InteractContext:AddSubMenu(InteractMenuInfoMenu, "Montrer votre carte d'identité", nil, function(onSelected, Entity)
            if (onSelected) then
                local closestPlayer, closestDistance = Game.Players:GetClosestPlayer()
                if (closestPlayer and closestDistance < 5) then
                    PlayIDCardAnimation()
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                else
                    Game.Notification:showNotification("Aucun joueur autour de vous")
                end
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
    end)
end

local function loadInteractMenuGestion()
    CreateThread(function()
        local InteractMenuSubGestion = nil
        while Client.Player == nil do
            Wait(100)
        end
        InteractMenuSubGestion = Game.InteractContext:AddSubMenu(InteractMenuGestion, "Emploie : " ..Client.Player:GetJob().label.. " - " .. ESX.GetPlayerData().job.grade_label, nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractMenuSubGestion = Game.InteractContext:AddSubMenu(InteractMenuGestion, "Faction : " ..Client.Player:GetJob2().label.. " - " .. ESX.GetPlayerData().job2.grade_label, nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
    end)
end

local function loadInteractMenuInformation()
    CreateThread(function()
        while Client.Player == nil do
            Wait(100)
        end
    
        InteractSubMenuInformation = Game.InteractContext:AddSubMenu(InteractMenuInformation, "ID Unique : " .. ESX.GetPlayerData().character_id, nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuInformation = Game.InteractContext:AddSubMenu(InteractMenuInformation, "ID Temp : " .. Client.Player:GetServerId(), nil, function(onSelected, Entity)
            if (onSelected) then end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuInformation = Game.InteractContext:AddSubMenu(InteractMenuInformation, "Status VIP : " .. getVipState(), nil, function(onSelected, Entity)
            if (onSelected) then
                ExecuteCommand("vip")
             end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuInformation = Game.InteractContext:AddSubMenu(InteractMenuInformation, "Vous etes Niveau : " .. getCurrentXP(), nil, function(onSelected, Entity)
            if (onSelected) then
                ExecuteCommand("-xpBar")
                -- pass_menu:Toggle()
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
    end)
end

local function loadInteractMenuOther()
    CreateThread(function()
        while Client.Player == nil do
            Wait(100)
        end
    
        -- InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Caméra Photo", nil, function(onSelected, Entity)
        --     if (onSelected) then
        --         InteractMenuFreeCam()
        --     end
        -- end, function(Entity)
        --     return Entity.ID == Client.Player:GetPed()
        -- end)
        InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Affiché/Caché l'Hud", nil, function(onSelected, Entity)
            if (onSelected) then
                InteractMenuShowHud()
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Affiché/Caché l'Hud (Status)", nil, function(onSelected, Entity)
            if (onSelected) then
                InteractStatusHud()
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Affiché/Caché l'Hud (Info)", nil, function(onSelected, Entity)
            if (onSelected) then
                InteractInfoHud()
             end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Caméra Cinéma", nil, function(onSelected, Entity)
            if (onSelected) then
                TriggerEvent("hud:cinema")
             end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Interface GPS", nil, function(onSelected, Entity)
            if (onSelected) then
                InteractMenuShowRadar()
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
        InteractSubMenuOther = Game.InteractContext:AddSubMenu(InteractMenuOther, "Casque de Moto", nil, function(onSelected, Entity)
            if (onSelected) then
                InteractMenuPlayerHelmet()
            end
        end, function(Entity)
            return Entity.ID == Client.Player:GetPed()
        end)
    end)
end

local function loadAllInteractMenu()
    loadInteractMenuPocket()
    --loadInteractMenuInfoMenu()
    loadInteractMenuGestion()
    loadInteractMenuInformation()
    loadInteractMenuOther()
end

AddEventHandler("fowlmas:onelife:player:receive_player_data", function()
    loadAllInteractMenu()
end)