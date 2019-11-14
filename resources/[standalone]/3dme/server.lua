QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("me", "Karakter interacties", {}, false, function(source, args)
	local text = table.concat(args, ' ')
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end)