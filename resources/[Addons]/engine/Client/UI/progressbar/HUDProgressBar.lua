local function calculatePercentage(startTimestamp, endTimestamp, currentTimestamp)
    local totalDifference = endTimestamp - startTimestamp
    local currentDifference = currentTimestamp - startTimestamp
    local remainingPercentage = ((totalDifference - currentDifference) / totalDifference) * 100
    return remainingPercentage
end

---@type fun(text: string, time: number, callback: function, color: HUDProgressBarSettings.Color): HUDProgressBar
HUDProgressBar = Class.new(function(class)
    
    ---@class HUDProgressBar: BaseObject
    local self = class;

    ---@param text string
    ---@param time number
    ---@param callback? function
    ---@param color? HUDProgressBarSettings.Color
    function self:Constructor(text, time, callback, color)
        self.text = text;
        self.timer = Shared.Timer(time);
        self.callback = callback;
        self.start = GetGameTimer();
        self.finish = GetGameTimer() + (time * 1000);
        self.color = color or HUDProgressBarSettings.Color;
        self.timer:Start();
        self:Draw();
    end

    function self:Draw()
        CreateThread(function()
            while (true) do

                local ms = GetGameTimer()
                local percent = calculatePercentage(self.start, self.finish, ms)
                local percentText = Shared.Math:Round(percent) .. "% restant"

                if self.timer:HasPassed() then
                    if (type(self.callback) == "function") then
                        self.callback()
                    end
                    break
                end

                HUD.DrawRectangle(
                    HUDProgressBarSettings.x, 
                    HUDProgressBarSettings.y, 
                    HUDProgressBarSettings.width, 
                    HUDProgressBarSettings.height,
                    self.color.Background
                )

                HUD.DrawRectangle(
                    HUDProgressBarSettings.x, 
                    HUDProgressBarSettings.y, 
                    HUDProgressBarSettings.width - (HUDProgressBarSettings.width * percent) / 100, 
                    HUDProgressBarSettings.height,
                    self.color.Bar
                )

                HUD.DrawText(
                    percentText, 
                    HUDProgressBarSettings.x, 
                    HUDProgressBarSettings.y - (HUDProgressBarSettings.height / 6.0), 
                    nil, 
                    0.2, 
                    false, 
                    nil, 
                    nil, 
                    1
                )

                if (type(self.text) == "string" and self.text ~= "") then
                    HUD.DrawText(
                        self.text, 
                        HUDProgressBarSettings.x, 
                        HUDProgressBarSettings.y - (HUDProgressBarSettings.height / 1.8), 
                        nil, 
                        0.2, 
                        false, 
                        nil, 
                        nil, 
                        1
                    )
                end

                Wait(0);

            end
        end)
    end

    return self;

end)
