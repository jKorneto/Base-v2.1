local Module = {}
---@type { [string]: DroppedInventory }
Module.Grids = {}

ScriptServer.Managers.Dropped = Module

function Module:loadGrids()
    local dropped_grids = exports["oxmysql"]:query_async("SELECT * FROM inventory_4_items WHERE type = @type", {
        ["@type"] = "dropped_grid"
    })

    for i = 1, #dropped_grids, 1 do
        local v = dropped_grids[i]
        ScriptServer.Classes.DroppedInventory.new({
            originX = v.originX,
            originY = v.originY,
            originZ = v.originZ,
            uniqueID = v.uniqueID,
            inventoryName = 'Au sol',
            slotsAmount = CONFIG.DROPPED_ITEMS.GRID_SLOTS,
            maxWeight = CONFIG.DROPPED_ITEMS.GRID_MAX_WEIGHT,
            expires = v.expires
        })
    end
end

function Module:generateUnique()
    return os.time() .. "-" .. math.random(1, 1000000)
end

function Module:createGrid(x, y, z)
    return ScriptServer.Classes.DroppedInventory.new({
        originX = x,
        originY = y,
        originZ = z,
        uniqueID = "dropped_grid-" .. self:generateUnique(),
        inventoryName = 'Au sol',
        slotsAmount = CONFIG.DROPPED_ITEMS.GRID_SLOTS,
        maxWeight = CONFIG.DROPPED_ITEMS.GRID_MAX_WEIGHT,
        expires = os.time() + CONFIG.DROPPED_ITEMS.REMAIN_ON_GROUND
    })
end

-- This will not create the grid if not exist.
---@param x number
---@param y number
---@param z number
function Module:gridAt(x, y, z)
    local inRange = CONFIG.DROPPED_ITEMS.GRID_RANGE

    for k, v in pairs(self.Grids) do
        local dist = #(vector3(x, y, z) - vector3(v.originX, v.originY, v.originZ))
        if dist < inRange then
            return v
        end
    end
end

function Module:createOrGetGrid(x, y, z)
    ---@type DroppedInventory | nil
    local grid = self:gridAt(x, y, z)

    if not grid then
        grid = self:createGrid(x, y, z)
    end

    return grid
end

function Module:onServerResourceStart()
    self:loadGrids()
end

function Module:onResourceStop()
    local objects = GetAllObjects()
    local count = 0
    for k, v in pairs(objects) do
        if Entity(v).state.dropped_item then
            DeleteEntity(v)
            count = count + 1
        end
    end

    print(string.format("^4Deleted (%d) dropped object(s) on resource stop.", count))
end

function Module:SaveDroppeds()
    for k, v in pairs(self.Grids) do
        v:save()
    end
end

function Module:checkAllExpired()
    for k, v in pairs(self.Grids) do
        v:checkExpired()
    end
end

CreateThread(function()
    while true do
        Module:checkAllExpired()
        Wait(60000 * 10)
    end
end)
