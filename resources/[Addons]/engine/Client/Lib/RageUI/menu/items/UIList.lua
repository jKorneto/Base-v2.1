---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 491, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.25 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 435, Y = 2, Width = 35, Height = 35 },
    RightText = { X = 465, Y = 4, Scale = 0.25 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 491, Height = 38 },
}

---@type table
local SettingsList = {
    LeftArrow = { Dictionary = "commonmenu", Texture = "arrowleft", X = 378, Y = 4, Width = 30, Height = 30 },
    RightArrow = { Dictionary = "commonmenu", Texture = "arrowright", X = 400, Y = 4, Width = 30, Height = 30 },
    Text = { X = 460.5, Y = 4, Scale = 0.25 },
}

function Items:List(Label, Items, Index, Description, Style, Enabled, Actions, Submenu, condition)
    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;

    if CurrentMenu ~= nil then
        if CurrentMenu then

            ---@type number
            local Option = RageUI.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type number
                local Selected = CurrentMenu.Index == Option

                ---@type boolean
                local LeftArrowHovered, RightArrowHovered = false, false

                RageUI.ItemsSafeZone(CurrentMenu)

                local Hovered = false;
                local LeftBadgeOffset = ((Style.LeftBadge == RageUI.BadgeStyle.None) and 0 or 27)
                local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None) or (not Enabled and Style.LockBadge ~= RageUI.BadgeStyle.None)
                local RightBadgeOffset = ((Style.RightBadge == RageUI.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
                local RightOffset = 0
                ---@type boolean
                -- if CurrentMenu.EnableMouse == true and (CurrentMenu.CursorStyle == 0) or (CurrentMenu.CursorStyle == 1) then
                --     Hovered = RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                -- end

                local ListText = (type(Items[Index]) == "table") and string.format("← %s%s/%s~s~ →", Shared:ServerColor(), Items[Index].value, #Items) or string.format("← %s%s/%s~s~ →", Shared:ServerColor(), Items[Index], #Items) or "undefined"

                if Selected then
                    RenderRectangle(CurrentMenu.X+10, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width-20 + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, 21, 25, 31, 255)
                    RenderRectangle(CurrentMenu.X+10, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width-487 + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, CurrentMenu.ButtonColor.R, CurrentMenu.ButtonColor.G, CurrentMenu.ButtonColor.B, CurrentMenu.ButtonColor.A)
                else
                    RenderRectangle(CurrentMenu.X+10, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width-20 + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, 21, 25, 31, 255)
                end
                if Enabled == true or Enabled == nil then
                    if Selected then
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 255, 255, 255, 255, 2)
                            RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.30)
                        end
                    else
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.30)
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 255, 255, 255, 150, 2)
                        end
                    end
                end
                RightOffset = RightBadgeOffset * 1.0 + RightOffset
                if Enabled == true or Enabled == nil then
                    if Selected then
                        ListText = (type(Items[Index]) == "table") and string.format("← %s%s~s~ →", Shared:ServerColor(), Items[Index].value) or (type(Items[Index]) == "number") and string.format("← %s%s/%s~s~ →", Shared:ServerColor(), Items[Index], #Items) or (type(Items[Index]) == "string") and string.format("← %s%s~s~ →", Shared:ServerColor(), Items[Index]) or "undefined"
                        RenderText(Label, CurrentMenu.X - 3 + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 255, 255, 255, 255)
                        RenderText(ListText, CurrentMenu.X - 15 + SettingsList.Text.X + 20 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsList.Text.Scale, 255, 255, 255, 255, 2)
                    else
                        ListText = (type(Items[Index]) == "table") and string.format("← %s%s~s~ →", Shared:ServerColor(), Items[Index].value) or (type(Items[Index]) == "number") and string.format("← %s%s/%s~s~ →", Shared:ServerColor(), Items[Index], #Items) or (type(Items[Index]) == "string") and string.format("← %s%s~s~ →", Shared:ServerColor(), Items[Index]) or "undefined"
                        RenderText(Label, CurrentMenu.X - 3 + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 255, 255, 255, 150)
                        RenderText(ListText, CurrentMenu.X - 15 + SettingsList.Text.X + 20 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsList.Text.Scale, 255, 255, 255, 150, 2)
                    end
                else

                    if haveRightBadge then
                        local RightBadge = RageUI.BadgeStyle.Lock(Active)
                        RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                    end

                    RenderText(Label, CurrentMenu.X + SettingsButton.Text.X - 10 + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 255, 255, 255, 150)

                end

                if type(Style) == "table" then
                    if Style.Enabled == true or Style.Enabled == nil then
                        if type(Style) == 'table' then
                            if Style.RightBadge ~= nil then
                                if Style.RightBadge ~= RageUI.BadgeStyle.None then
                                    local BadgeData = Style.RightBadge(Selected)

                                    RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end
                        end
                    else
                        ---@type table
                        local LeftBadge = RageUI.BadgeStyle.Lock
                        ---@type number
                        if LeftBadge ~= RageUI.BadgeStyle.None and LeftBadge ~= nil then
                            local BadgeData = LeftBadge(Selected)

                            RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
                        end
                    end
                else
                    error("UICheckBox Style is not a `table`")
                end

                -- LeftArrowHovered = RageUI.IsMouseInBounds(CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset - RightOffset + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 2.5  + CurrentMenu.SafeZoneSize.Y , 15, 22.5)

                -- RightArrowHovered = RageUI.IsMouseInBounds(CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset + CurrentMenu.SafeZoneSize.X - RightOffset - MeasureStringWidth(ListText, 0, SettingsList.Text.Scale), CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 2.5 + CurrentMenu.SafeZoneSize.Y , 15, 22.5)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height + 3

                RageUI.ItemsDescription(CurrentMenu, Description, Selected);

                if Enabled == true or Enabled == nil then
                    if Selected and (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) and not (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) then
                        Index = Index - 1
                        if Index < 1 then
                            Index = #Items
                        end
                        if (Actions.onListChange ~= nil) then
                            Actions.onListChange(Index, Items[Index]);
                        end
                        local Audio = RageUI.Settings.Audio
                        RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
                    elseif Selected and (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) and not (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) then
                        Index = Index + 1
                        if Index > #Items then
                            Index = 1
                        end
                        if (Actions.onListChange ~= nil) then
                            Actions.onListChange(Index, Items[Index]);
                        end
                        local Audio = RageUI.Settings.Audio
                        RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
                    end

                    if Selected and (CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and (not LeftArrowHovered and not RightArrowHovered))) then
                        local Audio = RageUI.Settings.Audio
                        RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

                        if (Actions.onSelected ~= nil) then
                            Actions.onSelected(Index, Items[Index]);
                        end

                        if Submenu ~= nil and type(Submenu) == "table" then
                            if condition == true or condition == nil then
                                RageUI.NextMenu = Submenu.id and Submenu or Submenu[Index]
                            end
                        end
                    elseif Selected then
                        if(Actions.onActive ~= nil) then
                            Actions.onActive()
                        end 
                    end
                end
            end

            RageUI.Options = RageUI.Options + 1
        end
    end
end