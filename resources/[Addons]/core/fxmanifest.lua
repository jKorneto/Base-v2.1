fx_version "cerulean"
game "gta5"

author "iZeyy"
description "This resource was created for OneLife"

version "1.1.0"
lua54 "yes"

loadscreen("Web/index.html")
loadscreen_manual_shutdown "yes"

files {
    "Web/index.html",
    "Web/*.*",
}

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
    "Config/*.lua",
    "Shared/Classes/BaseObject.lua",
    "Shared/Classes/Class.lua",
    "Shared/Utils/**/**",
    "Shared/Index.lua",
    "Shared/Enums/**/**",
    "Modules/**/enums/*.lua",
    'Shared/exports/**/**',
    "Locales/**/*.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "webhook.lua",
    "Utils/Server/**/*.lua",
    "Modules/**/server/*.lua"
}

client_scripts {
    "Utils/Font/importFont.lua",
    "Utils/RageUI/init.lua",
    "Utils/RageUI/menu/RageUI.lua",
    "Utils/RageUI/menu/Menu.lua",
    "Utils/RageUI/menu/MenuController.lua",
    "Utils/RageUI/components/*.lua",
    "Utils/RageUI/menu/elements/*.lua",
    "Utils/RageUI/menu/items/*.lua",
    "Utils/RageUI/menu/panels/*.lua",
    "Utils/RageUI/menu/windows/*.lua",
    "Utils/ContextUI/src/components/*.lua",
    "Utils/ContextUI/src/ContextUI.lua",
    "Utils/DrawUI/DrawUI.lua",
};

client_scripts {
    'Utils/client.lua',
    'Utils/Game/modules/**/**',
    'Utils/Game/Game.lua',
    'Utils/Game/UI/index.lua',
    'Utils/Game/UI/components/**',
    'Utils/Game/UI/progressbar/**',
    'Utils/Player/**/**',
    "Modules/**/client/*.lua", 
}