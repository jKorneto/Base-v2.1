-- menuOpened, menuCat, menus = false, "drugsbuilder", {}

-- local builder = {
--     -- Valeur de base
--     name = nil,
--     rawItem = nil,
--     treatedItem = nil,

--     -- Valeur numériques
--     harvestCount = nil,
--     treatmentCount = nil,
--     treatmentReward = nil,
--     sellCount = nil,
--     sellRewardPerCount = nil,
--     sale = nil,

--     -- Potisions
--     harvest = nil,
--     treatement = nil,
--     vendor = nil,
-- }

-- local function input(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    
-- 	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
-- 	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
-- 	blockinput = true

-- 	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
-- 		Citizen.Wait(0)
-- 	end
		
-- 	if UpdateOnscreenKeyboard() ~= 2 then
-- 		local result = GetOnscreenKeyboardResult() 
-- 		Citizen.Wait(1000) 
-- 		blockinput = false 
--         if isValueInt then 
--             local isNumber = tonumber(result)
--             if isNumber then return result else return nil end
--         end

-- 		return result
-- 	else
-- 		Citizen.Wait(1000)
-- 		blockinput = false 
-- 		return nil
-- 	end
-- end

-- local function canCreateDrug()
--     return name ~= nil and name ~= "" and harvestCount ~= nil and harvestCount >= 1 and treatmentCount ~= nil and treatmentCount >= 1 and treatmentReward ~= nil and treatmentReward >= 1 and sellCount ~= nil and sellCount >= 1 and sellRewardPerCount ~= nil and sellRewardPerCount >= 1 and sale ~= nil and harvest ~= nil and treatement ~= nil and vendor ~= nil
-- end

-- local function subCat(string)
--     return menuCat.."_"..string
-- end

-- local function addMenu(name)
--     RMenu.Add(menuCat, subCat(name), RageUIPolice.CreateMenu("DrugsBuilder","~s~Gestion des drogues"))
--     RMenu:Get(menuCat, subCat(name)).Closed = function()end
--     table.insert(menus, name)
-- end

-- local function addSubMenu(name, depend)
--     RMenu.Add(menuCat, subCat(name), RageUIPolice.CreateSubMenu(RMenu:Get(menuCat, subCat(depend)), "DrugsBuilder", "~s~Gestion des drogues"))
--     RMenu:Get(menuCat, subCat(name)).Closed = function()end
--     table.insert(menus, name)
-- end

-- local function valueNotDefault(value)
--     if not value or value == "" then return "" else return "~s~: ~s~"..tostring(value) end
-- end

-- local function okIfDef(value)
--     if not value or value == "" then return "" else return "~s~: ~s~Défini" end
-- end

-- local function delMenus()
--     for k,v in pairs(menus) do 
--         RMenu:Delete(menuCat, v)
--     end
-- end

-- function openMenu35(drugs) 
--     local colorVar = "~s~"
--     local actualColor = 1
--     local colors = {"~s~", "~s~","~s~","~s~","~s~","~s~","~s~"}

--     menuOpened = true
--     addMenu("main")
--     addSubMenu("builder", "main")
--     RageUIPolice.Visible(RMenu:Get(menuCat, subCat("main")), true)

--     Citizen.CreateThread(function()
--         while menuOpened do
--             Wait(800)
--             if colorVar == "~s~" then colorVar = "~s~" else colorVar = "~s~" end
--         end
--     end)

--     Citizen.CreateThread(function()
--         while menuOpened do 
--             Wait(500)
--             actualColor = actualColor + 1
--             if actualColor > #colors then actualColor = 1 end
--         end
--     end)

--     CreateThread(function()
--         while menuOpened do
--             local shouldClose = true
--             RageUIPolice.IsVisible(RMenu:Get(menuCat,subCat("main")),true,true,true,function()
--                 shouldClose = false
--                 RageUIPolice.Separator("↓ ~s~Gestion des drogues ~s~↓")
--                 local total = 0
--                 for _,_ in pairs(drugs) do
--                     total = total + 1
--                 end
--                 if total <= 0 then
--                     RageUIPolice.ButtonWithStyle(colorVar.."Aucune drogue active", nil, {}, true, function() end)
--                 else
--                     for drugID, drugsInfos in pairs(drugs) do
--                         RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~"..drugsInfos.name, nil, {RightLabel = "~s~Supprimer ~s~→→"}, true, function(_,_,s)
--                             if s then
--                                 shouldClose = true
--                                 TriggerServerEvent("exedrugs_deletedrug", drugID)
--                             end
--                         end)
--                     end
--                 end
--                 RageUIPolice.Separator("↓ ~s~Création d'une drogue ~s~↓")
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Créer une drogue", nil, {}, true, function(_,_,s)

--                 end, RMenu:Get(menuCat, subCat("builder")))
--             end, function()    
--             end, 1)

