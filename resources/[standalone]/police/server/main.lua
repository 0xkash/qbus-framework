QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("cam", "Bekijk beveiligings camera", {{name="camid", help="Camera ID"}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ActiveCamera", source, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)