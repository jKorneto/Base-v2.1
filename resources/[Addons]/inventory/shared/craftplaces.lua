---@class CraftingPlaceStaticData
---@field craftPlaceName string
---@field items { name:string; quantity: number; meta: InventoryItemMetaData; ingredients: { name:string; quantity:number; }[] }[]
---@field blip? { sprite:number; colour:number; scale:number; }
---@field peds? { modelName:string; scenario?: string; coords?: vector3; heading: number; }[]
---@field locations? { range:number; coords: vector3; }[]

---@type CraftingPlaceStaticData[]
local Module <const> = {
    {
        craftPlaceName = "General Crafting",
        items = {
            {
                name = "gold",
                ingredients = {
                    {
                        name = "cognac",
                        quantity = 3,
                    },
                    {
                        name = "apple",
                        quantity = 5
                    }
                },
                quantity = 5,
                meta = {
                    customName = "Gold (crafted)"
                }
            }
        },
        blip = {
            sprite = 52,
            colour = 69,
            scale = 0.8
        },
        locations = {
            {
                range = 5.0,
                coords = vector3(-60.20, 217.59, 106.55)
            }
        },
        peds = {
            {
                modelName = "mp_m_shopkeep_01",
                scenario = 'WORLD_HUMAN_AA_COFFEE',
                coords = vec3(223.832962, -792.619751, 31.0),
                heading = 270.311,
            },
        }
    }
}

ScriptShared.CraftPlaces = Module
