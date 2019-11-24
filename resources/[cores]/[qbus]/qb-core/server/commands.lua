QBCore.Commands = {}
QBCore.Commands.List = {}

QBCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	QBCore.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

QBCore.Commands.Refresh = function(source)
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(QBCore.Commands.List) do
			if QBCore.Functions.HasPermission(source, "god") or QBCore.Functions.HasPermission(source, QBCore.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

QBCore.Commands.Add("tp", "Teleport naar een speler of location", {{name="id/x", help="ID van een speler of X positie"}, {name="y", help="Y positie"}, {name="z", help="Z positie"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('QBCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('QBCore:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Niet elk argument is ingevuld (x, y, z)")
		end
	end
end, "admin")

QBCore.Commands.Add("addpermission", "Geef permissie aan iemand (god/admin)", {{name="id", help="ID van de speler"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(permission):lower()
	if Player ~= nil then
		QBCore.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")	
	end
end, "god")

QBCore.Commands.Add("removepermission", "Haal permissie weg van iemand", {{name="id", help="ID van de speler"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		QBCore.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")	
	end
end, "god")

QBCore.Commands.Add("sv", "Spawn een voertuig", {{name="model", help="Model naam van het voertuig"}}, true, function(source, args)
	TriggerClientEvent('QBCore:Command:SpawnVehicle', source, args[1])
end, "admin")

QBCore.Commands.Add("debug", "Zet debug mode aan/uit", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

QBCore.Commands.Add("dv", "Spawn een voertuig", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:DeleteVehicle', source)
end, "admin")

QBCore.Commands.Add("tpm", "Teleport naar een marker", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:GoToMarker', source)
end, "admin")

QBCore.Commands.Add("givemoney", "Geef geld aan een speler", {{name="id", help="Speler ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Aantal munnies"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("setmoney", "Zet het geld voor een speler", {{name="id", help="Speler ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Aantal munnies"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("setjob", "Geef een baan aan een speler", {{name="id", help="Speler ID"}, {name="job", help="Naam van een baan"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetJob(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("testnotify", "test notify", {{name="text", help="Tekst enzo"}}, true, function(source, args)
	TriggerClientEvent('QBCore:Notify', source, table.concat(args, " "), "success")
end, "god")

QBCore.Commands.Add("baan", "Kijk wat je baan is", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Baan: "..Player.PlayerData.job.label)
end)

QBCore.Commands.Add("clearinv", "Leeg de inventory van jezelf of een speler", {{name="id", help="Speler ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("ooc", "Out Of Character chat bericht (alleen gebruiken wanneer nodig)", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, GetPlayerName(source), false, message)
end)