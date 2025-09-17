---@param Title string
---@param LeftText table
---@param RightText table
---@param Index number
---@param startAt number
function Panels:info(Title, LeftText, RightText, Index, startAt)
    local CurrentMenu = RageUI.CurrentMenu
    local LineCount = (RightText and LeftText and type(LeftText) == "table" and Shared.Table:SizeOf(LeftText) >= Shared.Table:SizeOf(RightText) and Shared.Table:SizeOf(LeftText) or type(LeftText) == "table" and Shared.Table:SizeOf(LeftText)) or 1
    if CurrentMenu then
        if (not Index and not startAt) or ((not Index and startAt) and CurrentMenu.Index >= startAt) or ((not startAt and Index) and CurrentMenu.Index == Index) then
            if Title ~= nil then
                RenderText("~h~| " .. Title .. "~h~", 320 + 20 + 171, 7, 0, 0.38, 255, 255, 255, 255, 0)
            end
            if LeftText ~= nil then
                local leftTextString = type(LeftText) == "table" and table.concat(LeftText, "\n") or LeftText
                RenderText("~c~" .. leftTextString, 320 + 20 + 171, Title ~= nil and 43 or 7, 0, 0.22, 255, 255, 255, 255, 0)
            end
            if RightText ~= nil then
                local rightTextString = type(RightText) == "table" and table.concat(RightText, "\n") or RightText
                RenderText(rightTextString, 320 + 420 + 151, Title ~= nil and 43 or 7, 0, 0.22, 255, 255, 255, 255, 2)
            end

            RenderRectangle(320 + 10 + 171, 0, 400, Title ~= nil and 50 + (LineCount * 22), 12, 16, 21, 255)
            RenderRectangle(320 + 10 + 171, 50 + (LineCount * 22), 400, Title ~= nil and 3, CurrentMenu.ButtonColor.R, CurrentMenu.ButtonColor.G, CurrentMenu.ButtonColor.B, CurrentMenu.ButtonColor.A)
        end
    end
end