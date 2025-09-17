---@type Notification
Notification = Class.new(function(class) 

    ---@class Notification: BaseObject
    local self = class;

    function self:Constructor()
        Shared:Initialized("Game.Notification");
    end

    ---@param message string
    ---@param hasTranslation boolean
    ---@param ... any
    function self:showNotification(message, hasTranslation, ...)
        if (hasTranslation) then
            local translatedMessage = Shared.Lang:Translate(message, ...);
            ESX.ShowNotification(translatedMessage);
        else
            local formattedMessage = message:format(...);
            ESX.ShowNotification(formattedMessage);
        end
    end

    return self;
end);
