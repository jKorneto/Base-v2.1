---@type Table
Table = Class.new(function(class) 

    ---@class Table: BaseObject
    local self = class

    ---@param table table
    ---@return number
    function self:SizeOf(table)
        local size = 0

        for _, data in pairs(table) do
            if (data ~= nil) then
                size = size + 1
            end
        end

        return size
    end

    function self:TableContains(table, element)
        for index, value in pairs(table) do
            if value == element then
                return true, index
            end
        end

        return false
    end

    ---@param full_object table
    function self:Dump(full_object)
        local visited = {}
        local buffer = {}
        local table_insert = table.insert
    
        local function DumpRecursive(object, indentation)
            local object_type = type(object)
    
            if (object_type == 'table' and not visited[object]) then
                local object_metatable = getmetatable(object)

                if (object_metatable) then
                    DumpRecursive(object_metatable, 0)
                end

                visited[object] = true

                local keys = {}
    
                for key, v in pairs(object) do
                    table_insert(keys, key)
                end
    
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
    
                indentation = indentation + 1
                table_insert(buffer, indentation == 1 and "\n{" or "{")

                for k, key in ipairs(keys) do
                    local formatted_key = type(key) == "number" and tostring(key) or '"' .. tostring(key) .. '"'

                    table_insert(buffer, "\n" .. string.rep(" ", indentation * 4) .. formatted_key .. " = ")
                    DumpRecursive(object[key], indentation)
                    table_insert(buffer, ",")
                end

                indentation = indentation - 1
                table_insert(buffer, "\n" .. string.rep(" ", indentation * 4) .. "}")
            elseif (object_type == "string") then
                table_insert(buffer, '"' .. tostring(object) .. '"')
            else
                table_insert(buffer, tostring(object))
            end
        end

        DumpRecursive(full_object, 0)

        return table.concat(buffer)
    end

    return self
end)