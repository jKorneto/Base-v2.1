---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- File created at [26/05/2021 10:22]
---

local Settings = {
    Background = {12, 16, 21, 255},
    Button = {
        Width = 220,
        Height = 30,
        Background = {
            { 21, 25, 31, 255 },
            { Config["MarkerRGB"]["R"], Config["MarkerRGB"]["G"], Config["MarkerRGB"]["B"], Config[""] }
        }
    },
    Text = {
        Colors = {
            { 255, 255, 255, 150 },
            { 255, 255, 255, 255}
        },
        X = 8.0,
        Y = 1.5,
        Scale = 0.23,
        Font = ServerFontStyle,
        Center = 0,
        Outline = false,
        DropShadow = false,
    },
    Title = {
        Background = { 25, 80, 150, 240 },
        Text = { 255, 255, 255, 255 }
    }
}

ContextUI = {
    Entity = {
        ID = nil,
        Type = nil,
        Model = nil,
        NetID = nil,
        ServerID = nil,
    },
    Menus = {},
    Focus = false,
    Open = false,
    Position = vector2(0.0, 0.0),
    Offset = vector2(0.0, 0.0),
    Options = 0,
    Category = "main",
    CategoryID = 0,
    Description = nil,
    Background = {
        Height = 0
    },
    ItemOffset = 0,
    Buttons = 0
}

function ContextUI:OnClosed()
    ResetEntityAlpha(self.Entity.ID)
    self.Entity.ID = nil
    self.Open = false
    self.Focus = false
    self.Category = "main"
    self.Options = 0
    ContextUI.Buttons = 0

    if (self.Closed) then
        self.Closed()
    end
end

local function ShowBackground()
    local PosX, PosY = ContextUI.Position.x, ContextUI.Position.y
    Graphics.Rectangle(PosX - 5, PosY + 25, Settings.Button.Width + 10, ContextUI.Background.Height - 17, Settings.Background[1], Settings.Background[2], Settings.Background[3], Settings.Background[4])
    ContextUI.Options = ContextUI.Options + 1
    ContextUI.Offset = vector2(PosX, PosY)
end

local function ShowDescription(Description)
    local PosX, PosY = ContextUI.Position.x, ContextUI.Position.y
    PosY = PosY + (ContextUI.Options * Settings.Button.Height)
    local GetLineCount = Graphics.GetLineCount(Description, PosX + 110, PosY, ServerFontStyle, 0.24, Settings.Title.Text[1], Settings.Title.Text[2], Settings.Title.Text[3], Settings.Title.Text[4], 1, false, false, 215)
    Graphics.Rectangle(PosX, PosY, Settings.Button.Width, 2, Config["MarkerRGB"]["R"], Config["MarkerRGB"]["G"], Config["MarkerRGB"]["B"], Config["MarkerRGB"]["A1"])
    Graphics.Rectangle(PosX, PosY + 2, Settings.Button.Width, 1 + (GetLineCount * 17.5), 0, 0, 0, 160)
    Graphics.Text(Description, PosX + 110, PosY, ServerFontStyle, 0.18, Settings.Title.Text[1], Settings.Title.Text[2], Settings.Title.Text[3], Settings.Title.Text[4], 1, false, false, 215)
    ContextUI.Offset = vector2(PosX, PosY + 3 +(GetLineCount * 17.5))
end

function ContextUI:Button(Label, Description, Actions, Submenu)
    local PosX, PosY = self.Position.x, self.Position.y
    PosY = PosY + (self.Options * Settings.Button.Height)
    local onHovered = Graphics.IsMouseInBounds(PosX, PosY, Settings.Button.Width, Settings.Button.Height)

    if (onHovered) then
        local Selected = false;
        SetMouseCursorSprite(5)
        if IsControlJustPressed(0, 24) then
            Selected = true
            if (Actions) then
                Actions(Selected)
            end

            if (Submenu) then
                self.Category = Submenu.Category
            end
            PlaySoundFrontend(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 1);
        end
        self.Description = Description
    end

    local Index = (not onHovered) and 1 or 2
    Graphics.Rectangle(PosX, PosY + ContextUI.ItemOffset, Settings.Button.Width, Settings.Button.Height, Settings.Button.Background[1][1], Settings.Button.Background[1][2], Settings.Button.Background[1][3], Settings.Button.Background[1][4])
    if (onHovered) then
        Graphics.Rectangle(PosX, PosY + ContextUI.ItemOffset, Settings.Button.Width -218, Settings.Button.Height, Settings.Button.Background[2][1], Settings.Button.Background[2][2], Settings.Button.Background[2][3], Settings.Button.Background[2][4])
    end
    Graphics.Text(Label, PosX + Settings.Text.X, PosY + Settings.Text.Y + ContextUI.ItemOffset, ServerFontStyle, 0.20, Settings.Text.Colors[Index][1], Settings.Text.Colors[Index][2], Settings.Text.Colors[Index][3], Settings.Text.Colors[Index][4], Settings.Text.Center, Settings.Text.Outline, Settings.Text.DropShadow)
    if (Submenu) then
        local labelArrow = Label == "Retour" and "←" or "→"
        Graphics.Text(labelArrow, PosX + Settings.Text.X + 190, PosY + Settings.Text.Y + ContextUI.ItemOffset, ServerFontStyle, 0.20, Settings.Text.Colors[Index][1], Settings.Text.Colors[Index][2], Settings.Text.Colors[Index][3], Settings.Text.Colors[Index][4], Settings.Text.Center, Settings.Text.Outline, Settings.Text.DropShadow)
    end

    self.Options = self.Options + 1
    ContextUI.Background.Height =  (Settings.Button.Height) * (self.Options)
    ContextUI.ItemOffset = ContextUI.ItemOffset + 1
    ContextUI.Buttons = self.Options
    self.Offset = vector2(PosX, PosY)
