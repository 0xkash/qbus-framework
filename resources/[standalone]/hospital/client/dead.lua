local deadAnimDict = "dead"
local deadAnim = "dead_a"
local deadCarAnimDict = "veh@low@front_ps@idle_duck"
local deadCarAnim = "sit"

local deathTime = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = PlayerId()
		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()
			if IsEntityDead(playerPed) and not isDead then
				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                local killerServerId = NetworkGetPlayerIndexFromPed(killer)
                deathTime = Config.DeathTime

                OnDeath()
                
                DeathTimer()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, Keys['T'], true)
            EnableControlAction(0, Keys['E'], true)
            EnableControlAction(0, Keys['ESC'], true)

            if not isInHospitalBed then 
                if deathTime > 0 then
                    DrawTxt(0.89, 1.44, 1.0,1.0,0.6, "RESPAWN OVER: ~b~" .. math.ceil(deathTime) .. "~w~ SECONDEN", 255, 255, 255, 255)
                else
                    DrawTxt(0.89, 1.44, 1.0,1.0,0.6, "~w~ HOUD ~b~E ~w~INGEDRUKT OM TE RESPAWNEN", 255, 255, 255, 255)
                end
            end

            loadAnimDict(deadAnimDict)
            if not IsEntityPlayingAnim(PlayerPedId(), deadAnimDict, deadAnim, 3) and not isInHospitalBed then
                TaskPlayAnim(PlayerPedId(), deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
            loadAnimDict(inBedDict)
            if not IsEntityPlayingAnim(PlayerPedId(), inBedDict, inBedAnim, 3) and isInHospitalBed then
                TaskPlayAnim(PlayerPedId(), inBedDict, inBedAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end

            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnDeath()
    if not isDead then
        isDead = true
        TriggerServerEvent("hospital:server:SetDeathStatus", true)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
        local player = GetPlayerPed(-1)

        while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Citizen.Wait(10)
        end

        local pos = GetEntityCoords(player)
        local heading = GetEntityHeading(player)

        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
        SetEntityInvincible(player, true)
        SetEntityHealth(player, GetEntityMaxHealth(GetPlayerPed(-1)))

        loadAnimDict(deadAnimDict)
        TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        TriggerEvent("hospital:client:AiCall")
    end
end

function DeathTimer()
    local hold = 0
    while isDead do
        Citizen.Wait(1000)
        deathTime = deathTime - 1

        if deathTime <= 0 then
            if IsControlPressed(0, Keys["E"]) and hold > 1 and not isInHospitalBed then
                TriggerEvent("hospital:client:RespawnAtHospital")
            end

            if IsControlPressed(0, Keys["E"]) then
                hold = hold + 1
            end
        end
    end
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

