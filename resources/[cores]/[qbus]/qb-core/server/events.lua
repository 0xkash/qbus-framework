-- Player joined
RegisterServerEvent("QBCore:PlayerJoined")
AddEventHandler('QBCore:PlayerJoined', function()
	local src = source
	if QBCore.Player.Login(src) then
		QBCore.ShowSuccess(GetCurrentResourceName(), GetPlayerName(source).." LOADED!")
		QBCore.Commands.Refresh(src)
	end
	--TriggerClientEvent('QBCore:OnPlayerJoined')
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = QBCore.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if QBCore.Commands.List[command] ~= nil then
			local Player = QBCore.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (Player.PlayerData.permission == "god") or (QBCore.Commands.List[command].permission == "moderator" and Player.PlayerData.permission == "admin") or (QBCore.Commands.List[command].permission == Player.PlayerData.permission or Player.Functions.HasAcePermission("qbcommands."..command)) or (QBCore.Commands.List[command].permission == Player.PlayerData.job.name) then
					if (QBCore.Commands.List[command].argsrequired and #QBCore.Commands.List[command].arguments ~= 0 and args[#QBCore.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Alle argumenten moeten ingevuld worden!")
					    local agus = ""
					    for name, help in pairs(QBCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, {255, 255, 255}, agus)
					else
						QBCore.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Geen toegant tot dit command!")
				end
			end
		end
	end
end)