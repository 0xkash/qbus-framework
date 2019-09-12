Citizen.CreateThread(function() -- save player
	while true do
		Citizen.Wait((1000 * 60) * 10) -- every 10 mins
		TriggerClientEvent("QBCore:Player:UpdatePlayerData", -1)
	end
end)