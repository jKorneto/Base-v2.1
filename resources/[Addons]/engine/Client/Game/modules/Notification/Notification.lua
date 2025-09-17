---@type GameNotification
GameNotification = Class.new(function(class) 

    ---@class GameNotification: BaseObject
    local self = class;

    ---@private
    function self:Constructor()
        Shared:Initialized("Game.Notification");
    end

    ---@param message string
    ---@param hasTranslation boolean
    ---@param ... any
    function self:showNotification(message, hasTranslation, ...)
        if (hasTranslation) then
            exports["notify"]:MontreToiBasique(message, nil, nil, true, nil, Shared:ServerName(), "Notification", "message")
        else
            exports["notify"]:MontreToiBasique((message):format(...), nil, nil, true, nil, Shared:ServerName(), "Notification", "message")
        end
    end

    ---@param message string
    ---@param thisFrame boolean
    ---@param beep boolean
    ---@param duration number
    function self:ShowHelp(message)
        AddTextEntry('esxHelpNotification', message)
        BeginTextCommandDisplayHelp('esxHelpNotification')
        EndTextCommandDisplayHelp(0, false, true, -1)
    end

    RegisterNetEvent('engine:notification', function(message, hasTranslation, ...)
        self:showNotification(message, hasTranslation, ...)
    end)

    return self;
end);