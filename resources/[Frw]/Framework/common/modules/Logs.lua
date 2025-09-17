ESX.Logs = {
    ---@param message string
    ["Info"] = function (message, ...)
        exports["core_nui"]:Info(message, ...);
    end,

    ---@param message string
    ["Warn"] = function (message, ...)
        exports["core_nui"]:Warn(message, ...);
    end,

    ---@param message string
    ["Error"] = function (message, ...)
        exports["core_nui"]:Error(message, ...);
    end,

    ---@param message string
    ["Success"] = function (message, ...)
        exports["core_nui"]:Success(message, ...);
    end
};