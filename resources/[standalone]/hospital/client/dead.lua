Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = PlayerId()
		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()
			if IsPedFatallyInjured(playerPed) and not isDead then
				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                local killerServerId = NetworkGetPlayerIndexFromPed(killer)
                
				OnDeath()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, Keys['~'], true)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['M'], true)
			EnableControlAction(0, Keys['N'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['RIGHT'], true)
			EnableControlAction(0, Keys['LEFT'], true)
			EnableControlAction(0, Keys['ENTER'], true)
			EnableControlAction(0, Keys['Z'], true)
			EnableControlAction(0, Keys['F10'], true)
			EnableControlAction(0, 177, true)


			loadAnimDict("missfinale_c1@")
            if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c1@", "lying_dead_player0", 3) and not IsEntityPlayingAnim(PlayerPedId(), "amb@lo_res_idles@", "world_human_bum_slumped_left_lo_res_base", 3) then
                TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 1, 0, 0, 0, 0)
                TaskPlayAnim(GetPlayerPed(PlayerId()), "missfinale_c1@", "lying_dead_player0", 1.0, -1, -1, 1, 0, 0, 0, 0)
            end

            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnDeath()
    if not isDead then
        SetEntityHealth(player, GetEntityMaxHealth(player))
        isDead = true
        local player = GetPlayerPed(-1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        
        TriggerServerEvent("hospital:server:SetDeathStatus", true)

        while IsPedRagdoll(player) do
            Citizen.Wait(10)
        end
        Citizen.Wait(1000)

        ClearPedTasksImmediately(player)
        loadAnimDict("misslamar1dead_body")
	    TaskPlayAnim(GetPlayerPed(-1), "misslamar1dead_body", "dead_idle", 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    end
end

