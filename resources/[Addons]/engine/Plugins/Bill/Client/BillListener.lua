---@overload fun(): BillListener
BillListener = Class.new(function(class)

    ---@class BillListener: BaseObject
    local self = class

    ---@private
    function self:Constructor()
		inBillPrompt = false
    end

	---@return boolean
	function self:isInBillPrompt()
		return inBillPrompt
	end

	function self:setInBillPrompt(state)
		if (type(state) == "boolean") then
			inBillPrompt = state
		end
	end

	function self:refuseBill()
		Shared.Events:ToServer(Engine["Enums"].Bill.Events.refuseBill)
	end

	---@param paymentType  "cash" | "bank"
	function self:acceptBill(paymentType)
		if (type(paymentType) == "string" and (paymentType == "cash" or paymentType == "bank")) then
			Shared.Events:ToServer(Engine["Enums"].Bill.Events.acceptBill, paymentType)
		end
	end

    return self
end)