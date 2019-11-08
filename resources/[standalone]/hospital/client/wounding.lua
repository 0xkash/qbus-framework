WeaponDamageList = {
	["WEAPON_UNARMED"] = "Vuist afdrukken",
	["WEAPON_ANIMAL"] = "Bijtwond van een dier",
	["WEAPON_COUGAR"] = "Bijtwond van een dier",
	["WEAPON_KNIFE"] = "Steekwond",
	["WEAPON_NIGHTSTICK"] = "Bult van een stok of iets dergelijks",
	["WEAPON_HAMMER"] = "Bult van een stok of iets dergelijks",
	["WEAPON_BAT"] = "Bult van een stok of iets dergelijks",
	["WEAPON_GOLFCLUB"] = "Bult van een stok of iets dergelijks",
	["WEAPON_CROWBAR"] = "Bult van een stok of iets dergelijks",
	["WEAPON_PISTOL"] = "Pistol kogels in het lichaam",
	["WEAPON_COMBATPISTOL"] = "Pistol kogels in het lichaam",
	["WEAPON_APPISTOL"] = "Pistol kogels in het lichaam",
	["WEAPON_PISTOL50"] = "50 Cal Pistol kogels in het lichaam",
	["WEAPON_MICROSMG"] = "SMG kogels in het lichaam",
	["WEAPON_SMG"] = "SMG kogels in het lichaam",
	["WEAPON_ASSAULTSMG"] = "SMG kogels in het lichaam",
	["WEAPON_ASSAULTRIFLE"] = "Rifle kogels in het lichaam",
	["WEAPON_CARBINERIFLE"] = "Rifle kogels in het lichaam",
	["WEAPON_ADVANCEDRIFLE"] = "Rifle kogels in het lichaam",
	["WEAPON_MG"] = "Machine Gun kogels in het lichaam",
	["WEAPON_COMBATMG"] = "Machine Gun kogels in het lichaam",
	["WEAPON_PUMPSHOTGUN"] = "Shotgun kogels in het lichaam",
	["WEAPON_SAWNOFFSHOTGUN"] = "Shotgun kogels in het lichaam",
	["WEAPON_ASSAULTSHOTGUN"] = "Shotgun kogels in het lichaam",
	["WEAPON_BULLPUPSHOTGUN"] = "Shotgun kogels in het lichaam",
	["WEAPON_STUNGUN"] = "Taser afdrukken",
	["WEAPON_SNIPERRIFLE"] = "Sniper kogel in het lichaam",
	["WEAPON_HEAVYSNIPER"] = "Sniper kogel in het lichaam",
	["WEAPON_REMOTESNIPER"] = "Sniper kogel in het lichaam",
	["WEAPON_GRENADELAUNCHER"] = "Brandwonden en fragmenten",
	["WEAPON_GRENADELAUNCHER_SMOKE"] = "Smoke Damage",
	["WEAPON_RPG"] = "Brandwonden en fragmenten",
	["WEAPON_STINGER"] = "Brandwonden en fragmenten",
	["WEAPON_MINIGUN"] = "Heel veel kogels in het lichaam",
	["WEAPON_GRENADE"] = "Brandwonden en fragmenten",
	["WEAPON_STICKYBOMB"] = "Brandwonden en fragmenten",
	["WEAPON_SMOKEGRENADE"] = "Smoke Damage",
	["WEAPON_BZGAS"] = "Gas Damage",
	["WEAPON_MOLOTOV"] = "Zware brandwonden",
	["WEAPON_FIREEXTINGUISHER"] = "Ondergespoten :)",
	["WEAPON_PETROLCAN"] = "Petrol Can Damage",
	["WEAPON_FLARE"] = "Flare Damage",
	["WEAPON_BARBED_WIRE"] = "Barbed Wire Damage",
	["WEAPON_DROWNING"] = "Verdonken",
	["WEAPON_DROWNING_IN_VEHICLE"] = "Verdronken",
	["WEAPON_BLEEDING"] = "Veel bloed verloren",
	["WEAPON_ELECTRIC_FENCE"] = "Electric Fence Wounds",
	["WEAPON_EXPLOSION"] = "Veel brandwonden (van explosieve)",
	["WEAPON_FALL"] = "Gebroken botten",
	["WEAPON_EXHAUSTION"] = "Died of Exhaustion",
	["WEAPON_HIT_BY_WATER_CANNON"] = "Water Cannon Pelts",
	["WEAPON_RAMMED_BY_CAR"] = "Auto ongeluk",
	["WEAPON_RUN_OVER_BY_CAR"] = "Aangereden door een voertuig",
	["WEAPON_HELI_CRASH"] = "Helikopter crash",
	["WEAPON_FIRE"] = "Veel brandwonden",
}

