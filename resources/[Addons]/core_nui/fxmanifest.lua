fx_version "cerulean"
game "gta5"

lua54 "yes"
use_fxv2_oal "yes"

author "Mystere"
description "core_nui By Mystere"

-- RageUI
client_scripts {
    'libs/Font/importFont.lua',
    'libs/RageUI/config.lua',
    'libs/RageUI/init.lua',
    'libs/RageUI/menu/RageUI.lua',
    'libs/RageUI/menu/Menu.lua',
    'libs/RageUI/menu/MenuController.lua',
    'libs/RageUI/components/*.lua',
    'libs/RageUI/menu/elements/*.lua',
    'libs/RageUI/menu/items/*.lua',
    'libs/RageUI/menu/panels/*.lua',
    'libs/RageUI/menu/windows/*.lua',
}

shared_scripts {
    -- OxLib Require
    "@ox_lib/init.lua",

    -- core_nui Require
    "imports.lua",

    -- core_nui Config
    "src/config/config.lua",

    -- core_nui API
    "src/api/**/_define.lua",
    "src/api/**/shared/*.lua",

    -- core_nui Class
    "src/class/exportMetatable.lua",

    -- core_nui modules
    "src/modules/**/_define.lua",
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',

    "init/sv_main.lua",

    -- core_nui Core
    "src/core/**/server/*.lua",
    "src/core/**/server/events/*.lua",
    "src/core/**/server/functions/*.lua",

    -- core_nui Class
    "src/class/**/server/_constructor.lua",
    "src/class/**/server/functions/**/*.lua",

    -- core_nui modules
    'src/modules/**/server/*.lua',
    "src/modules/**/server/functions/**/*.lua",
    'src/modules/**/server/events/**/*.lua',
    'src/modules/**/server/exports/**/*.lua',

    -- core_nui addons
    'src/addons/**/server/**',
}

client_scripts {
    "init/cl_main.lua",
    
    -- core_nui API
    "src/api/**/client/*.lua",

    -- core_nui Core
    "src/core/client/*.lua",

    -- core_nui Class
    "src/class/**/client/_constructor.lua",
    "src/class/**/client/functions/**/*.lua",
    "src/class/**/client/tasks/**/*.lua",

    -- core_nui modules
	'src/modules/main.lua',

    "src/modules/**/client/*.lua",
    "src/modules/**/client/functions/**/*.lua",
    "src/modules/**/client/events/**/*.lua",
    "src/modules/**/client/tasks/*.lua",
    'src/modules/**/client/exports/**/*.lua',
    
    -- core_nui Menus
    "src/addons/**/menus/**/main.lua",

    -- core_nui addons
    'src/addons/**/client/**',
}



ui_page 'html/index.html'
files {
	'html/index.html',

	'html/sound/*.ogg',

	'html/static/css/*.css',
	'html/static/js/*.js',

	-- IMG
	'html/static/img/**/*.png',
	-- 'html/static/img/**/*.jpg',

	'html/static/fonts/*.woff',
	'html/static/fonts/*.woff2',
	'html/static/fonts/*.ttf',

    -- core_nui SubMenu
    "src/addons/**/menus/**/submenus/**/*.lua",

    -- core_nui Enums
    "src/enums/**"
}

escrow_ignore {
    "src/enums/**",
    "import.lua",
    "src/addons/**/menus/**/submenus/**/*.lua",
    "src/addons/**/menus/**/main.lua",
}