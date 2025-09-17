---@alias InventoryTypes "base" | "player" | "glovebox" | "trunk" | "stash" | "faction" | "dropped_grid" | "chest"

---@class InventoryItem
---@field name string
---@field quantity number
---@field slot number
---@field itemHash string
---@field meta InventoryItemMetaData
---@field data RegisteredItemData
---@field coordX number
---@field coordY number
---@field coordZ number

---@class InventoryItemMetaData
---@field durability? number
---@field note? string
---@field customName? string
---@field customImage? string
---@field serial? string
---@field attachments? string[]

---@class findByOptions
---@field name? string
---@field quantity? number
---@field itemHash? string
---@field slot? number
---@field meta? InventoryItemMetaData

---@class RegisteredItemData
---@field label string
---@field tradable boolean
---@field deletable boolean
---@field stackable boolean
---@field description string
---@field weight number
---@field category string
---@field defaultMeta InventoryItemMetaData
---@field usable boolean
---@field droppedModel string
---@field weaponHash number | string
---@field allowedAttachments string[]
---@field generateSerial boolean
---@field server? { export?: string; onUseDeleteAmount?:number; }

---@class ShopItem
---@field name string
---@field price number
---@field meta? InventoryItemMetaData
---@field data RegisteredItemData

---@class DB_Inventory
---@field uniqueID string
---@field type InventoryTypes
---@field items InventoryItem[]

---@class EmoteTable
---@field dict string
---@field anim string
---@field flag number
---@field time number

---@class CraftItem
---@field name string
---@field quantity number
---@field meta? InventoryItemMetaData
---@field data RegisteredItemData
---@field ingredients { name:string; label:string; quantity:number; }[]
