---@param Title string
---@param LeftText table
---@param RightText table
---@param Index number
---@param startAt number
function Panels:info(Title, LeftText, RightText, Index, startAt)
    local CurrentMenu = RageUI.CurrentMenu
    local LineCount = (RightText and LeftText and #LeftText >= #RightText and #LeftText or LeftText and #LeftText) or 1
    if CurrentMenu then
        if (not Index and not startAt) or ((not Index and startAt) and CurrentMenu.Index >= startAt) or ((not startAt and Index) and CurrentMenu.Index == Index) then
            if Title ~= nil then
                RenderText("~h~| " .. Title .. "~h~", 320 + 20 + 171, 7, 0, 0.38, 255, 255, 255, 255, 0)
            end
            if LeftText ~= nil then
                local leftTextString = table.concat(LeftText, "\n")
                RenderText("~c~" .. leftTextString, 320 + 20 + 171, Title ~= nil and 43 or 7, 0, 0.22, 255, 255, 255, 255, 0)
            end
            if RightText ~= nil then
                RenderText(table.concat(RightText, "\n"), 320 + 420 + 151, Title ~= nil and 43 or 7, 0, 0.22, 255, 255, 255, 255, 2)
            end
            RenderRectangle(320 + 10 + 171, 0, 400, Title ~= nil and 50 + (LineCount * 23), 12, 16, 21, 255)
            -- Bottom Line
            RenderRectangle(320 + 10 + 171, 50 + (LineCount * 23), 400, Title ~= nil and 3, CurrentMenu.ButtonColor.R, CurrentMenu.ButtonColor.G, CurrentMenu.ButtonColor.B, CurrentMenu.ButtonColor.A)
        end
    end
end