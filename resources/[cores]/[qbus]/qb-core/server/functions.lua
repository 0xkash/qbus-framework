QBCore.Functions = {}

QBCore.Functions.ExecuteSql = function(query, cb)
	local busy = true
	local retdata = {}
	exports['ghmattimysql']:execute(query, {}, function(data)
		retdata = data
		busy = false
	end)
	while (busy and cb ~= nil) do
		Citizen.Wait(10)
	end
	if cb ~= nil then
		cb(retdata)
	else
		return retdata
	end
end

QBCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or QBConfig.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

QBCore.Functions.GetSource = function(identifier)
	for src, player in pairs(QBCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

QBCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return QBCore.Players[source]
	else
		return QBCore.Players[QBCore.Functions.GetSource(source)]
	end
end

QBCore.Functions.GetPlayers = function()
	return QBCore.Players
end

QBCore.Functions.CreateCallback = function(name, cb)
	QBCore.ServerCallbacks[name] = cb
end

QBCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if QBCore.ServerCallbacks[name] ~= nil then
		QBCore.ServerCallbacks[name](source, cb, ...)
	end
end

QBCore.Functions.CreateUseableItem = function(item, cb)
	QBCore.UseableItems[item] = cb
end

QBCore.Functions.CanUseItem = function(item)
	return QBCore.UseableItems[item] ~= nil
end

QBCore.Functions.UseItem = function(source, item)
	QBCore.UseableItems[item](source)
end

QBCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Kijk op onze discord voor meer informatie: "..QBCore.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

QBCore.Functions.IsWhitelisted = function(source)
	local identifiers = GetPlayerIdentifiers(source)
	local rtn = false
	if (QBCore.Config.Server.whitelist) then
		QBCore.Functions.ExecuteSql("SELECT * FROM `whitelist` WHERE `"..QBCore.Config.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'", function(result)
			local data = result[1]
			if data ~= nil then
				for _, id in pairs(identifiers) do
					if data.steam == id or data.license == id then
						rtn = true
					end
				end
			end
		end)
	else
		rtn = true
	end
	return rtn
end

