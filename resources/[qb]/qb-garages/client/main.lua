QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

--- CODE

local currentGarage = nil

Citizen.CreateThread(function()
    for k, v in pairs(QB.Garages) do
        Garage = AddBlipForCoord(QB.Garages[k].takeVehicle.x, QB.Garages[k].takeVehicle.y, QB.Garages[k].takeVehicle.z)

        SetBlipSprite (Garage, 357)
        SetBlipDisplay(Garage, 4)
        SetBlipScale  (Garage, 0.65)
        SetBlipAsShortRange(Garage, true)
        SetBlipColour(Garage, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(QB.Garages[k].label)
        EndTextCommandSetBlipName(Garage)
    end
end)

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicle List", "ListeVehicule", nil)
    Menu.addButton("Close Menu", "close", nil) 
end

function yeet(gar)
    print(gar)
end

function getPlayerVehicles(garage)
    local vehicles = {}

    return vehicles
end

function ListeVehicule()
    QBCore.Functions.TriggerCallback("qb-garage:server:GetUserVehicles", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Vehicles :"
        ClearMenu()
        local gar = result[1]
        Menu.addButton(QB.Garages[gar.garage].label, "yeet", QB.Garages[gar.garage].label)

        for k, v in pairs(result) do
            enginePercent = round(v.engine / 10, 2)
            bodyPercent = round(v.body / 10, 2)
            currentFuel = v.fuel
            curGarage = QB.Garages[v.garage].label


            if v.state == 0 then
                v.state = "Out"
            elseif v.state == 1 then
                v.state = "In"
            elseif v.state == 2 then
                v.state = "Impounded"
            end

            Menu.addButton(GetDisplayNameFromVehicleModel(GetHashKey(v.vehicle)), "TakeOutVehicle", v, v.state, " Engine %:" .. enginePercent, " Body %:" .. bodyPercent, " Fuel %: "..currentFuel)
        end
            
        Menu.addButton("Return", "MenuGarage",nil)
    end, currentGarage)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == "In" then
        QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            SetEntityHeading(veh, QB.Garages[currentGarage].spawnPoint.h)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            closeMenuFull()
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)

            doCarDamage(veh, vehicle)
            
            TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
        end, QB.Garages[currentGarage].spawnPoint, true)
    end
end

function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end
    
    if engine  > 1000.0 then
        engine = 950.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

function close()
    Menu.hidden = true
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k, v in pairs(QB.Garages) do
            local takeDist = GetDistanceBetweenCoords(pos, QB.Garages[k].takeVehicle.x, QB.Garages[k].takeVehicle.y, QB.Garages[k].takeVehicle.z)
            if takeDist <= 15 then
                DrawMarker(2, QB.Garages[k].takeVehicle.x, QB.Garages[k].takeVehicle.y, QB.Garages[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        QBCore.Functions.DrawText3D(QB.Garages[k].takeVehicle.x, QB.Garages[k].takeVehicle.y, QB.Garages[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            close()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                        if IsControlJustPressed(0, 38) then
                            MenuGarage()
                            Menu.hidden = not Menu.hidden
                            currentGarage = k
                        end
                        Menu.renderGUI()
                    else
                        QBCore.Functions.DrawText3D(QB.Garages[k].takeVehicle.x, QB.Garages[k].takeVehicle.y, QB.Garages[k].takeVehicle.z, QB.Garages[k].label)
                    end
                end

                if takeDist >= 10 and not Menu.hidden then
                    closeMenuFull()
                end
            end

            local putDist = GetDistanceBetweenCoords(pos, QB.Garages[k].putVehicle.x, QB.Garages[k].putVehicle.y, QB.Garages[k].putVehicle.z)

            if putDist <= 15 then
                DrawMarker(2, QB.Garages[k].putVehicle.x, QB.Garages[k].putVehicle.y, QB.Garages[k].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                if putDist <= 1.5 then
                    QBCore.Functions.DrawText3D(QB.Garages[k].putVehicle.x, QB.Garages[k].putVehicle.y, QB.Garages[k].putVehicle.z + 0.5, '~g~E~w~ - Parkeer Voertuig')
                    if IsControlJustPressed(0, 38) then
                        local curVeh = GetVehiclePedIsIn(ped)
                        local bodyDamage = round(GetVehicleBodyHealth(curVeh), 1)
                        local engineDamage = round(GetVehicleEngineHealth(curVeh), 1)
                        local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
                        local plate = GetVehicleNumberPlateText(curVeh)

                        TriggerServerEvent('qb-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, k)
                        TriggerServerEvent('qb-garage:server:updateVehicleState', 1, plate, k)
                        QBCore.Functions.DeleteVehicle(curVeh)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end