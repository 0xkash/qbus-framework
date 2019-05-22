resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Qbus:Core'

server_scripts {
	"config.lua",
	"shared.lua",
	"server/main.lua",
	"server/functions.lua",
	"server/player.lua",
	"server/loops.lua",
	"server/events.lua",
	"server/debug.lua",
}

client_scripts {
	"config.lua",
	"shared.lua",
	"client/main.lua",
	"client/loops.lua",
	"client/events.lua",
	"client/debug.lua",
}