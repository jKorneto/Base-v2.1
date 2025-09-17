local Module = {}
---@type table<string, RegisteredItemData>
Module.Registered = {}

ScriptShared.Items = Module

---@param name string
function Module:Get(name)
    return self.Registered[name]
end

---@param name string
---@param d RegisteredItemData
function Module:Add(name, d)
    self.Registered[name] = d
end
