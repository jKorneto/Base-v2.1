local SettingsButton = {
    Rectangle = { Y = 0, Width = 491, Height = 38 },
    Text = { X = 42, Y = 16, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 456, Y = 4, Width = 30, Height = 30 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 491, Height = 38 },
}

function RageUIClothes.Line()
    local CurrentMenu = RageUIClothes.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu then
            local Option = RageUIClothes.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderSprite("RageUILine", "UILine", CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIClothes.ItemOffset, 400, 4, 255, CurrentMenu.ButtonColor.R, CurrentMenu.ButtonColor.G, CurrentMenu.ButtonColor.B, CurrentMenu.ButtonColor.A)
                RageUIClothes.ItemOffset = RageUIClothes.ItemOffset + SettingsButton.Rectangle.Height + 0
                if (CurrentMenu.Index == Option) then
                    if (RageUIClothes.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUIClothes.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUIClothes.Options = RageUIClothes.Options + 1
        end
    end
end