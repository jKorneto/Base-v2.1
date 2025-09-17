RegisterNetEvent("Core:AntiCheat:TakeScreen", function(WebHook)
    exports["screenshot-basic"]:requestScreenshotUpload(WebHook, "files[]", function(data) end)
end)