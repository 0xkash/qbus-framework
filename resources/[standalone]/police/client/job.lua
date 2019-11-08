Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, "~g~E~w~ - Omkleden | ~g~H~w~ - Outfit opslaan | ~g~G~w~ - Outfits")
                            if IsControlJustReleased(0, Keys["E"]) then
                                if PlayerData.charinfo.gender == 0 then
                                    TriggerEvent("maleclothesstart", false)
                                else
                                    TriggerEvent("femaleclothesstart", false)
                                end
                                DoScreenFadeIn(50)
                            elseif IsControlJustReleased(0, Keys["H"]) then
                                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP9N", "", "", "", "", "", 20)
                                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                                    Citizen.Wait(7)
                                end
                                local outfitName = GetOnscreenKeyboardResult()
                                TriggerEvent("clothes:client:SaveOutfit", false, outfitName)
                            elseif IsControlJustPressed(0, Keys["G"]) then
                                MenuOutfits()
                                Menu.hidden = not Menu.hidden
                            end
                            Menu.renderGUI()
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 2.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, "Omkleden")
                        end  
                    end
                end)
            end
    
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 1.5) then
                            if not PlayerData.job.onduty then
                                QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "~g~E~w~ - In dienst gaan")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "~r~E~w~ - Uit dienst gaan")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerServerEvent("QBCore:ToggleDuty")
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 2.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "In/Uit dienst")
                        end  
                    end
                end)
            end
            
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" and PlayerData.job.onduty then
                        DrawMarker(2, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.DrawText3D(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, "~g~E~w~ - Voertuig opbergen")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, "~g~E~w~ - Voertuigen")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end  
                    end
                end)
            end

            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["impound"].x, Config.Locations["impound"].y, Config.Locations["impound"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" and PlayerData.job.onduty then
                        DrawMarker(2, Config.Locations["impound"].x, Config.Locations["impound"].y, Config.Locations["impound"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["impound"].x, Config.Locations["impound"].y, Config.Locations["impound"].z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.DrawText3D(Config.Locations["impound"].x, Config.Locations["impound"].y, Config.Locations["impound"].z, "~g~E~w~ - Voertuig opbergen")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["impound"].x, Config.Locations["impound"].y, Config.Locations["impound"].z, "~g~E~w~ - Voertuigen")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuImpound()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end  
                    end
                end)
            end

            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["helicopter"].x, Config.Locations["helicopter"].y, Config.Locations["helicopter"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" and PlayerData.job.onduty then
                        DrawMarker(2, Config.Locations["helicopter"].x, Config.Locations["helicopter"].y, Config.Locations["helicopter"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["helicopter"].x, Config.Locations["helicopter"].y, Config.Locations["helicopter"].z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.DrawText3D(Config.Locations["helicopter"].x, Config.Locations["helicopter"].y, Config.Locations["helicopter"].z, "~g~E~w~ - Helikopter opbergen")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["helicopter"].x, Config.Locations["helicopter"].y, Config.Locations["helicopter"].z, "~g~E~w~ - Helikopter pakken")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    local coords = Config.Locations["helicopter"]
                                    QBCore.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                                        SetVehicleNumberPlateText(veh, "ZULU"..tostring(math.random(1000, 9999)))
                                        SetEntityHeading(veh, coords.h)
                                        exports['LegacyFuel']:SetFuel(veh, 100.0)
                                        closeMenuFull()
                                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                        SetVehicleEngineOn(veh, true, true)
                                    end, coords, true)
                                end
                            end
                        end  
                    end
                end)
            end

            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" and PlayerData.job.onduty then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, "~g~E~w~ - Wapenkluis")
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", Config.Items)
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 2.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, "Wapenkluis")
                        end  
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent('police:client:ImpoundVehicle')
AddEventHandler('police:client:ImpoundVehicle', function(fullImpound, price)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 and vehicle ~= nil then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local vehpos = GetEntityCoords(vehicle)
        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent("police:server:Impound", plate, fullImpound, price)
            QBCore.Functions.DeleteVehicle(vehicle)
        end
    end
end)

RegisterNetEvent('police:client:CheckStatus')
AddEventHandler('police:client:CheckStatus', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                QBCore.Functions.TriggerCallback('police:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            TriggerEvent("chatMessage", "STATUS", "warning", v)
                        end
                    end
                end, playerId)
            end
        end
    end)
end)

function MenuImpound()
    ped = GetPlayerPed(-1);
    MenuTitle = "Inbeslag"
    ClearMenu()
    Menu.addButton("Voertuigen", "ImpoundVehicleList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function ImpoundVehicleList()
    QBCore.Functions.TriggerCallback("police:GetImpoundedVehicles", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "Voertuigen:"
        ClearMenu()

        if result == nil then
            QBCore.Functions.Notify("Er zijn geen inbeslaggenomen voertuigen", "error", 5000)
            closeMenuFull()
        else
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel

                Menu.addButton(QBCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutImpound", v, "In beslag", " Motor: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end
            
        Menu.addButton("Terug", "MenuImpound",nil)
    end)
end

function TakeOutImpound(vehicle)
    enginePercent = round(vehicle.engine / 10, 0)
    bodyPercent = round(vehicle.body / 10, 0)
    currentFuel = vehicle.fuel
    local coords = Config.Locations["impound"]
    QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
        QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
            QBCore.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, coords.h)
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
            doCarDamage(veh, vehicle)
            closeMenuFull()
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
        end, vehicle.plate)
        
    end, coords, true)
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("Mijn Outfits", "OutfitsLijst", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    QBCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Outfits :"
        ClearMenu()

        if outfits == nil then
            QBCore.Functions.Notify("Je hebt geen outfits opgeslagen...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Terug", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()

    Menu.addButton("Kies Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Verwijder Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Terug", "OutfitsLijst",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    QBCore.Functions.Notify(oData.outfitname.." gekozen", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    QBCore.Functions.Notify(oData.outfitname.." is verwijderd", "success", 2500)
    closeMenuFull()
end

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Mijn Voertuigen", "VehicleList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"]
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "PLZI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
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

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end