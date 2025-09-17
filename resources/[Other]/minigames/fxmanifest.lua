fx_version 'cerulean'
game 'gta5'

version '0.0.0'
lua54 'yes'

shared_scripts { 'config.lua' }
client_scripts { "client/*" }

files { 'locales/*.json', "web/build/**/*" }

ui_page "web/build/index.html"
