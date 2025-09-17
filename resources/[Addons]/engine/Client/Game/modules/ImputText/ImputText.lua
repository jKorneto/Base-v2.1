---@overload fun(): ImputText
ImputText = Class.new(function(class)
    ---@class ImputText: BaseObject
    local self = class

    function self:Constructor()
        Shared:Initialized("Game.ImputText")
    end

    ---KeyboardImput
    ---@param title string
    ---@param rows string[]
    function self:KeyboardImput(title, rows, options)
        return lib.inputDialog(title or "Title", rows or {""}, options)
    end

    ---InputIsValid
    ---@param input string
    ---@param inputType "string" | "number" | "date" | "boolean"
    function self:InputIsValid(input, inputType)
        if (input and input ~= "") then
            if (inputType == "string") then
                return true;
            elseif (inputType == "number") then
                if (tonumber(input) and (input):match("^%-?%d+$")) then
                    return true;
                end
            elseif (inputType == "date") then
                if (tostring(input) and (input):match("^%d%d/%d%d/%d%d%d%d$")) then
                    return true;
                end
            elseif (inputType == "boolean") then
                if (
                    input == "1"
                        or input == "0"
                        or input == "true"
                        or input == "false"
                ) then
                    return true;
                end
            end
        end
    end

    return self
end)