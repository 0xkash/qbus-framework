Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			TriggerServerEvent('QBCore:PlayerJoined')
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait((1000 * 60) * 10)
		if isLoggedIn then
			TriggerEvent("QBCore:Player:UpdatePlayerData")
		end
	end
end)