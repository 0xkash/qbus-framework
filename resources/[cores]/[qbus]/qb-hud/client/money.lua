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
local MinusTimeOut = 2
local MinusTriggered = nil
local MinusAmount = 0
local MinusAlpha = 250
local MinusPrefix = "-"
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if MinusTriggered ~= nil then
			if MinusTimeOut ~= 0 then
				Citizen.Wait(1000)
				MinusTimeOut = MinusTimeOut - 1
			end
			if MinusTimeOut == 0 then
				if MinusAlpha ~= 0 then
					MinusAlpha = MinusAlpha - 1
				end
				if MinusAlpha == 0 then
					MinusTriggered = nil
				end
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if MinusTriggered ~= nil then
			QBCore.Functions.DrawText(Config.Money.DrawLocations[MinusTriggered].x + 0.002, Config.Money.DrawLocations[MinusTriggered].y + 0.025, 1.0, 1.0, 0.5, 255, 255, 255, MinusAlpha, MinusPrefix.." ~w~"..tostring(MinusAmount))
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

RegisterNetEvent('QBCore:OnMoneyChange')
AddEventHandler('QBCore:OnMoneyChange', function(moneytype, amount, isplus)
	if Config.Money.DrawLocations[moneytype].show then
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		Config.Money.HUDOn = true
		Config.Money.DrawLocations[moneytype].alpha = 250
		MinusTriggered = moneytype
		MinusAmount = amount
		MinusTimeOut = 3
		MinusAlpha = 250
		if not isplus then MinusPrefix = "~r~-" else MinusPrefix = "~g~+" end
	end
end)