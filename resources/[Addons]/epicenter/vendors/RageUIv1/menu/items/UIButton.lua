---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 491, Height = 38 },
    Text = { X = 28, Y = 3, Scale = 0.25 },
    LeftBadge = { X = 15, Y = 1, Width = 35, Height = 35 },
    RightBadge = { X = 437, Y = 0, Width = 35, Height = 35 },
    RightText = { X = 462, Y = 3, Scale = 0.25 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 491, Height = 38 },
}

---Button
---@param Label string
---@param Description string
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function RageUIv1.Button(Label, Description, Enabled, Callback, Submenu)
    local CurrentMenu = RageUIv1.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        ---@type number
        local Option = RageUIv1.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            ---@type boolean
            local Active = CurrentMenu.Index == Option

            RageUIv1.ItemsSafeZone(CurrentMenu)

            if Active then
                RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
            end

            local colorData = Enabled and (Active and { 0, 0, 0 } or { 255, 255, 255 }) or { 163, 159, 148 }
            RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, 0, SettingsButton.Text.Scale, colorData[1], colorData[2], colorData[3], 255)

            RageUIv1.ItemOffset = RageUIv1.ItemOffset + SettingsButton.Rectangle.Height

            RageUIv1.ItemsDescription(CurrentMenu, Description, Active);

            if Enabled then
                ---@type boolean
                local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUIv1.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton);
                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active

                if Callback then
                    Callback(Hovered, Active, Selected)
                end

                if Selected then
                    local Audio = RageUIv1.Settings.Audio
                    RageUIv1.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

                    if Submenu and Submenu() then
                        RageUIv1.NextMenu = Submenu
                    end
                end
            end
        end

        RageUIv1.Options = RageUIv1.Options + 1
    end
end

---ButtonWithStyle
---@param Label string
---@param Description string
---@param Style table
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function RageUIv1.ButtonWithStyle(Label, Description, Style, Enabled, Callback, Submenu)
    local CurrentMenu = RageUIv1.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        ---@type number
        local Option = RageUIv1.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            ---@type boolean
            local Active = CurrentMenu.Index == Option

            RageUIv1.ItemsSafeZone(CurrentMenu)

            local haveLeftBadge = Style.LeftBadge and Style.LeftBadge ~= RageUIv1.BadgeStyle.None
            local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= RageUIv1.BadgeStyle.None) or (not Enabled and Style.LockBadge ~= RageUIv1.BadgeStyle.None)

            local LeftBadgeOffset = haveLeftBadge and 27 or 0
            local RightBadgeOffset = haveRightBadge and 32 or 0

            RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 30, SettingsButton.SelectedSprite.Height - 3, 21, 25, 31, 255)

            if Style.Color and Style.Color.BackgroundColor then
                RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.BackgroundColor[1], Style.Color.BackgroundColor[2], Style.Color.BackgroundColor[3])
            end

            if Active then
                if Style.Color and Style.Color.HightLightColor then
                    RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.HightLightColor[1], Style.Color.HightLightColor[2], Style.Color.HightLightColor[3])
                else
                    RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 487, SettingsButton.SelectedSprite.Height - 3, CurrentMenu.ButtonColor.R, CurrentMenu.ButtonColor.G, CurrentMenu.ButtonColor.B, CurrentMenu.ButtonColor.A)
                    --RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                    --RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 487, SettingsButton.SelectedSprite.Height - 3, CurrentMenu.ButtonColor.R, CurrentMenu.ButtonColor.G, CurrentMenu.ButtonColor.B, CurrentMenu.ButtonColor.A)
                end
            end

            if Enabled then
                if haveLeftBadge then
                    local LeftBadge = Style.LeftBadge(Active)
                    RenderSprite(LeftBadge.BadgeDictionary or "commonmenu", LeftBadge.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255)
                end

                if haveRightBadge then
                    local RightBadge = Style.RightBadge(Active)
                    RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end

                if Style.RightLabel then
                        local R_ITEM_BUTTON = not Active and 155 or 255; 
                    local G_ITEM_BUTTON = not Active and 155 or 255;
                    local B_ITEM_BUTTON = not Active and 155 or 255;
                    RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, 0, SettingsButton.RightText.Scale, R_ITEM_BUTTON, G_ITEM_BUTTON, B_ITEM_BUTTON, 255, 2)
                end

                local R_ITEM_BUTTON = not Active and 155 or 255; 
                local G_ITEM_BUTTON = not Active and 155 or 255;
                local B_ITEM_BUTTON = not Active and 155 or 255;
                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, 0, SettingsButton.Text.Scale, R_ITEM_BUTTON, G_ITEM_BUTTON, B_ITEM_BUTTON, 255)
            else
                if haveRightBadge then
                    local RightBadge = RageUIv1.BadgeStyle.Lock(Active)
                    RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end

                local R_ITEM_BUTTON = not Active and 155 or 255; 
                local G_ITEM_BUTTON = not Active and 155 or 255;
                local B_ITEM_BUTTON = not Active and 155 or 255;
                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv1.ItemOffset, 0, SettingsButton.Text.Scale, R_ITEM_BUTTON, G_ITEM_BUTTON, B_ITEM_BUTTON, 255)
            end

            RageUIv1.ItemOffset = RageUIv1.ItemOffset + SettingsButton.Rectangle.Height

            RageUIv1.ItemsDescription(CurrentMenu, Description, Active);

            if Enabled then
                ---@type boolean
                local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUIv1.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton);
                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active

                if Callback then
                    Callback(Hovered, Active, Selected)
                end

                if Selected then
                    local Audio = RageUIv1.Settings.Audio
                    RageUIv1.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

                    if Submenu and Submenu() then
                        RageUIv1.NextMenu = Submenu
                    end
                end
            end

        end

        RageUIv1.Options = RageUIv1.Options + 1
    end
end
