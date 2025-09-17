local ESX = nil
local accountsAsItems = {
    ["cash"] = true,
    ["dirtycash"] = true,
}

local function Init()
    while GetResourceState("Framework") == "starting" do
        Wait(500)
    end

    if GetResourceState("Framework") ~= "started" then return end

    ESX = exports['Framework']:getSharedObject()

    local function loadEsxPlayerInventory(xPlayer)
        ScriptServer.Classes.PlayerInventory.new({
            inventoryName = "INVENTAIRE",
            maxWeight = CONFIG.PLAYER_INVENTORY_DEFAULTS.MAX_WEIGHT,
            slotsAmount = CONFIG.PLAYER_INVENTORY_DEFAULTS.SLOTS,
            source = xPlayer.source,
            type = "player",
            uniqueID = xPlayer.identifier
        })
    end

    local function createNewInventory(source, identifier)
        ScriptServer.Classes.PlayerInventory.new({
            inventoryName = "INVENTAIRE",
            maxWeight = CONFIG.PLAYER_INVENTORY_DEFAULTS.MAX_WEIGHT,
            slotsAmount = CONFIG.PLAYER_INVENTORY_DEFAULTS.SLOTS,
            source = source,
            type = "player",
            uniqueID = identifier
        })
    end

    exports("createNewInventory", createNewInventory)

    AddEventHandler("onServerResourceStart", function(resourceName)
        if (GetCurrentResourceName() == resourceName) then
            Wait(2000)

            local onlinePlayers = GetPlayers()
            for k, v in pairs(onlinePlayers) do
                local xPlayer = ESX.GetPlayerFromId(v)
                if xPlayer then
                    loadEsxPlayerInventory(xPlayer)
                end
            end
        end
    end)

    AddEventHandler("esx:playerLoaded", function(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        if (not xPlayer) then return end

        loadEsxPlayerInventory(xPlayer)

        for k, v in pairs(xPlayer.accounts) do
            if (v.name ~= "bank") then
                local currentMoney = exports["inventory"]:GetItemQuantityBy(xPlayer.identifier, {
                    name = v.name,
                })
                if (v.money == 0) then
                    exports["inventory"]:RemoveItemBy(xPlayer.identifier, currentMoney, {
                        name = v.name,
                    })
                else
                    exports["inventory"]:SetItemQuantity(xPlayer.identifier, v.name, v.money)
                end
            end
        end

        local chest_data = {}

        for k, v in pairs(CONFIG.CHEST_INVENTORIES) do
            chest_data[k] = v.coords
        end

        TriggerClientEvent("inventory:allChest:receive", src, chest_data)
    end)
end

Init()
