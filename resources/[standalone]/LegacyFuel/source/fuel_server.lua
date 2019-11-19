QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

function round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local src = source
	local pData = QBCore.Functions.GetPlayer(src)
	local amount = round(price)

	if pData.Functions.RemoveMoney('cash', amount) then
		TriggerClientEvent("QBCore:Notify", src, "Uw auto is bijgevuld", "success")
	end
end)
