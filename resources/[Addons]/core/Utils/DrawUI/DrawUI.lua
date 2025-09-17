DrawUI = {}

local menus = {}
local currentMenu = nil

function DrawUI:AddMenu(name, parent)
    menus[name] = { visible = false, parent = parent }
end

function DrawUI:Close(menuName)
    if menus[menuName] then
        menus[menuName].visible = false
        if currentMenu == menuName then
            currentMenu = nil
        end
    end
end

function DrawUI:SetCurrentMenu(menuName)
    if menus[menuName] then
        currentMenu = menuName
    end
end

function DrawUI:IsVisible(menuName)
    if currentMenu == menuName and menus[menuName].visible then
        self:ManageControls()
        return true
    end
    return false
end

function DrawUI:ManageControls()
    SetMouseCursorActiveThisFrame()
    local actionsToDisable = {24, 25, 37, 44, 140, 141, 142, 143, 257, 263, 264, 331}
    local mouseActionsToEnable = {1, 2, 24}
    local cameraActionsToDisable = {1, 2, 3, 4, 5, 6, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}

    for _, action in ipairs(actionsToDisable) do
        DisableControlAction(0, action, true)
    end

    for _, action in ipairs(mouseActionsToEnable) do
        EnableControlAction(0, action, true)
    end

    for _, action in ipairs(cameraActionsToDisable) do
        DisableControlAction(0, action, true)
    end

    if IsControlJustPressed(0, 24) then
        SetMouseCursorSprite(5)
        self.cursorChanged = true
        self.cursorChangeTime = GetGameTimer()
    end

    if self.cursorChanged and (GetGameTimer() - self.cursorChangeTime > 250) then
        SetMouseCursorSprite(1)
        self.cursorChanged = false
    end
end

function DrawUI:Toggle(menuName)
    if menus[menuName] then
        local menu = menus[menuName]
        menu.visible = not menu.visible
        if menu.visible then
            self:SetCurrentMenu(menuName)
        else
            self:BackToParentMenu()
        end

        local colorOpen = "^2"  -- Vert
        local colorClose = "^1" -- Rouge
        local colorMenuName = "^4" -- Bleu

        local statusColor = menu.visible and colorOpen or colorClose
        local statusText = menu.visible and "OPEN" or "CLOSE"

        Shared.Log:Info("Menu (" .. colorMenuName .. menuName .. "^0) is " .. statusColor .. statusText)
    end
end

function DrawUI:BackToParentMenu()
    if currentMenu and menus[currentMenu] and menus[currentMenu].parent then
        local parentMenu = menus[currentMenu].parent
        menus[currentMenu].visible = false
        self:SetCurrentMenu(parentMenu)
        menus[parentMenu].visible = true
    else
        currentMenu = nil
    end
end

function DrawUI:IsMenuVisible(menuName)
    return menus[menuName] and menus[menuName].visible
end

function DrawUI:Rectangle(x, y, width, height, r, g, b, a)
    -- Normalisation des coordonnées par rapport à une résolution de base de 1920x1080
    local X, Y, Width, Height = (x or 0) / 1920, (y or 0) / 1080, (width or 0) / 1920, (height or 0) / 1080
    -- Dessin du rectangle en centrant ses coordonnées normalisées
    DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, r or 255, g or 255, b or 255, a or 255)
end

function DrawUI:DrawSprite(textureDict, textureName, x, y, width, height, heading, r, g, b, a)
    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, true)
        while not HasStreamedTextureDictLoaded(textureDict) do
            Wait(0)
            Shared.Log:Error("Waiting for texture dict " .. textureDict .. " to load")
        end
    end

    DrawSprite(textureDict, textureName, x, y, width, height, heading, r, g, b, a)
end

function DrawUI:AddText(text, x, y, scaleX, scaleY, r, g, b, a, font, center)
    SetTextFont(font or 0)
    SetTextProportional(1)
    SetTextScale(scaleX or 0.35, scaleY or 0.35)
    SetTextColour(r or 255, g or 255, b or 255, a or 255)
    SetTextCentre(center ~= false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function DrawUI:PlaySound(library, sound, isLooped)
    local audioId
    if not isLooped then
        PlaySoundFrontend(-1, sound, library, true)
    else
        if not audioId then
            CreateThread(function()
                audioId = GetSoundId()
                PlaySoundFrontend(audioId, sound, library, true)
                Wait(0.05)
                StopSound(audioId)
                ReleaseSoundId(audioId)
                audioId = nil
            end)
        end
    end
end

function DrawUI:IsCursorInRectangle(x, y, width, height)
    local cursorX, cursorY = GetNuiCursorPosition()
    local screenWidth, screenHeight = GetActiveScreenResolution()
    cursorX, cursorY = cursorX / screenWidth, cursorY / screenHeight
    return cursorX >= x and cursorX <= x + width and cursorY >= y and cursorY <= y + height
end

function DrawUI:HandleClickOnRectangle(x, y, width, height, callback)
    if self:IsCursorInRectangle(x, y, width, height) and IsControlJustReleased(0, 24) then
        self:PlaySound("WEB_NAVIGATION_SOUNDS_PHONE", "CLICK_BACK", false)
        callback()
    end
end