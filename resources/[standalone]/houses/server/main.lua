QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("houses:server:sethousedoorstate")
AddEventHandler("houses:server:sethousedoorstate", function(house, state)
	local src = source
	TriggerClientEvent("houses:client:sethousedoorstate", -1, house, state)
end)

RegisterServerEvent("houses:server:savedecorations")
AddEventHandler("houses:server:savedecorations", function(house, objlist)
	local src = source
	TriggerClientEvent("houses:client:setdecoration", -1, house, objlist)
end)

function HasKey(identifier, house)
	for _, keyholder in pairs(Houses[house].keyholders) do
		if keyholder == identifier then
			return true
		end
	end
	return false
end

-- can be changed
QBCore.Commands.Add("decorate", "Decoreer een huis", {}, false, function(source, args)
	TriggerClientEvent("houses:client:decorate", source)
end)
