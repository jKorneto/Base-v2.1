fx_version "cerulean"
game "gta5"

author "Fowlmas"
github "https://github.com/Fowlmas"
version "1.0.0"
lua54 "yes"

ui_page "index.html"

files({
    "assets/**/**/*.*",
    "index.html"
})

client_scripts {
    "exports/client.lua"
}

server_scripts {
    "exports/server.lua"
}