CurrentDamageList = {}

Citizen.CreateThread(function()
	while true do
		if #injured > 0 then
			local level = 0
			for k, v in pairs(injured) do
				if v.severity > level then
					level = v.severity
				end
			end

			SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[level])
			
			Citizen.Wait(5)
		else
			Citizen.Wait(1000)
		end
	end
end)

local prevPos = nil
Citizen.CreateThread(function()
    Citizen.Wait(2500)
    prevPos = GetEntityCoords(PlayerPedId(), true)
    while true do
        if isBleeding > 0 then
            local player = PlayerPedId()
            if bleedTickTimer >= Config.BleedTickRate and not isInHospitalBed then
                if not isDead then
                    if isBleeding > 0 then
                        if fadeOutTimer + 1 == Config.FadeOutTimer then
                            if blackoutTimer + 1 == Config.BlackoutTimer then
                                SetFlash(0, 0, 100, 7000, 100)

                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end

                                if not IsPedRagdoll(player) and IsPedOnFoot(player) and not IsPedSwimming(player) then
                                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                    SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                                end

                                Citizen.Wait(1500)
                                DoScreenFadeIn(1000)
                                blackoutTimer = 0
                            else
                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end
                                DoScreenFadeIn(500)

                                if isBleeding > 3 then
                                    blackoutTimer = blackoutTimer + 2
                                else
                                    blackoutTimer = blackoutTimer + 1
                                end
                            end

                            fadeOutTimer = 0
                        else
                            fadeOutTimer = fadeOutTimer + 1
                        end

                        local bleedDamage = tonumber(isBleeding) * Config.BleedTickDamage
                        ApplyDamageToPed(player, bleedDamage, false)
                        DoBleedAlert()
                        playerHealth = playerHealth - bleedDamage
                        local randX = math.random() + math.random(-1, 1)
                        local randY = math.random() + math.random(-1, 1)
                        local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), randX, randY, 0)
                        print("DROP BLOOD PLS")
                        TriggerServerEvent("evidence:server:CreateBloodDrop", QBCore.Functions.GetPlayerData().citizenid, QBCore.Functions.GetPlayerData().metadata["bloodtype"], coords)

                        if advanceBleedTimer >= Config.AdvanceBleedTimer then
                            ApplyBleed(1)
                            advanceBleedTimer = 0
                        else
                            advanceBleedTimer = advanceBleedTimer + 1
                        end
                    end
                end
                bleedTickTimer = 0
            else
                if math.floor(bleedTickTimer % (Config.BleedTickRate / 10)) == 0 then
                    local currPos = GetEntityCoords(player, true)
                    local moving = #(vector2(prevPos.x, prevPos.y) - vector2(currPos.x, currPos.y))
                    if (moving > 1 and not IsPedInAnyVehicle(player)) and isBleeding > 2 then
                        advanceBleedTimer = advanceBleedTimer + Config.BleedMovementAdvance
                        bleedTickTimer = bleedTickTimer + Config.BleedMovementTick
                        prevPos = currPos
                    else
                        bleedTickTimer = bleedTickTimer + 1
                    end

                else

                end
                bleedTickTimer = bleedTickTimer + 1
            end
        end

        Citizen.Wait(1000)
    end
end)

