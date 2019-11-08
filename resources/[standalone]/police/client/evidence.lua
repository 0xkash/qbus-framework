StatusList = {
	["fight"] = "Rode handen",
	["widepupils"] = "Verwijde pupillen",
	["redeyes"] = "Rode ogen",
	["weedsmell"] = "Ruikt naar wiet",
	["alcohol"] = "Adem ruikt naar alcohol",
	["gunpowder"] = "Kruitsporen in kleding",
	["chemicals"] = "Ruikt chemisch",
	["heavybreath"] = "Ademt zwaar",
	["sweat"] = "Zweet erg",
    ["handbleed"] = "Bloed op handen",
    ["confused"] = "Verward",
}

CurrentStatusList = {}

RegisterNetEvent('evidence:client:SetStatus')
AddEventHandler('evidence:client:SetStatus', function(statusId, time)
	print("lamoaosdk")
	if time > 0 and StatusList[statusId] ~= nil then 
		CurrentStatusList[statusId] = {text = StatusList[statusId], time = time}
		TriggerEvent("chatMessage", "STATUS", "warning", CurrentStatusList[statusId].text)
	elseif StatusList[statusId] ~= nil then
		CurrentStatusList[statusId] = nil
	end
	TriggerServerEvent("evidence:server:UpdateStatus", CurrentStatusList)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if isLoggedIn then
			if CurrentStatusList ~= nil and next(CurrentStatusList) ~= nil then
				for k, v in pairs(CurrentStatusList) do
					if CurrentStatusList[k].time > 0 then
						CurrentStatusList[k].time = CurrentStatusList[k].time - 10
					else
						CurrentStatusList[k].time = 0
					end
				end
				TriggerServerEvent("evidence:server:UpdateStatus", CurrentStatusList)
			end
		end
	end
end)