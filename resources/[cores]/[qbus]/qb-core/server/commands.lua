QBCore.Commands = {}
QBCore.Commands.List = {}

QBCore.Commands.Add = function(name, help, arguments, argsrequired, callback, persmission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	QBCore.Commands.List[name:lower()] = {
		['name'] = name:lower(),
		['persmission'] = permission ~= nil and permission:lower() or "user",
		['help'] = help,
		['arguments'] = arguments,
		['argsrequired'] = argsrequired,
		['callback'] = callback,
	}
end

QBCore.Commands.Refresh = function(source)
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(QBCore.Commands.List) do
			if (Player.PlayerData.permission == "god") or (QBCore.Commands.List[command].permission == "moderator" and Player.PlayerData.permission == "admin") or (QBCore.Commands.List[command].permission == Player.PlayerData.permission or Player.Functions.HasAcePermission("qbcommands."..command)) or (QBCore.Commands.List[command].permission == Player.PlayerData.job.name) then
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
end, "moderator")

QBCore.Commands.Add("sv", "Spawn een voertuig", {{name="model", help="Model naam van het voertuig"}}, true, function(source, args)
	TriggerClientEvent('QBCore:Command:SpawnVehicle', source, args[1])
end, "admin")

QBCore.Commands.Add("debug", "Zet debug mode aan/uit", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

QBCore.Commands.Add("dv", "Spawn een voertuig", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:DeleteVehicle', source)
end, "moderator")

QBCore.Commands.Add("tpm", "Teleport naar een marker", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:GoToMarker', source)
end, "moderator")

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

QBCore.Commands.Add("setpermission", "Geef een permissie aan een speler", {{name="id", help="Speler ID"}, {name="permission", help="Permissie naam"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetPermission(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "god")

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
end, "god")