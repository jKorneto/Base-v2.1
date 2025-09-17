---@overload fun(): VipListener
VipListener = Class.new(function(class)
    ---@class VipListener: BaseObject
    local self = class
    local vipData = {}

    function self:setVipData(data)
        if (type(data) == "table") then
            vipData = data
        end
    end

    function self:isPlayerVip()
        return next(vipData) ~= nil and true or false
    end

    function self:getExpiration()
        return vipData.expiration or "no_data"
    end

    function self:getBuyDate()
        return vipData.buyDate or "no_data"
    end

    return self
end)