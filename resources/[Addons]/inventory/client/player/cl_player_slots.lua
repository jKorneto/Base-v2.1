RegisterCommand('SLOT_1', function()
    if not ScriptClient.Player.State.shortkeys then return end

    if ScriptClient.Player.Inventory:GetItemBy({ slot = 1 }) then
        TriggerServerEvent("inventory:USE_SLOT", 1)
    end
end, false)
RegisterCommand('SLOT_2', function()
    if not ScriptClient.Player.State.shortkeys then return end

    if ScriptClient.Player.Inventory:GetItemBy({ slot = 2 }) then
        TriggerServerEvent("inventory:USE_SLOT", 2)
    end
end, false)
RegisterCommand('SLOT_3', function()
    if not ScriptClient.Player.State.shortkeys then return end

    if ScriptClient.Player.Inventory:GetItemBy({ slot = 3 }) then
        TriggerServerEvent("inventory:USE_SLOT", 3)
    end
end, false)
RegisterCommand('SLOT_4', function()
    if not ScriptClient.Player.State.shortkeys then return end

    if ScriptClient.Player.Inventory:GetItemBy({ slot = 4 }) then
        TriggerServerEvent("inventory:USE_SLOT", 4)
    end
end, false)
RegisterCommand('SLOT_5', function()
    if not ScriptClient.Player.State.shortkeys then return end

    if ScriptClient.Player.Inventory:GetItemBy({ slot = 5 }) then
        TriggerServerEvent("inventory:USE_SLOT", 5)
    end
end, false)

RegisterKeyMapping('SLOT_1', 'Inventory Slot (1)', 'keyboard', "1")
RegisterKeyMapping('SLOT_2', 'Inventory Slot (2)', 'keyboard', "2")
RegisterKeyMapping('SLOT_3', 'Inventory Slot (3)', 'keyboard', "3")
RegisterKeyMapping('SLOT_4', 'Inventory Slot (4)', 'keyboard', "4")
RegisterKeyMapping('SLOT_5', 'Inventory Slot (5)', 'keyboard', "5")
