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

QBShared.Weapons = {
	['weapon_unarmed'] = {label = "Handen", weight = 1000},
	['weapon_knife'] = {label = "Mes", weight = 1000},
	['weapon_nightstick'] = {label = "Wapenstok", weight = 1000},
	['weapon_hammer'] = {label = "Hamer", weight = 1000},
	['weapon_bat'] = {label = "Knuppel", weight = 1000},
	['weapon_golfclub'] = {label = "Golfclub", weight = 1000},
	['weapon_crowbar'] = {label = "Breekijzer", weight = 1000},
	['weapon_pistol'] = {label = "Pistol", weight = 1000},
	['weapon_combatpistol'] = {label = "Combat Pistol", weight = 1000},
	['weapon_appistol'] = {label = "AP Pistol", weight = 1000},
	['weapon_pistol50'] = {label = "Pistol .50 Cal", weight = 1000},
	['weapon_microsmg'] = {label = "Micro SMG", weight = 1000},
	['weapon_smg'] = {label = "SMG", weight = 1000},
	['weapon_assaultsmg'] = {label = "Assault SMG", weight = 1000},
	['weapon_assaultrifle'] = {label = "Assault Rifle", weight = 1000},
	['weapon_carbinerifle'] = {label = "Carbine Rifle", weight = 1000},
	['weapon_advancedrifle'] = {label = "Advanced Rifle", weight = 1000},
	['weapon_mg'] = {label = "Machinegun", weight = 1000},
	['weapon_combatmg'] = {label = "Combat Machinegun", weight = 1000},
	['weapon_pumpshotgun'] = {label = "Pump Shotgun", weight = 1000},
	['weapon_sawnoffshotgun'] = {label = "Sawnoff Shotgun", weight = 1000},
	['weapon_assaultshotgun'] = {label = "Assault Shotgun", weight = 1000},
	['weapon_bullpupshotgun'] = {label = "Bullpup Shotgun", weight = 1000},
	['weapon_stungun'] = {label = "Taser", weight = 1000},
	['weapon_sniperrifle'] = {label = "Sniper rifle", weight = 1000},
	['weapon_heavysniper'] = {label = "Heavy sniper rifle", weight = 1000},
	['weapon_remotesniper'] = {label = "Remote sniper rifle", weight = 1000},
	['weapon_grenadelauncher'] = {label = "Grenade launcher", weight = 1000},
	['weapon_grenadelauncher_smoke'] = {label = "Smoke launcher", weight = 1000},
	['weapon_rpg'] = {label = "RPG", weight = 1000},
	['weapon_minigun'] = {label = "Minigun", weight = 1000},
	['weapon_grenade'] = {label = "Granaat", weight = 1000},
	['weapon_stickybomb'] = {label = "C4", weight = 1000},
	['weapon_smokegrenade'] = {label = "Rookbom", weight = 1000},
	['weapon_bzgas'] = {label = "BZ Gasgranaat", weight = 1000},
	['weapon_molotov'] = {label = "Molotov", weight = 1000},
	['weapon_fireextinguisher'] = {label = "Brandblusser", weight = 1000},
	['weapon_petrolcan'] = {label = "Jerrycan", weight = 1000},
	['weapon_briefcase'] = {label = "Koffer", weight = 1000},
	['weapon_briefcase_02'] = {label = "Koffer", weight = 1000},
	['weapon_ball'] = {label = "Balletje", weight = 1000},
	['weapon_flare'] = {label = "Lichtpistool", weight = 1000},
	['weapon_snspistol'] = {label = "SNS Pistol", weight = 1000},
	['weapon_bottle'] = {label = "Glas fles", weight = 1000},
	['weapon_gusenberg'] = {label = "Thompson SMG", weight = 1000},
	['weapon_specialcarbine'] = {label = "Special Carbine", weight = 1000},
	['weapon_heavypistol'] = {label = "Heavy Pistol", weight = 1000},
	['weapon_bullpuprifle'] = {label = "Bullpup Rifle", weight = 1000},
	['weapon_dagger'] = {label = "Dagger", weight = 1000},
	['weapon_vintagepistol'] = {label = "Vintage Pistol", weight = 1000},
	['weapon_firework'] = {label = "Vuurwerk", weight = 1000},
	['weapon_musket'] = {label = "Musket", weight = 1000},
	['weapon_heavyshotgun'] = {label = "Heavy Shotgun", weight = 1000},
	['weapon_marksmanrifle'] = {label = "Marksman Rifle", weight = 1000},
	['weapon_hominglauncher'] = {label = "Homing Launcher", weight = 1000},
	['weapon_proxmine'] = {label = "Poxmine Granaat", weight = 1000},
	['weapon_snowball'] = {label = "Sneeuwbal", weight = 1000},
	['weapon_flaregun'] = {label = "Lichtpistool", weight = 1000},
	['weapon_garbagebag'] = {label = "Vuilniszak", weight = 1000},
	['weapon_handcuffs'] = {label = "Boeien", weight = 1000},
	['weapon_combatpdw'] = {label = "Combat PDW", weight = 1000},
	['weapon_marksmanpistol'] = {label = "Marksman Pistol", weight = 1000},
	['weapon_knuckle'] = {label = "Boksbeugel", weight = 1000},
	['weapon_hatchet'] = {label = "Bijl", weight = 1000},
	['weapon_railgun'] = {label = "Railgun", weight = 1000},
	['weapon_machete'] = {label = "Machete", weight = 1000},
	['weapon_machinepistol'] = {label = "Tec-9", weight = 1000},
	['weapon_switchblade'] = {label = "Vlindermes", weight = 1000},
	['weapon_revolver'] = {label = "Revolver", weight = 1000},
	['weapon_dbshotgun'] = {label = "Double Barrel Shotgun", weight = 1000},
	['weapon_compactrifle'] = {label = "Compact Rifle", weight = 1000},
	['weapon_autoshotgun'] = {label = "Auto Shotgun", weight = 1000},
	['weapon_battleaxe'] = {label = "Combat Axe", weight = 1000},
	['weapon_compactlauncher'] = {label = "Compact Launcher", weight = 1000},
	['weapon_minismg'] = {label = "Mini SMG", weight = 1000},
	['weapon_pipebomb'] = {label = "Pipebommen", weight = 1000},
	['weapon_poolcue'] = {label = "Poolcue", weight = 1000},
	['weapon_wrench'] = {label = "Moersleutel", weight = 1000},
}

QBShared.Items = {}