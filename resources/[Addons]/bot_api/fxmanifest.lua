fx_version 'adamant'
game 'gta5'
lua54 'yes'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/server.js",

    "server/lua/init.lua",
    "server/lua/main.lua",
    "server/lua/commands/**/*.lua",
}