Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			TriggerServerEvent('QBCore:PlayerJoined')
			exports.spawnmanager:setAutoSpawn(false)
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait((1000 * 60) * 10)
		TriggerEvent("QBCore:Player:UpdatePlayerData")
	end
end)