Citizen.CreateThread(function() -- save player
	while true do
		Citizen.Wait((1000 * 60) * 10) -- every 10 mins
		local PlayersList = QBCore.Functions.GetPlayers()
		if PlayersList ~= nil then
			for source, Player in pairs(PlayersList) do
				Player.Functions.Save()
			end
		end
	end
end)