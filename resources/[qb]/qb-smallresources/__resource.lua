resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description 'QB:Ignore'

server_scripts {
	"server/main.lua",
	"server/trunk.lua",
	"server/consumables.lua",
	"config.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/ignore.lua",
	"client/density.lua",
	"client/weapdraw.lua",
	"client/hudcomponents.lua",
	"client/seatbelt.lua",
	"client/cruise.lua",
	"client/recoil.lua",
	"client/trunk.lua",
	"client/removeentities.lua",
	"client/crouchprone.lua",
	"client/tackle.lua",
	"client/consumables.lua",
	"client/discord.lua",
	"client/point.lua",
	'client/engine.lua',
}

this_is_a_map 'yes'

data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'popgroups.ymt'

files {
    'popgroups.ymt',
}