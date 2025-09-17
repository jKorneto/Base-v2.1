---@class ShopStaticData
---@field shopName string
---@field items ShopItem[]
---@field blip? { sprite: number; colour:number; scale:number; }
---@field locations { x: number; y:number; z:number; }[]
---@field peds? { modelName: string; scenario?:string; coords: vector3; heading:number; }[]

---@type { [string]: ShopStaticData }
local Module <const> = {
    -- ["General"] = {
    --     shopName = "General Shop",
    --     items = {
    --         { name = "gold",   price = 200 },
    --         { name = "cognac", price = 100 }
    --     },
    --     blip = {
    --         sprite = 52,
    --         colour = 69,
    --         scale = 0.8
    --     },
    --     locations = {
    --         vector3(223.832962, -792.619751, 30.695190)
    --     },
    --     peds = {
    --         {
    --             modelName = "mp_m_shopkeep_01",
    --             scenario = 'WORLD_HUMAN_AA_COFFEE',
    --             coords = vec3(223.832962, -792.619751, 31.0),
    --             heading = 270.311,
    --         },
    --     }
    -- }
}

ScriptShared.Shops = Module
