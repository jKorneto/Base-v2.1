fx_version "adamant"
game "gta5"
version "1.23"
lua54 "yes"

ui_page "html/index.html"

shared_scripts {
    "@Framework/imports.lua", 
    "config.lua",
    "shared/shared.lua",
    "shared/items/register.lua",
    "shared/items/items.lua",
    "shared/items/weapons.lua",
    "shared/shops.lua",
    "shared/craftplaces.lua",
    "shared_exports.lua",
}

server_scripts {
    "server/server.lua",
    "server/events.lua",
    "server/inventories/*.lua",
    "server/classes/*.lua",
    "server/classes/subclasses/*.lua",
    "server/shops/sv_shops.lua",
    "server/shops/sv_shops_class.lua",
    "server/craftings/sv_craftplaces.lua",
    "server/craftings/sv_craftplace_class.lua",
    "server_exports.lua",
    "server/frameworks/*.lua",
}

client_scripts {
    "client/client.lua",
    "client/events.lua",
    "client/vehicles/cl_vehicles.lua",
    "client/shops/cl_shops.lua",
    "client/craftplaces/cl_craftplaces.lua",
    "client/faction/cl_factions.lua",
    "client/chest/cl_chest.lua",
    "client/clothes/cl_clothes_variations.lua",
    "client/clothes/cl_clothes.lua",
    "client/clothes/cl_class_variation.lua",
    "client/clothes/cl_class_takeoff.lua",
    "client/pedscreen/client.lua",
    "client/settings/client.lua",
    "client/player/cl_player_slots.lua",
    "client/player/cl_player_inventory.lua",
    "client/player/cl_player_weapon.lua",
    "client_exports.lua",
}

files {
    "html/**",
}

dependencies {
    "/server:4752",
    "/onesync"
}