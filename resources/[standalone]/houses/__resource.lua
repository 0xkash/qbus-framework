resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "KASH:HOUSES"

client_scripts {
    "client/main.lua",
    "client/decorate.lua",
    "client/callback.lua",
    "SharedConfig.lua",
}

server_scripts {
    "server/main.lua",
    "server/callback.lua",
    "SharedConfig.lua",
}

ui_page {
	'html/ui.html',
}
files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
}