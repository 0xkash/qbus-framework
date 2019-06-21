resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Qbus:Hud'

server_scripts {
	"config.lua",
	"server/money.lua",
}

client_scripts {
	"config.lua",
	"client/money.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
}