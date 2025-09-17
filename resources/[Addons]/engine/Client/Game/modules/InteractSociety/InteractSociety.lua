---@overload fun(): InteractSociety
InteractSociety = Class.new(function(class)
    ---@class InteractSociety: BaseObject
    local self = class
    local interactJobStorage = Shared.Storage:Register("InteractJobMenu")

    function self:Constructor()
        Shared:Initialized("Game.InteractSociety")
    end

    ---AddMenu
    ---@param jobName string
    ---@param title string
    ---@param subtitle string
    ---@param textureDictionary string
    ---@param textureName string
    ---@param color table
    ---@return RageUI.Menu
    function self:AddMenu(jobName, title, subtitle, textureDictionary, textureName, color)
        if (jobName) then
            interactJobStorage:Set(jobName.."_menu", RageUI.AddMenu(title or "", subtitle or ""))

            if (textureDictionary and textureName) then
                interactJobStorage:Get(jobName.."_menu"):SetSpriteBanner(textureDictionary, textureName)
            end

            if (color) then
                interactJobStorage:Get(jobName.."_menu"):SetButtonColor(color.R, color.G, color.B, color.A)
            end
        else
            local info = debug.getinfo(2, "Sl")
            local fileName = info.source:gsub("^@", "")
            local lineNumber = info.currentline
    
            Shared.Log:Error("InteractSociety:AddMenu: jobName is nil ("..fileName.." at line "..lineNumber..")")
        end

        return interactJobStorage:Get((jobName or "").."_menu")
    end

    ---AddSubMenu
    ---@param jobName string
    ---@param parent RageUI.Menu
    ---@param title string
    ---@param subtitle string
    ---@param textureDictionary string
    ---@param textureName string
    ---@param color table
    ---@return RageUI.Menu
    function self:AddSubMenu(jobName, parent, title, subtitle, textureDictionary, textureName, color)
        if (jobName) then
            interactJobStorage:Set(jobName.."_submenu", RageUI.AddSubMenu(parent, title or "", subtitle or ""))

            if (textureDictionary and textureName) then
                interactJobStorage:Get(jobName.."_submenu"):SetSpriteBanner(textureDictionary, textureName)
            end

            if (color) then
                interactJobStorage:Get(jobName.."_submenu"):SetButtonColor(color.R, color.G, color.B, color.A)
            end
        else
            local info = debug.getinfo(2, "Sl")
            local fileName = info.source:gsub("^@", "")
            local lineNumber = info.currentline
    
            Shared.Log:Error("InteractSociety:AddSubMenu: jobName is nil ("..fileName.." at line "..lineNumber..")")
        end

        return interactJobStorage:Get((jobName or "").."_submenu")
    end

    ---GetMenu
    ---@param jobName string
    ---@return RageUI.Menu
    function self:GetMenu(jobName)
        return interactJobStorage:Get(jobName.."_menu")
    end

    ---OpenMenu
    ---@param jobName string
    ---@return nil
    function self:OpenMenu(jobName)
        local menu = interactJobStorage:Get(jobName.."_menu")

        if (menu ~= nil) then
            menu:Toggle()
        end
    end

    Shared:RegisterKeyMapping("InteractSociety", {label = "Open Menu Society"}, "F6", function()
        if (Client.Player ~= nil) then
            self:OpenMenu(Client.Player:GetJob().name)
        end
    end)

    return self
end)