end

function ContextUI:Visible()
    SetMouseCursorSprite(1)
    self.Menus[self.Entity.Type .. self.Category]()
    local X, Y = 1920, 1080
    local lastX, lastY = self.Offset.x, self.Offset.y
    if (lastY + (not self.Description and Settings.Button.Height or 0)) >= Y then
        self.Position = vector2(self.Position.x, self.Position.y - 10.0)
    end
    if (lastX + Settings.Button.Width) >= X then
        self.Position = vector2(self.Position.x - 10.0, self.Position.y)
    end
    
    ContextUI.ItemOffset = 0
    self.Options = 0;
    self.Description = nil;
end

function ContextUI:CreateMenu(EntityType, Title)
    return { EntityType = EntityType, Category = "main", Parent = nil, Title = Title }
end

function ContextUI:CreateSubMenu(Parent, Title)
    local category = self.CategoryID + 1
    self.CategoryID = category;
    return { EntityType = Parent.EntityType, Category = category, Parent = Parent, Title = Title }
end

function ContextUI:IsVisible(Menu, Callback, onBack, onClose)
    self.Menus[Menu.EntityType .. Menu.Category] = function()
        if (ContextUI.Buttons > 0) then
            ShowBackground()
        end
        Callback(self.Entity)
        if Menu.Parent then
            self.onBack = onBack
            self:Button("Retour", nil, function(onSelected)
                if (onSelected) then
                    if (self.onBack) then
                        self.onBack()
                    end
                end
            end, Menu.Parent)
        end
        if (self.Description) then
            ShowDescription(self.Description)
        end

        self.Closed = onClose
    end
end

CreateThread(function()
    local controls_actions = { 239, 240, 24, 25 }
    while true do
        local Timer = 500;
        if IsControlPressed(0, 19) or IsDisabledControlPressed(0, 19) then
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            SetMouseCursorActiveThisFrame()
            for _, control in ipairs(controls_actions) do
                EnableControlAction(0, control, true)
            end
            if (not ContextUI.Open) then
                local isFound, entityCoords, surfaceNormal, entityHit, entityType, cameraDirection, mouse = Graphics.ScreenToWorld(35.0, 31)
                if (entityType ~= 0) then
                    SetMouseCursorSprite(5)
                    if ContextUI.Entity.ID ~= entityHit then
                        ResetEntityAlpha(ContextUI.Entity.ID)
                        ContextUI.Entity.ID = entityHit
                        SetEntityAlpha(ContextUI.Entity.ID, 200, false)
                    end
                    if IsControlJustPressed(0, 24) or IsDisabledControlPressed(0, 24) then
                        ResetEntityAlpha(ContextUI.Entity.ID)
                        if (ContextUI.Menus[entityType .. ContextUI.Category] ~= nil) then
                            local posX, posY = Graphics.ConvertToPixel(mouse.x, mouse.y)
                            ContextUI.Position = vector2(posX, posY)
                            ContextUI.Entity = {
                                ID = entityHit,
                                Type = entityType,
                                Model = GetEntityModel(entityHit) or 0,
                                NetID = NetworkGetNetworkIdFromEntity(entityHit),
                                ServerID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHit))
                            }
                            ContextUI.Open = true
                            Audio.PlaySound("NAV_UP_DOWN", false)
                        end
                    end
                else
                    if (ContextUI.Entity.ID ~= nil) then
                        ResetEntityAlpha(ContextUI.Entity.ID)
                        ContextUI.Entity.ID = nil
                    end
                    SetMouseCursorSprite(1)
                end
            else
                ContextUI:Visible()
            end
            DisablePlayerFiring(PlayerPedId(), true)
            Timer = 1;
        elseif (ContextUI.Entity.ID ~= nil) then
            ResetEntityAlpha(ContextUI.Entity.ID)
            ContextUI:OnClosed()
        end
        Wait(Timer)
    end
end)
