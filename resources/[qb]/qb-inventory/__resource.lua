resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Qbus:Inventory'

server_scripts {
	"config.lua",
	"server/main.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
	'html/images/placeholder.png',
	'html/images/tosti.png',
	'html/images/joint.png',
	'html/images/metalscrap.png',
	'html/images/copper.png',
	'html/images/pistol_ammo.png',
	'html/images/combatpistol.png',
	'html/images/id_card.png',
}