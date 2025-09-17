ScriptServer = {}
ScriptServer.Classes = {}
ScriptServer.Managers = {}
ScriptServer.resourceName = GetCurrentResourceName()
ScriptServer.isLoaded = false

AddEventHandler("onServerResourceStart", function(resourceName)
    if ScriptServer.resourceName ~= resourceName then return end

    ScriptServer.Managers.Dropped:onServerResourceStart()
    ScriptServer.isLoaded = true

    for k, v in pairs(CONFIG.FACTION_INVENTORIES) do
        ScriptServer.Classes.FactionInventory.new({
            faction = k,
            inventoryName = v.header,
            maxWeight = v.maxWeight,
            slotsAmount = v.slotsAmount,
            uniqueID = k,
            safeCoords = vector3(v.x, v.y, v.z),
            safeHeading = v.heading
        })
    end
end)

AddEventHandler("playerDropped", function()
    local playerSrc = source
    if (not playerSrc) then return end

    local player = ESX.GetPlayerFromId(playerSrc)
    if (not player) then return end
    
    local identifier = player:getIdentifier()

    local inventory = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = identifier })
    if not inventory then return end

    inventory:save()
    inventory:destroy()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if ScriptServer.resourceName ~= resourceName then return end

    ScriptServer.Managers.Dropped:onResourceStop()
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(45000)
            ScriptServer.Managers.Inventory:SaveInventories()
        end)
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
    ScriptServer.Managers.Inventory:SaveInventories()
end)

RegisterCommand("testSave", function()
    ScriptServer.Managers.Inventory:SaveInventories()
end)

local function SaveInventoriesInterval()
    ScriptServer.Managers.Inventory:SaveInventories()
    SetTimeout(CONFIG.SAVE_INVENTORIES_MS, SaveInventoriesInterval)
end

SetTimeout(CONFIG.SAVE_INVENTORIES_MS, SaveInventoriesInterval)