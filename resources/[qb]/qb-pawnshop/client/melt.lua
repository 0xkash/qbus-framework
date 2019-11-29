local enablePickup = false
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inRange = false
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, true) < 3.0 then
			inRange = true
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, true) < 1.5 then
                if not Config.IsMelting then
                    if enablePickup then
                        DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Pak goudstaven")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("qb-pawnshop:server:getGoldBars")
                        end
                    else
                        DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Gouden items smelten")
                        if IsControlJustReleased(0, Keys["E"]) then 
                            local waitTime = math.random(10000, 15000)
                            ScrapAnim(waitTime)
                            QBCore.Functions.Progressbar("drop_golden_stuff", "Items pakken..", waitTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                TriggerServerEvent("qb-pawnshop:server:meltItems")
                            end)
                        end
                    end
                elseif Config.IsMelting and Config.MeltTime > 0 then
                    DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "Bezig met smelten: " .. Config.MeltTime)
                end
			end
		end
		if not inRange then
			Citizen.Wait(2500)
		end
	end
end)

function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('qb-pawnshop:client:pickedUp')
AddEventHandler('qb-pawnshop:client:pickedUp', function()
    enablePickup = false
end)


RegisterNetEvent('qb-pawnshop:client:startMelting')
AddEventHandler('qb-pawnshop:client:startMelting', function()
    Config.IsMelting = true
    Config.MeltTime = 60
    Citizen.CreateThread(function()
        while Config.IsMelting do
            Config.MeltTime = Config.MeltTime - 1
            if Config.MeltTime <= 0 then
                enablePickup = true
                Config.IsMelting = false
            end
            Citizen.Wait(1000)
        end
    end)
end)