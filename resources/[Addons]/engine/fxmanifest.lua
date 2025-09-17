fx_version "cerulean"
game "gta5"

author "Fowlmas"
description "Core for managing player data, events, and server resources in a roleplay environment."
version "0.0.1"
github "https://github.com/Fowlmas"
lua54 "yes"

ui_page "Nui/index.html"

files {
    "Server/JSON/*.json",
    "Nui/assets/**/*.mp3",
    "Nui/index.html",
}

shared_scripts {
    "@ox_lib/init.lua",
    "Config.lua",
    "Shared/Classes/BaseObject.lua",
    "Shared/Classes/Class.lua",
    "Shared/Enums/**/**",
    "Shared/Utils/**/**",
    "Shared/exports/*.lua",
    "Shared/Index.lua",
    -- "Modules/**/Shared/**",
    "Plugins/**/Shared/*.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "Webhooks.lua",
    "Server/Discord/Discord.lua",
    "Server/Server.lua",
    "Server/Player/Events/**",
    "Modules/**/Server/**",
    "Plugins/**/Server/*.lua"
}

---RageUI
client_scripts {
    "Client/Lib/RageUI/importFont.lua",
    "Client/Lib/RageUI/init.lua",
    "Client/Lib/RageUI/menu/RageUI.lua",
    "Client/Lib/RageUI/menu/Menu.lua",
    "Client/Lib/RageUI/menu/MenuController.lua",
    "Client/Lib/RageUI/components/*.lua",
    "Client/Lib/RageUI/menu/elements/*.lua",
    "Client/Lib/RageUI/menu/items/*.lua",
    "Client/Lib/RageUI/menu/panels/*.lua",
    "Client/Lib/RageUI/menu/windows/*.lua",
}

client_scripts {
    "Client/Client.lua",
    "Client/Game/modules/**/*.lua",
    "Client/Game/Game.lua",
    "Client/UI/index.lua",
    "Client/UI/components/**",
    "Client/UI/progressbar/**",
    "Client/Player/**/**",
    "Modules/**/Client/**",
    "Plugins/**/Client/**"
}

escrow_ignore {
    --"Config.lua"
}