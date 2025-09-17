RegisterNUICallback('nui:OneLife:Inventory:Settings', function(settings)
    MOD_inventory.class:setSettingsInventory(settings)
end)


RegisterNUICallback('nui:OneLife:Inventory:InvMoveInside', function(data)
    TriggerServerEvent('OneLife:Inventory:InvMoveInside', data)
end)


RegisterNUICallback('nui:OneLife:Inventory:InvMoveToMain', function(data)
    TriggerServerEvent('OneLife:Inventory:InvMoveToMain', data)
end)
RegisterNUICallback('nui:OneLife:Inventory:InvMoveToSecond', function(data)
    TriggerServerEvent('OneLife:Inventory:InvMoveToSecond', data)
end)


RegisterNUICallback('nui:OneLife:Inventory:InvMoveInstantToMain', function(data)

end)
RegisterNUICallback('nui:OneLife:Inventory:InvMoveInstantToSecond', function(data)

end)


RegisterNUICallback('nui:OneLife:Inventory:InvMoveToWeapons', function(data)
    TriggerServerEvent('OneLife:Inventory:InvMoveToWeapons', data)
end)
RegisterNUICallback('nui:OneLife:Inventory:MoveWeaponsToInv', function(data)
    TriggerServerEvent('OneLife:Inventory:MoveWeaponsToInv', data)
end)
RegisterNUICallback('nui:OneLife:Inventory:MoveWeaponsInside', function(data)
    TriggerServerEvent('OneLife:Inventory:MoveWeaponsInside', data)
end)


RegisterNUICallback('nui:OneLife:Inventory:InvUseItem', function(index)
    if (MOD_inventory.class.inventoryItems[index].type == "weapons") then
        TriggerServerEvent('OneLife:Inventory:InvUseItem', index, false)
    else
        TriggerServerEvent('OneLife:Inventory:InvUseItem', index)
    end
end)

RegisterNUICallback('nui:OneLife:Inventory:InvGiveItem', function(data)
    MOD_inventory.class:closeInventory()
    MOD_inventory.class:loadGiveItem(data)
end)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

local function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function GetObjects()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

local function GetClosestObject(filter, coords)
	local objects = GetObjects()
	local closestDistance, closestObject = -1, -1

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j = 1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
					break
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i], false)
			local distance = #(objectCoords - coords)

			if closestDistance == -1 or closestDistance > distance then
				closestObject = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
end

RegisterNUICallback('nui:OneLife:Inventory:InvDeleteItem', function(data)
    local playerPed =  PlayerPedId()
    local playerPosition = GetEntityCoords(playerPed)
    local found = GetClosestObject(Configcore_nui.trashlist, playerPosition)
    
    if IsPedSittingInAnyVehicle(playerPed) then
        ESX.ShowNotification("Vous ne pouvez pas supprimer d'items en etant dans un véhicule")
        return
    end

    if (not found) or #(GetEntityCoords(found)-playerPosition) >= 2 then
        ESX.ShowNotification("Aucune poubelle situé a proximité de vous")
        return
    end

    if IsPedRagdoll(PlayerPedId()) then
        ESX.ShowNotification("Impossible de réaliser cette action les mains levé")
        return
    end

    TriggerServerEvent('OneLife:Inventory:InvDeleteItem', data)
    ExecuteCommand("me tente de jetter un objets a la poubelle")
end)

------ CLOTHES
RegisterNUICallback('nui:OneLife:Inventory:InvMoveToClothes', function(data)
    if (MOD_inventory.ClohtesOnAnim) then return end

    TriggerServerEvent('OneLife:Inventory:InvMoveToClothes', data)
end)

RegisterNUICallback('nui:OneLife:Inventory:InvMoveClothesToMain', function(data)
    if (MOD_inventory.ClohtesOnAnim) then return end

    TriggerServerEvent('OneLife:Inventory:InvMoveClothesToMain', data)
end)
RegisterNUICallback('nui:OneLife:Inventory:InvMoveClothesToSecond', function(data)
    TriggerServerEvent('OneLife:Inventory:InvMoveClothesToSecond', data)
end)