--             RageUIPolice.IsVisible(RMenu:Get(menuCat,subCat("builder")),true,true,true,function()
--                 shouldClose = false
--                 -- Informations de base
--                 RageUIPolice.Separator("↓ ~s~Informations de base ~s~↓")
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Nom de la drogue"..valueNotDefault(builder.name), "~s~Description: ~s~vous permets de définir le nom de votre drogue", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, false)
--                         if result ~= nil then builder.name = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Item non traité"..valueNotDefault(builder.rawItem), "~s~Description: ~s~vous permets de définir l'item non traité", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, false)
--                         if result ~= nil then builder.rawItem = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Item traité"..valueNotDefault(builder.treatedItem), "~s~Description: ~s~vous permets de définir l'item traité", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, false)
--                         if result ~= nil then builder.treatedItem = result end
--                     end
--                 end)
--                 -- Valeur numériques
--                 RageUIPolice.Separator("↓ ~s~Valeur numériques ~s~↓")
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense récolte"..valueNotDefault(builder.harvestCount), "~s~Description: ~s~vous permets de définir la récompense (x items) pour une récolte", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, true)
--                         if result ~= nil then builder.harvestCount = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Nécéssaire traitement"..valueNotDefault(builder.treatmentCount), "~s~Description: ~s~vous permets de définir combien de votre drogue sont nécéssaire pour la transformer", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, true)
--                         if result ~= nil then builder.treatmentCount = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense traitement"..valueNotDefault(builder.treatmentReward), "~s~Description: ~s~vous permets de définir la récompense (x items) pour un traitement", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, true)
--                         if result ~= nil then builder.treatmentReward = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Nécéssaire revente"..valueNotDefault(builder.sellCount), "~s~Description: ~s~vous permets de définir combien de votre drogue sont nécéssaire pour la vendre", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, true)
--                         if result ~= nil then builder.sellCount = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense revente"..valueNotDefault(builder.sellRewardPerCount), "~s~Description: ~s~vous permets de définir la récompense (x items) pour une revente", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 20, true)
--                         if result ~= nil then builder.sellRewardPerCount = result end
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense argent"..valueNotDefault(builder.sale), "~s~Description: ~s~vous permets de définir l'argent sale (1) ou propre(0)", {}, true, function(_,_,s)
--                     if s then
--                         local result = input("Drugs builder", "", 1, true)
--                         if result ~= nil then builder.sale = result end
--                     end
--                 end)
--                 -- Positions et points
--                 RageUIPolice.Separator("↓ ~s~Configuration des points ~s~↓")
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Position récolte"..okIfDef(builder.harvest), "~s~Description: ~s~vous permets de définir la position de la récolte", {RightLabel = "~s~Définir ~s~→→"}, true, function(_,_,s)
--                     if s then
--                         local pos = GetEntityCoords(PlayerPedId())
--                         builder.harvest = {x = pos.x, y = pos.y, z = pos.z}
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Position traitement"..okIfDef(builder.treatement), "~s~Description: ~s~vous permets de définir la position du traitement", {RightLabel = "~s~Définir ~s~→→"}, true, function(_,_,s)
--                     if s then
--                         local pos = GetEntityCoords(PlayerPedId())
--                         builder.treatement = {x = pos.x, y = pos.y, z = pos.z}
--                     end
--                 end)
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Position revente"..okIfDef(builder.vendor), "~s~Description: ~s~vous permets de définir la position de la revente", {RightLabel = "~s~Définir ~s~→→"}, true, function(_,_,s)
--                     if s then
--                         local pos = GetEntityCoords(PlayerPedId())
--                         builder.vendor = {x = pos.x, y = pos.y, z = pos.z}
--                     end
--                 end)
--                 -- Interactions
--                 RageUIPolice.Separator("↓ ~s~ Actions ~s~↓")
--                 RageUIPolice.ButtonWithStyle(colors[actualColor].."→ ~s~Sauvegarder et appliquer", "~s~Description: ~s~une fois toutes les étapes effectuées, sauvegardez votre drogue", {RightLabel = "→→"}, true, function(_,_,s)
--                     if s then
--                         shouldClose = true
--                         ESX.ShowNotification("~s~Création de la drogue en cours...")
--                         TriggerServerEvent("exedrugs_create", builder)
--                     end
--                 end)
--             end, function()    
--             end, 1)


--             if shouldClose and menuOpened then
--                 menuOpened = false
--             end

--             Wait(0)
--         end

--         delMenus()
--     end)
-- end