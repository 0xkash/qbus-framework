QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("am", "Toggle animatie menu", {}, false, function(source, args)
	TriggerClientEvent('animations:client:ToggleMenu', source)
end)

QBCore.Commands.Add("a", "Gebruik een animatie, voor animatie lijst doe /em", {{name = "naam", help = "Emote naam"}}, true, function(source, args)
	TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end)