lua54 "yes"

fx_version('bodacious')
game('gta5')

-- ui_page('lscreen/index.html')

-- loadscreen "lscreen/index.html"
-- loadscreen_manual_shutdown "yes"

-- files {
--     "lscreen/index.html",
--     "lscreen/main.css",
--     "lscreen/img/background.png",
--     "lscreen/music/song.mp3",
--     "lscreen/main.js"
-- }

shared_script {
	'locale/locale.lua',
	'locale/lang/fr.lua',
	
	'config/config.lua',
	'config/config.weapons.lua',
}

server_scripts {
	'libs/async.lua',
	'@mysql-async/lib/MySQL.lua',

	'server/common.lua',
	'server/classes/groups.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	
	'common/modules/Logs.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
}

client_scripts {
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',

	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	-- 'client/modules/spawnMass.lua',
	
	'common/modules/Logs.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',

	'imports.lua',
}