QBShared = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

QBShared.RandomStr = function(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return QBShared.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

QBShared.RandomInt = function(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return QBShared.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

QBShared.SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

QBShared.Items = {
	-- // WEAPONS
	[1] 	= {["name"] = "weapon_unarmed", 		 	  ["label"] = "Handen", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[2] 	= {["name"] = "weapon_knife", 			 	  ["label"] = "Mes", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[3] 	= {["name"] = "weapon_nightstick", 		 	  ["label"] = "Nightstick", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[4] 	= {["name"] = "weapon_hammer", 			 	  ["label"] = "Hamer", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[5] 	= {["name"] = "weapon_bat", 			 	  ["label"] = "Knuppel", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[6] 	= {["name"] = "weapon_golfclub", 		 	  ["label"] = "Golfclub", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[7] 	= {["name"] = "weapon_crowbar", 		 	  ["label"] = "Breekijzer", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[8] 	= {["name"] = "weapon_pistol", 			 	  ["label"] = "Pistol", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[9] 	= {["name"] = "weapon_combatpistol", 	 	  ["label"] = "Combat Pistol", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[10] 	= {["name"] = "weapon_appistol", 		 	  ["label"] = "AP Pistol", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[11] 	= {["name"] = "weapon_pistol50", 		 	  ["label"] = "Pistol .50 Cal", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[12] 	= {["name"] = "weapon_microsmg", 		 	  ["label"] = "Micro SMG", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[13] 	= {["name"] = "weapon_smg", 			 	  ["label"] = "SMG", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[14] 	= {["name"] = "weapon_assaultsmg", 		 	  ["label"] = "Assault SMG", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[15] 	= {["name"] = "weapon_assaultrifle", 	 	  ["label"] = "Assault Rifle", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[16] 	= {["name"] = "weapon_carbinerifle", 	 	  ["label"] = "Carbine Rifle", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[17] 	= {["name"] = "weapon_advancedrifle", 	 	  ["label"] = "Advanced Rifle", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[18] 	= {["name"] = "weapon_mg", 				 	  ["label"] = "Machinegun", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[19] 	= {["name"] = "weapon_combatmg", 		 	  ["label"] = "Combat MG", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[20] 	= {["name"] = "weapon_pumpshotgun", 	 	  ["label"] = "Pump Shotgun", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[21] 	= {["name"] = "weapon_sawnoffshotgun", 	 	  ["label"] = "Sawn-off Shotgun", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[22] 	= {["name"] = "weapon_assaultshotgun", 	 	  ["label"] = "Assault Shotgun", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[23] 	= {["name"] = "weapon_bullpupshotgun", 	 	  ["label"] = "Bullpup Shotgun", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[24] 	= {["name"] = "weapon_stungun", 		 	  ["label"] = "Taser", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[25] 	= {["name"] = "weapon_sniperrifle", 	 	  ["label"] = "Sniper Rifle", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[26] 	= {["name"] = "weapon_heavysniper", 	 	  ["label"] = "Heavy Sniper", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[27] 	= {["name"] = "weapon_remotesniper", 	 	  ["label"] = "Remote Sniper", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[28] 	= {["name"] = "weapon_grenadelauncher", 	  ["label"] = "Grenade Launcher", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[29] 	= {["name"] = "weapon_grenadelauncher_smoke", ["label"] = "Smoke Grenade Launcher", ["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[30] 	= {["name"] = "weapon_rpg", 			      ["label"] = "RPG", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[31] 	= {["name"] = "weapon_minigun", 		      ["label"] = "Minigun", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[32] 	= {["name"] = "weapon_grenade", 		      ["label"] = "Grenade", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[33] 	= {["name"] = "weapon_stickybomb", 		      ["label"] = "C4", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[34] 	= {["name"] = "weapon_smokegrenade", 	      ["label"] = "Rookbom", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[35] 	= {["name"] = "weapon_bzgas", 			      ["label"] = "BZ Gas", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[36] 	= {["name"] = "weapon_molotov", 		      ["label"] = "Molotov", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[37] 	= {["name"] = "weapon_fireextinguisher",      ["label"] = "Brandblusser", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[38] 	= {["name"] = "weapon_petrolcan", 		 	  ["label"] = "Benzineblik", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[39] 	= {["name"] = "weapon_briefcase", 		 	  ["label"] = "Koffer", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[40] 	= {["name"] = "weapon_briefcase_02", 	 	  ["label"] = "Koffer", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[41] 	= {["name"] = "weapon_ball", 			 	  ["label"] = "Bal", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[42] 	= {["name"] = "weapon_flare", 			 	  ["label"] = "Flare pistol", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[43] 	= {["name"] = "weapon_snspistol", 		 	  ["label"] = "SNS Pistol", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[44] 	= {["name"] = "weapon_bottle", 			 	  ["label"] = "Gebroken fles", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[45] 	= {["name"] = "weapon_gusenberg", 		 	  ["label"] = "Thompson SMG", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[46] 	= {["name"] = "weapon_specialcarbine", 	 	  ["label"] = "Special Carbine", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[47] 	= {["name"] = "weapon_heavypistol", 	 	  ["label"] = "Heavy Pistol", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[48] 	= {["name"] = "weapon_bullpuprifle", 	 	  ["label"] = "Bullpup Rifle", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[49] 	= {["name"] = "weapon_dagger", 			 	  ["label"] = "Dagger", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[50] 	= {["name"] = "weapon_vintagepistol", 	 	  ["label"] = "Vintage Pistol", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[51] 	= {["name"] = "weapon_firework", 		 	  ["label"] = "Firework Launcher", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[52] 	= {["name"] = "weapon_musket", 			 	  ["label"] = "Musket", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[53] 	= {["name"] = "weapon_heavyshotgun", 	 	  ["label"] = "Heavy Shotgun", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[54] 	= {["name"] = "weapon_marksmanrifle", 	 	  ["label"] = "Marksman Rifle", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[55] 	= {["name"] = "weapon_hominglauncher", 	 	  ["label"] = "Homing Launcher", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[56] 	= {["name"] = "weapon_proxmine", 		 	  ["label"] = "Proxmine Grenade", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[57] 	= {["name"] = "weapon_snowball", 		 	  ["label"] = "Sneeuwbal", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[58] 	= {["name"] = "weapon_flaregun", 		 	  ["label"] = "Flare Gun", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[59] 	= {["name"] = "weapon_garbagebag", 		 	  ["label"] = "Vuilniszak", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[60] 	= {["name"] = "weapon_handcuffs", 		 	  ["label"] = "Handboeien", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[61] 	= {["name"] = "weapon_combatpdw", 		 	  ["label"] = "Combat PDW", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[62] 	= {["name"] = "weapon_marksmanpistol", 	 	  ["label"] = "Marksman Pistol", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[63] 	= {["name"] = "weapon_knuckle", 		 	  ["label"] = "Boksbeugel", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[64] 	= {["name"] = "weapon_hatchet", 		 	  ["label"] = "Hakbijl", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[65] 	= {["name"] = "weapon_railgun", 		 	  ["label"] = "Railgun", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[66] 	= {["name"] = "weapon_machete", 		 	  ["label"] = "Machete", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[67] 	= {["name"] = "weapon_machinepistol", 	 	  ["label"] = "Tec-9", 					["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[68] 	= {["name"] = "weapon_switchblade", 	 	  ["label"] = "Switchblade", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[69] 	= {["name"] = "weapon_revolver", 		 	  ["label"] = "Revolver", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[70] 	= {["name"] = "weapon_dbshotgun", 		 	  ["label"] = "Double-barrel Shotgun", 	["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[71] 	= {["name"] = "weapon_compactrifle", 	 	  ["label"] = "Compact Rifle", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[72] 	= {["name"] = "weapon_autoshotgun", 	 	  ["label"] = "Auto Shotgun", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[73] 	= {["name"] = "weapon_battleaxe", 		 	  ["label"] = "Battle Axe", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[74] 	= {["name"] = "weapon_compactlauncher",  	  ["label"] = "Compact Launcher", 		["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[75] 	= {["name"] = "weapon_minismg", 		 	  ["label"] = "Mini SMG", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[76] 	= {["name"] = "weapon_pipebomb", 		 	  ["label"] = "Pipe bom", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[77] 	= {["name"] = "weapon_poolcue", 		 	  ["label"] = "Poolcue", 				["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	[78] 	= {["name"] = "weapon_wrench", 			 	  ["label"] = "Moersleutel", 			["weight"] = 1000, 		["type"] = "weapon", 	["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = false, 	["description"] = "This is a placeholder description"},
	-- // ITEMS //
	[79] 	= {["name"] = "id_card", 			 	  	  ["label"] = "Identiteitskaart", 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = true, 	["description"] = "This is a placeholder description"},
	[80] 	= {["name"] = "driver_license", 			  ["label"] = "Rijbewijs", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "placeholder.png", 		["unique"] = true, 		["useable"] = true, 	["description"] = "This is a placeholder description"},
	[81] 	= {["name"] = "tosti", 			 	  	  	  ["label"] = "Tosti", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "tosti.png", 			["unique"] = false, 	["useable"] = true, 	["description"] = "This is a placeholder description"},
	[82] 	= {["name"] = "water_bottle", 			  	  ["label"] = "Flesje water 500ml", 	["weight"] = 500, 		["type"] = "item", 		["image"] = "placeholder.png", 		["unique"] = false, 	["useable"] = true, 	["description"] = "This is a placeholder description"},
	[83] 	= {["name"] = "joint", 			  	  		  ["label"] = "Joint", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "placeholder.png", 		["unique"] = false, 	["useable"] = true, 	["description"] = "This is a placeholder description"},
	[84] 	= {["name"] = "plastic", 			  	  	  ["label"] = "Plastic", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "placeholder.png", 		["unique"] = false, 	["useable"] = false, 	["description"] = "This is a placeholder description"},
	[85] 	= {["name"] = "metalscrap", 			  	  ["label"] = "Metaalschoot", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "placeholder.png", 		["unique"] = false, 	["useable"] = false, 	["description"] = "This is a placeholder description"},
}