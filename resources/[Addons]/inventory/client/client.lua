ScriptClient = {}
ScriptClient.Enabled = true -- This is for our test server.
ScriptClient.resourceName = GetCurrentResourceName()
ScriptClient.resourceStarted = false
ScriptClient.playerReady = false
ScriptClient.cefLoaded = false
ScriptClient.Player = {}
ScriptClient.Player.State = LocalPlayer.state
ScriptClient.Player.State.inventoryOpened = false
ScriptClient.Player.State.shortkeys = true

AddEventHandler("onClientResourceStart", function(resourceName)
    if ScriptClient.resourceName ~= resourceName then return end

    ScriptClient.resourceStarted = true
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    ScriptClient.playerReady = true

    while not (ScriptClient.playerReady and ScriptClient.resourceStarted and ScriptClient.cefLoaded) do
        Wait(100)
    end

    Wait(4000)

    TriggerServerEvent("inventory:CLIENT_LOADED")
end)

function SEND_NUI_MESSAGE(d)
    while not ScriptClient.cefLoaded do
        Wait(100)
    end

    SendNUIMessage(d)
end

RegisterNetEvent("inventory:PLAYER_SEND_NUI_MESSAGE", function(data, open)
    if (open) then
        SEND_NUI_MESSAGE({
            event = "SET_INTERFACE_OPEN",
            state = not ScriptClient.Player.State.inventoryOpened
        })
    end
    SEND_NUI_MESSAGE(data)
end)    

RegisterNUICallback("CEF_LOADED", function(_, cb)
    ScriptClient.cefLoaded = true
    cb({})
end)

---@type number | nil
local inventoryOpenedThreadId = nil

RegisterNUICallback("CLIENT_SET_INTERFACE_STATE", function(d, cb)
    local state = d.state

    ScriptClient.Player.State.inventoryOpened = state
    SetNuiFocus(state, state)
    SetNuiFocusKeepInput(state)

    if state then
        TriggerEvent("inventory:onInventoryOpen")
        TriggerServerEvent("inventory:onInventoryOpen")
        TriggerServerEvent("inventory:OPEN_NEAR_DROPPED_GRID")

        if inventoryOpenedThreadId == nil then
            Citizen.CreateThreadNow(function(id)
                inventoryOpenedThreadId = id

                while inventoryOpenedThreadId ~= nil do
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 18, true)
                    DisableControlAction(0, 322, true)
                    DisableControlAction(0, 106, true)
                    DisableControlAction(0, 0, true)
                    DisableControlAction(0, 75, true)
                    DisableControlAction(0, 245, true)
                    DisableControlAction(0, 309, true)
                    DisableControlAction(0, 80, true)
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                    Wait(0)
                end
            end)
        end
    else
        TriggerEvent("inventory:onInventoryClose")
        TriggerServerEvent("inventory:onInventoryClose")

        if inventoryOpenedThreadId ~= nil then
            inventoryOpenedThreadId = nil
        end
    end

    cb({})
end)

RegisterCommand('OPEN_INVENTORY', function()
    if not ScriptClient.Enabled then return end

    SEND_NUI_MESSAGE({
        event = "SET_INTERFACE_OPEN",
        state = not ScriptClient.Player.State.inventoryOpened
    })
end, false)
RegisterKeyMapping('OPEN_INVENTORY', 'Open Inventory', 'keyboard', 'TAB')
