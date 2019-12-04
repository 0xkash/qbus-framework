Citizen.CreateThread(function() -- save player
	while true do
		Citizen.Wait((1000 * 60) * 10) -- every 10 mins
		for k, v in pairs(QBCore.Functions.GetPlayers()) do
			local Player = QBCore.Functions.GetPlayer(v)
			if Player ~= nil then 
				Player.Functions.AddMoney("bank", Player.PlayerData.job.payment)
				TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, "Je hebt je salaris ontvangen van €"..Player.PlayerData.job.payment)
			end
		end
		TriggerClientEvent("QBCore:Player:UpdatePlayerData", -1)
	end
end)

Citizen.CreateThread(function() -- save player
	while true do
		Citizen.Wait((1000 * 60) * 3) -- every 3 mins
		TriggerClientEvent("QBCore:Player:UpdatePlayerPosition", -1)
	end
end)