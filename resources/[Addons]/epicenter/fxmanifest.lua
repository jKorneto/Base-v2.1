fx_version "adamant"

game "gta5"
lua54 'yes'


ui_page 'web/index.html'

files {
    'web/index.html',
    'web/main.js',
}

shared_script "@ox_lib/init.lua"

client_scripts {
    'vendors/importFont.lua',
    'vendors/RageUI/RMenu.lua',
    'vendors/RageUI/menu/RageUI.lua',
    'vendors/RageUI/menu/Menu.lua',
    'vendors/RageUI/menu/MenuController.lua',
    'vendors/RageUI/components/*.lua',
    'vendors/RageUI/menu/elements/*.lua',
    'vendors/RageUI/menu/items/*.lua',
    'vendors/RageUI/menu/panels/*.lua',
    'vendors/RageUI/menu/panels/*.lua',
    'vendors/RageUI/menu/windows/*.lua',
    
    "vendors/RageUIPolice/RMenu.lua",
	"vendors/RageUIPolice/menu/RageUI.lua",
	"vendors/RageUIPolice/menu/Menu.lua",
	"vendors/RageUIPolice/menu/MenuController.lua",
	"vendors/RageUIPolice/components/*.lua",
	"vendors/RageUIPolice/menu/elements/*.lua",
	"vendors/RageUIPolice/menu/items/*.lua",
	"vendors/RageUIPolice/menu/panels/*.lua",
	"vendors/RageUIPolice/menu/panels/*.lua",
	"vendors/RageUIPolice/menu/windows/*.lua",

	'vendors/RageUIv1/RMenu.lua',
	'vendors/RageUIv1/menu/RageUI.lua',
	'vendors/RageUIv1/menu/Menu.lua',
	'vendors/RageUIv1/menu/MenuController.lua',
	'vendors/RageUIv1/components/*.lua',
	'vendors/RageUIv1/menu/elements/*.lua',
	'vendors/RageUIv1/menu/items/*.lua',
	'vendors/RageUIv1/menu/panels/*.lua',
	'vendors/RageUIv1/menu/panels/*.lua',
	'vendors/RageUIv1/menu/windows/*.lua',

    "vendors/*.lua",
    
    'shared/clotheshop/src/libs/RageUI/RMenu.lua',
    'shared/clotheshop/src/libs/RageUI/menu/RageUI.lua',
    'shared/clotheshop/src/libs/RageUI/menu/Menu.lua',
    'shared/clotheshop/src/libs/RageUI/menu/MenuController.lua',
    'shared/clotheshop/src/libs/RageUI/components/*.lua',
    'shared/clotheshop/src/libs/RageUI/menu/elements/*.lua',
    'shared/clotheshop/src/libs/RageUI/menu/items/*.lua',
    'shared/clotheshop/src/libs/RageUI/menu/panels/*.lua',
    'shared/clotheshop/src/libs/RageUI/menu/windows/*.lua',
}

shared_scripts {
    '@Framework/locale/locale.lua',
	'locales/fr.lua',

    'config/shared/**.lua',
    -- 'shared/clotheshop/configs/cConfig.lua',
    'shared/creator/configs/cConfig.lua',
    'shared/creator/src/translation/*.lua',
}

client_scripts {
    'init/client/*.lua',

    'api/**/client/*.lua',

    'modules/**/**/config/*.lua',
    'modules/**/**/client/*.lua',


    'shared/creator/src/utils.lua',
    'shared/creator/src/client/*.lua',
    'shared/creator/src/client/menu\'s/*.lua',


    -- 'shared/clotheshop/src/utils.lua',
    -- 'shared/clotheshop/data/client/*.lua',
    -- 'shared/clotheshop/src/client/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/server/*.lua',

    'init/server/*.lua',

    'api/**/server/*.lua',

    'modules/**/**/config/*.lua',
    'modules/**/**/server/*.lua',


    'shared/creator/configs/sConfig.lua',
    'shared/creator/src/server/*.lua',
}


exports {
	'GetFuel',
	'SetFuel',
    'IsInMenotte',
    'IsInPorter',
    'IsInTrunk',
    'IsInOtage',
    'IsInStaff',
    'GeneratePlate',
    'AddCountPoliceInService',
    'RemoveCountPoliceInService'
}

-- files {
--     'modules/[Utils]/utils/client/popcycle.dat'
-- }
-- data_file 'POPSCHED_FILE' 'modules/[Utils]/utils/client/popcycle.dat'