function ProcessDamage(ped)
    if not isDead then
        for k, v in pairs(injured) do
            if (v.part == 'LLEG' and v.severity > 1) or (v.part == 'RLEG' and v.severity > 1) or (v.part == 'LFOOT' and v.severity > 2) or (v.part == 'RFOOT' and v.severity > 2) then
                if legCount >= Config.LegInjuryTimer then
                    if not IsPedRagdoll(ped) and IsPedOnFoot(ped) then
                        local chance = math.random(100)
                        if (IsPedRunning(ped) or IsPedSprinting(ped)) then
                            if chance <= Config.LegInjuryChance.Running then
                                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        else
                            if chance <= Config.LegInjuryChance.Walking then
                                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        end
                    end
                    legCount = 0
                else
                    legCount = legCount + 1
                end
            elseif (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) or (v.part == 'RARM' and v.severity > 1) or (v.part == 'RHAND' and v.severity > 1) or (v.part == 'RFINGER' and v.severity > 2) then
                if armcount >= Config.ArmInjuryTimer then
                    local chance = math.random(100)

                    if (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) then
                        local isDisabled = 15
                        Citizen.CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Citizen.Wait(1)
                            end
                        end)
                    else
                        local isDisabled = 15
                        Citizen.CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisableControlAction(0, 25, true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Citizen.Wait(1)
                            end
                        end)
                    end

                    armcount = 0
                else
                    armcount = armcount + 1
                end
            elseif (v.part == 'HEAD' and v.severity > 2) then
                if headCount >= Config.HeadInjuryTimer then
                    local chance = math.random(100)

                    if chance <= Config.HeadInjuryChance then
                        SetFlash(0, 0, 100, 10000, 100)

                        DoScreenFadeOut(100)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end

                        if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                            SetPedToRagdoll(ped, 5000, 1, 2)
                        end

                        Citizen.Wait(5000)
                        DoScreenFadeIn(250)
                    end
                    headCount = 0
                else
                    headCount = headCount + 1
                end
            end
        end
    end
end

function CheckWeaponDamage(ped)
	for k, v in pairs(WeaponDamageList) do
        if HasPedBeenDamagedByWeapon(ped, GetHashKey(k), 0) then
            TriggerEvent("chatMessage", "STATUS:", "error", v)
			table.insert(CurrentDamageList, WeaponDamageList[k][2])
		end
    end
    TriggerServerEvent("hospital:server:SetWeaponDamage", CurrentDamageList)
end

function CheckDamage(ped, bone, weapon, damageDone)
    if weapon == nil then return end

    if Config.Bones[bone] ~= nil and not isDead then
        ApplyImmediateEffects(ped, bone, weapon, damageDone)

        if not BodyParts[Config.Bones[bone]].isDamaged then
            BodyParts[Config.Bones[bone]].isDamaged = true
            BodyParts[Config.Bones[bone]].severity = 1
            table.insert(injured, {
                part = Config.Bones[bone],
                label = BodyParts[Config.Bones[bone]].label,
                severity = BodyParts[Config.Bones[bone]].severity
            })
        else
            if BodyParts[Config.Bones[bone]].severity < 4 then
                BodyParts[Config.Bones[bone]].severity = BodyParts[Config.Bones[bone]].severity + 1

                for k, v in pairs(injured) do
                    if v.part == Config.Bones[bone] then
                        v.severity = BodyParts[Config.Bones[bone]].severity
                    end
                end
            end
        end

        TriggerServerEvent('hospital:server:SyncInjuries', {
            limbs = BodyParts,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(ped)
        --DoLimbAlert()
        --DoBleedAlert()
    end
end

function ApplyImmediateEffects(ped, bone, weapon, damageDone)
    local armor = GetPedArmour(ped)
    if Config.MinorInjurWeapons[weapon] and damageDone < Config.DamageMinorToMajor then
        if Config.CriticalAreas[Config.Bones[bone]] then
            if armor <= 0 then
                ApplyBleed(1)
            end
        end

        if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
            if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].minor) then
                SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
            end
        end
    elseif Config.MajorInjurWeapons[weapon] or (Config.MinorInjurWeapons[weapon] and damageDone >= Config.DamageMinorToMajor) then
        if Config.CriticalAreas[Config.Bones[bone]] ~= nil then
            if armor > 0 and Config.CriticalAreas[Config.Bones[bone]].armored then
                if math.random(100) <= math.ceil(Config.MajorArmoredBleedChance) then
                    ApplyBleed(1)
                end
            else
                ApplyBleed(1)
            end
        else
            if armor > 0 then
                if math.random(100) < (Config.MajorArmoredBleedChance) then
                    ApplyBleed(1)
                end
            else
                if math.random(100) < (Config.MajorArmoredBleedChance * 2) then
                    ApplyBleed(1)
                end
            end
        end

        if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
            if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].major) then
                SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
            end
        end
    end
end

function ProcessRunStuff(ped)
    if IsInjuryCausingLimp() then
        RequestAnimSet("move_m@injured")
        while not HasAnimSetLoaded("move_m@injured") do
            Citizen.Wait(0)
        end
        SetPedMovementClipset(ped, "move_m@injured", 1 )
        SetPlayerSprint(PlayerId(), false)
    end
end

function ApplyBleed(level)
    if isBleeding ~= 4 then
        if isBleeding + level > 4 then
            isBleeding = 4
        else
            isBleeding = isBleeding + level
        end
        DoBleedAlert()
    end
end