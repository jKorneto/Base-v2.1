---groupDigits
---@param digits number
---@return string
---@public
function API_Maths:groupDigits(digits)
    local left , num , right  = string.match(digits, "^([^%d]*%d)(%d*)(.-)$")
    return (tostring(left .. (num:reverse():gsub("(%d%d%d)", "%1 "):reverse()) .. right))
end
