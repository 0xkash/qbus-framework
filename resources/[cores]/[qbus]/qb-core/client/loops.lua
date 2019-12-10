
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(5000, 10000))
		if isLoggedIn then
			if QBCore.Functions.GetPlayerData().metadata["hunger"] <= 0 or QBCore.Functions.GetPlayerData().metadata["thirst"] <= 0 then
				local ped = GetPlayerPed(-1)
				local currentHealth = GetEntityHealth(ped)

				SetEntityHealth(ped, currentHealth - math.random(5, 10))
			end
		end
	end
end)