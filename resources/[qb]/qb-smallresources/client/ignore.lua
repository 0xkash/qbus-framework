disabledVehicles = {
    "PACKER",
    "PHANTOM",
    "MIXER",
    "LAZER",
    "RHINO",
    "BENSON",
    "POUNDER",
}

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

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(7)
        
        for i = 1, #disabledVehicles, 1 do
            SetVehicleModelIsSuppressed(GetHashKey(disabledVehicles[i]), true)
        end
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        local ped = GetPlayerPed( -1 )
        local weapon = GetSelectedPedWeapon(ped)

        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end

        if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") or  weapon == GetHashKey("WEAPON_PETROLCAN") then
            if IsPedShooting(ped) then
                SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
                SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_PETROLCAN"))
            end
        end
    end
end)

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)