fx_version 'adamant'
game 'gta5'

author 'iZeyy'
description 'HUD Custom for OneLife'
version '1.0.0'

ui_page "html/Hud.html"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}

files {
    "html/Hud.html",
    "html/static/js/*.js",
    "html/static/css/*.css",
}