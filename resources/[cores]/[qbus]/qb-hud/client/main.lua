QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(core) QBCore = core end)
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (Config.Money.HUDEnable and QBCore.Functions.GetPlayerData().money ~= nil) then
			for moneytype, location in pairs(Config.Money.DrawLocations) do
				--QBCore.Functions.DrawText(location.x - 0.05, location.y, 1.0, 1.0, 0.5, 255, 255, 255, location.alpha, "~r~"..QBConfig.Money.Prefix.." ~w~-" .. tostring(QBCore.Functions.GetPlayerData().money[moneytype]))
				if Config.Money.MoneyTimeOut == -1 then
					QBCore.Functions.DrawText(location.x, location.y, 1.0, 1.0, 0.5, 255, 255, 255, 250, location.prefix .. tostring(QBCore.Functions.GetPlayerData().money[moneytype]))
				else
					QBCore.Functions.DrawText(location.x, location.y, 1.0, 1.0, 0.5, 255, 255, 255, location.alpha, location.prefix .. tostring(QBCore.Functions.GetPlayerData().money[moneytype]))
				end
			end
		end
	end
end)
local MoneyTimeOut = Config.Money.MoneyTimeOut
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Config.Money.HUDOn then
			Citizen.Wait(1000)
			MoneyTimeOut = MoneyTimeOut - 1
			if MoneyTimeOut == 0 then
				Config.Money.HUDOn = false
				MoneyTimeOut = Config.Money.MoneyTimeOut
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not Config.Money.HUDOn then
			for moneytype, location in pairs(Config.Money.DrawLocations) do
				if location.alpha ~= 0 then
					location.alpha = location.alpha - 1
				end
			end
		end
	end
end)

RegisterNetEvent('QBCore:Command:ShowMoneyType')
AddEventHandler('QBCore:Command:ShowMoneyType', function(moneytype)
	if Config.Money.DrawLocations[moneytype].show then
		Config.Money.HUDOn = true
		Config.Money.DrawLocations[moneytype].alpha = 250
	end
end)