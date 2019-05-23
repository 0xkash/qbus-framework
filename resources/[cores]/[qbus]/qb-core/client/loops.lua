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
		Citizen.Wait(0)
		if (QBConfig.Money.HUDEnable and QBCore.Functions.GetPlayerData().money ~= nil) then
			for moneytype, location in pairs(QBConfig.Money.DrawLocations) do
				--QBCore.Functions.DrawText(location.x - 0.05, location.y, 1.0, 1.0, 0.5, 255, 255, 255, location.alpha, "~r~"..QBConfig.Money.Prefix.." ~w~-" .. tostring(QBCore.Functions.GetPlayerData().money[moneytype]))
				if QBConfig.Money.MoneyTimeOut == -1 then
					QBCore.Functions.DrawText(location.x, location.y, 1.0, 1.0, 0.5, 255, 255, 255, 250, location.prefix .. tostring(QBCore.Functions.GetPlayerData().money[moneytype]))
				else
					QBCore.Functions.DrawText(location.x, location.y, 1.0, 1.0, 0.5, 255, 255, 255, location.alpha, location.prefix .. tostring(QBCore.Functions.GetPlayerData().money[moneytype]))
				end
			end
		end
	end
end)
local MoneyTimeOut = QBConfig.Money.MoneyTimeOut
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if QBConfig.Money.HUDOn then
			Citizen.Wait(1000)
			MoneyTimeOut = MoneyTimeOut - 1
			if MoneyTimeOut == 0 then
				QBConfig.Money.HUDOn = false
				MoneyTimeOut = QBConfig.Money.MoneyTimeOut
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not QBConfig.Money.HUDOn then
			for moneytype, location in pairs(QBConfig.Money.DrawLocations) do
				if location.alpha ~= 0 then
					location.alpha = location.alpha - 1
				end
			end
		end
	end
end)