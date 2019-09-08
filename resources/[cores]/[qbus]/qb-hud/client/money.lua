QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(core) QBCore = core end)
        Citizen.Wait(200)
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