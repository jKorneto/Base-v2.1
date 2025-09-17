local nuiIsLoaded = false
local actualRoute = "/"
local hasChangedPage = false

-- RegisterNuiCallback("nui_loaded", function(data)
--     nuiIsLoaded = data.message
--     if nuiIsLoaded then
--         exports["engine"]:Success("Nui Loaded")
--     else
--         exports["engine"]:Error(("Nui Failed to Load : %s"):format(data.error))
--     end
-- end)

RegisterNuiCallback("navigationComplete", function(data)
    hasChangedPage = true
end)

local function isNuiLoaded()
    -- while not nuiIsLoaded do
    --     Wait(250)
    -- end

    return true
end

local function ReceiveNuiMessage(message, route)
    if (isNuiLoaded()) then
        actualRoute = route or actualRoute

        SendNUIMessage({type = "navigate", route = actualRoute})

        local timer = 0
        while not hasChangedPage do
            if timer > 5000 then
                print("Timeout waiting for navigationComplete")
                break
            end
            Wait(50)
            timer = timer + 50
        end

        if (hasChangedPage) then
            Wait(250)
            SendNUIMessage(message)
            hasChangedPage = false
        end
    end
end

---@param hasFocus boolean
---@param hasCursor boolean
local function ReceiveNuiFocus(hasFocus, hasCursor)
    if isNuiLoaded() then
        SetNuiFocus(hasFocus or false, hasCursor or false)
    end
end

---@param keepInput boolean
local function ReceiveNuiFocusKeepInput(keepInput)
    if isNuiLoaded() then
        SetNuiFocusKeepInput(keepInput or false)
    end
end

local function openUrl(url)
    if isNuiLoaded() then
        SendNUIMessage({type = "openLink", url = url})
    end
end

exports("SendNUIMessage", function(message, route, nuiFocus, keepInput)
    ReceiveNuiMessage(message, route)
    ReceiveNuiFocus(nuiFocus or false, nuiFocus or false)
    ReceiveNuiFocusKeepInput(keepInput or false)
end)

exports("SetNuiFocus", function(hasFocus, hasCursor)
    return ReceiveNuiFocus(hasFocus, hasCursor)
end)

exports("SetNuiFocusKeepInput", function(keepInput)
    return ReceiveNuiFocusKeepInput(keepInput)
end)

exports("openUrl", function(url)
    return openUrl(url)
end)

RegisterNetEvent("engine_nui:receiveNuiMessage", function(message, route)
    ReceiveNuiMessage(message, route)
end)

RegisterNetEvent("engine_nui:receiveNuiFocus", function(hasFocus, hasCursor)
    ReceiveNuiFocus(hasFocus, hasCursor)
end)

RegisterNetEvent("engine_nui:receiveNuiFocusKeepInput", function(keepInput)
    ReceiveNuiFocusKeepInput(keepInput)
end)

RegisterNetEvent("engine_nui:receiveOpenUrl", function(url)
    openUrl(url)
end)
