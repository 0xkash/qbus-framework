-- Player joined
RegisterServerEvent("QBCore:PlayerJoined")
AddEventHandler('QBCore:PlayerJoined', function()
	local src = source
	if QBCore.Player.Login(src) then
		QBCore.ShowSuccess(GetCurrentResourceName(), GetPlayerName(source).." LOADED!")
		QBCore.Commands.Refresh(src)
	end
	TriggerEvent('QBCore:Server:OnPlayerLoaded')
	TriggerClientEvent('QBCore:Client:OnPlayerLoaded', src)
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	print("Dropped: "..GetPlayerName(src))
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (QBCore.Players[src] == nil)) then return false end
	QBCore.Players[src].Functions.Save()
	QBCore.Players[src] = nil
end)

RegisterServerEvent("QBCore:UpdatePlayer")
AddEventHandler('QBCore:UpdatePlayer', function(data)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = data.position
		QBCore.Player.Save(src)
	end
end)

RegisterServerEvent("QBCore:Server:TriggerCallback")
AddEventHandler('QBCore:Server:TriggerCallback', function(name, ...)
	local src = source
	QBCore.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("QBCore:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("QBCore:Server:UseItem")
AddEventHandler('QBCore:Server:UseItem', function(item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemByName(item)
	if itemData ~= nil and itemData.amount > 0 then
		if QBCore.Functions.CanUseItem(itemData.name) then
			QBCore.Functions.UseItem(src, itemData.name)
		end
	end
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
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					    local agus = ""
					    for name, help in pairs(QBCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, nil, agus)
					else
						QBCore.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Geen toegant tot dit command!")
				end
			end
		end
	end
end)

RegisterServerEvent("QBCore:AddCommand")
AddEventHandler('QBCore:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	QBCore.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)