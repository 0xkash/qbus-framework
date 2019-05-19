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