local _DrawRect = DrawRect;

---@param x number
---@param y number
---@param width number
---@param height number
---@param color table{r: number, g: number, b: number, a: number}
function HUD.DrawRectangle(x, y, width, height, color)
    local _color = color or {r = 0, g = 0, b = 0, a = 255};
    local _x, _y = HUD.ToResolution(x, y);
    local _width, _height = HUD.ToResolution(width, height);
    _DrawRect(_x, _y, _width, _height, _color.r or 0, _color.g or 0, _color.b or 0, _color.a or 255);
end