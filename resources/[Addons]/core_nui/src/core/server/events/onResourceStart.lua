local function Initialize(callback)
    local ItemsLoaded = promise.new()

    MOD_Items:load(function() 
        ItemsLoaded:resolve() 
    end)

    Citizen.Await(ItemsLoaded)

    callback()
end

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    -- print("^5[core_nui] ^2[SUCCESS] ^7core_nui is starting ...")

    Initialize(function()
        TriggerEvent('OneLife:IsReady')
    end)
end)