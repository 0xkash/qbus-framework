Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		SetVehicleDensityMultiplierThisFrame(0.05)
	    SetPedDensityMultiplierThisFrame(1.0)
	    SetParkedVehicleDensityMultiplierThisFrame(1.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
	end
end)