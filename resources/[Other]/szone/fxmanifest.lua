fx_version "cerulean"
game "gta5"

author "Fowlmas"
version "1.0.0"
lua54 "yes"

ui_page {
	'Html/index.html'
}

client_scripts {
    "Modules/client/**/*.lua",
}

files({
    "Html/*.html",
    "Html/assets/**/**/*.*",
})