QBCore.Commands = {}
QBCore.Commands.List = {}

QBCore.Commands.Add = function(name, help, arguments, argsrequired, callback, persmission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	QBCore.Commands.List[name:lower()] = {
		['name'] = name:lower(),
		['persmission'] = permission ~= nil and permission:lower() or nil,
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
			if (Player.Functions.HasAcePermission("qbcommands."..command)) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

QBCore.Commands.Add("tp", "Tp to a location or a player", {{name="id/x", help="ID of a player or X position"}, {name="y", help="Y position"}, {name="z", help="Z position"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil or args[3] == nil)) then
		-- tp to player
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('QBCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player is not online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			TriggerClientEvent('QBCore:Command:TeleportToCoords', source, args[1], args[2], args[3])
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Not all arguments were filled (x, y, z)")
		end
	end
end)

QBCore.Commands.Add("testbro", "test", {{name="some", help="..body that i used to know?"}, {name="thing", help="..oh nvm"}}, true, function(source, args)
	QBCore.ShowSuccess(GetCurrentResourceName(), "/testbro triggered")
end)

QBCore.Commands.Add("cash", "Show your cash balance", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:ShowMoneyType', source, "cash")
end)

QBCore.Commands.Add("bank", "Show your bank balance", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:ShowMoneyType', source, "bank")
end)