Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        local PlayerPed = PlayerPedId()
		if GetPlayerWantedLevel(PlayerId()) ~= 0 then
			SetPlayerWantedLevel(PlayerId(), 0, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
		end
        --Display vehicle Rewards
        DisablePlayerVehicleRewards(PlayerPed)
        -- Disable Wanted level
		for i = 1, 20 do
			EnableDispatchService(i, false)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(7)
       RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
       RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
       RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
       RemoveAllPickupsOfType(0xADDECFC5) -- switchblade
       RemoveAllPickupsOfType(0x08B8D9EA) -- knife
       RemoveAllPickupsOfType(0x69C100F4) -- Golfclub
       RemoveAllPickupsOfType(0x631B3559) -- bat       
       RemoveAllPickupsOfType(0xB0769393) -- sns
    end
end)