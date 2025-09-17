---@enum HUDProgressBarSettings
HUDProgressBarSettings = {

    height = 30,
    width = 300,
    x = 960,
    y = 1000,
    ---@enum HUDProgressBarSettings.Color
    Color = {

        ---@enum HUDProgressBarSettings.Color.Background
        Background = {
            r = 0, 
            g = 0, 
            b = 0, 
            a = 40
        },
        ---@enum HUDProgressBarSettings.Color.Bar
        Bar = {
            r = Engine["Config"]["MarkerRGB"]["R"], 
            g = Engine["Config"]["MarkerRGB"]["G"], 
            b = Engine["Config"]["MarkerRGB"]["B"],  
            a = Engine["Config"]["MarkerRGB"]["A1"]
        },

    },

};