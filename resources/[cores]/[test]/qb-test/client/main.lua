QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(core) QBCore = core end)
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if ten < 9 then
			print("yest")
		end
	end
end)