local currentGarage = 1
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            if PlayerJob.name == "police" then
                local pos = GetEntityCoords(GetPlayerPed(-1))

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 5) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 1.5) then
                        if not onDuty then
                            QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "~g~E~w~ - In dienst gaan")
                        else
                            QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "~r~E~w~ - Uit dienst gaan")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            onDuty = not onDuty
                            TriggerServerEvent("police:server:UpdateCurrentCops")
                            TriggerServerEvent("QBCore:ToggleDuty")
                            TriggerServerEvent("police:server:UpdateBlips")
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 2.5) then
                        QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "In/Uit dienst")
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence"].x, Config.Locations["evidence"].y, Config.Locations["evidence"].z, true) < 2) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence"].x, Config.Locations["evidence"].y, Config.Locations["evidence"].z, true) < 1.0) then
                        QBCore.Functions.DrawText3D(Config.Locations["evidence"].x, Config.Locations["evidence"].y, Config.Locations["evidence"].z, "~g~E~w~ - Bewijskast")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerEvent("inventory:client:SetCurrentStash", "policeevidence")
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence"].x, Config.Locations["evidence"].y, Config.Locations["evidence"].z, true) < 1.5) then
                        QBCore.Functions.DrawText3D(Config.Locations["evidence"].x, Config.Locations["evidence"].y, Config.Locations["evidence"].z, "Bewijskast")
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence2"].x, Config.Locations["evidence2"].y, Config.Locations["evidence2"].z, true) < 2) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence2"].x, Config.Locations["evidence2"].y, Config.Locations["evidence2"].z, true) < 1.0) then
                        QBCore.Functions.DrawText3D(Config.Locations["evidence2"].x, Config.Locations["evidence2"].y, Config.Locations["evidence2"].z, "~g~E~w~ - Bewijskast")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerEvent("inventory:client:SetCurrentStash", "policeevidence2")
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence2", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence2"].x, Config.Locations["evidence2"].y, Config.Locations["evidence2"].z, true) < 1.5) then
                        QBCore.Functions.DrawText3D(Config.Locations["evidence2"].x, Config.Locations["evidence2"].y, Config.Locations["evidence2"].z, "Bewijskast")
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence3"].x, Config.Locations["evidence3"].y, Config.Locations["evidence3"].z, true) < 2) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence3"].x, Config.Locations["evidence3"].y, Config.Locations["evidence3"].z, true) < 1.0) then
                        QBCore.Functions.DrawText3D(Config.Locations["evidence3"].x, Config.Locations["evidence3"].y, Config.Locations["evidence3"].z, "~g~E~w~ - Bewijskast")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerEvent("inventory:client:SetCurrentStash", "policeevidence3")
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence3", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["evidence3"].x, Config.Locations["evidence3"].y, Config.Locations["evidence3"].z, true) < 1.5) then
                        QBCore.Functions.DrawText3D(Config.Locations["evidence3"].x, Config.Locations["evidence3"].y, Config.Locations["evidence3"].z, "Bewijskast")
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["trash"].x, Config.Locations["trash"].y, Config.Locations["trash"].z, true) < 2) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["trash"].x, Config.Locations["trash"].y, Config.Locations["trash"].z, true) < 1.0) then
                        QBCore.Functions.DrawText3D(Config.Locations["trash"].x, Config.Locations["trash"].y, Config.Locations["trash"].z, "~r~E~w~ - Prullenbak")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerEvent("inventory:client:SetCurrentStash", "policetrash")
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policetrash", {
                                maxweight = 4000000,
                                slots = 300,
                            })
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["trash"].x, Config.Locations["trash"].y, Config.Locations["trash"].z, true) < 1.5) then
                        QBCore.Functions.DrawText3D(Config.Locations["trash"].x, Config.Locations["trash"].y, Config.Locations["trash"].z, "Prullenbak")
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true) < 7.5) then
                    if onDuty then
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
                                    currentGarage = 1
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end  
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle2"].x, Config.Locations["vehicle2"].y, Config.Locations["vehicle2"].z, true) < 7.5) then
                    if onDuty then
                        DrawMarker(2, Config.Locations["vehicle2"].x, Config.Locations["vehicle2"].y, Config.Locations["vehicle2"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle2"].x, Config.Locations["vehicle2"].y, Config.Locations["vehicle2"].z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.DrawText3D(Config.Locations["vehicle2"].x, Config.Locations["vehicle2"].y, Config.Locations["vehicle2"].z, "~g~E~w~ - Voertuig opbergen")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["vehicle2"].x, Config.Locations["vehicle2"].y, Config.Locations["vehicle2"].z, "~g~E~w~ - Voertuigen")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuGarage()
                                    currentGarage = 2
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end  
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["impound"].x, Config.Locations["impound"].y, Config.Locations["impound"].z, true) < 7.5) then
                    if onDuty then
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
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["helicopter"].x, Config.Locations["helicopter"].y, Config.Locations["helicopter"].z, true) < 7.5) then
                    if onDuty then
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
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 4.5) and IsArmoryWhitelist() then
                    if onDuty then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, "~g~E~w~ - Wapenkluis")
                            if IsControlJustReleased(0, Keys["E"]) then
                                SetWeaponSeries()
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", Config.Items)
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 2.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, "Wapenkluis")
                        end  
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, true) < 4.5) then
                    if onDuty then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, "~g~E~w~ - Persoonlijke kluis")
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, true) < 2.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, "Persoonlijke kluis")
                        end  
                    end
                end

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["fingerprint"].x, Config.Locations["fingerprint"].y, Config.Locations["fingerprint"].z, true) < 4.5) then
                    if onDuty then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["fingerprint"].x, Config.Locations["fingerprint"].y, Config.Locations["fingerprint"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["fingerprint"].x, Config.Locations["fingerprint"].y, Config.Locations["fingerprint"].z, "~g~E~w~ - Scan vingerafdruk")
                            if IsControlJustReleased(0, Keys["E"]) then
                                local player, distance = GetClosestPlayer()
                                if player ~= -1 and distance < 2.5 then
                                    local playerId = GetPlayerServerId(player)
                                    TriggerServerEvent("police:server:showFingerprint", playerId)
                                else
                                    QBCore.Functions.Notify("Niemand in de buurt!", "error")
                                end
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["fingerprint"].x, Config.Locations["fingerprint"].y, Config.Locations["fingerprint"].z, true) < 2.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["fingerprint"].x, Config.Locations["fingerprint"].y, Config.Locations["fingerprint"].z, "Vinger scan")
                        end  
                    end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

local inFingerprint = false
local FingerPrintSessionId = nil

RegisterNetEvent('police:client:showFingerprint')
AddEventHandler('police:client:showFingerprint', function(playerId)
    openFingerprintUI()
    FingerPrintSessionId = playerId
end)

RegisterNetEvent('police:client:showFingerprintId')
AddEventHandler('police:client:showFingerprintId', function(fid)
    SendNUIMessage({
        type = "updateFingerprintId",
        fingerprintId = fid
    })
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNUICallback('doFingerScan', function(data)
    TriggerServerEvent('police:server:showFingerprintId', FingerPrintSessionId)
end)

function openFingerprintUI()
    SendNUIMessage({
        type = "fingerprintOpen"
    })
    inFingerprint = true
    SetNuiFocus(true, true)
end

RegisterNUICallback('closeFingerprint', function()
    SetNuiFocus(false, false)
    inFingerprint = false
end)

RegisterNetEvent('police:client:SendEmergencyMessage')
AddEventHandler('police:client:SendEmergencyMessage', function(message)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    
    TriggerServerEvent("police:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:client:EmergencySound')
AddEventHandler('police:client:EmergencySound', function()
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:CallAnim')
AddEventHandler('police:client:CallAnim', function()
    local isCalling = true
    local callCount = 5
    loadAnimDict("cellphone@")   
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
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
    Menu.addButton("Voertuigen", "VehicleList", nil)
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
    if currentGarage == 2 then
        coords = Config.Locations["vehicle2"]
    end
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "PLZI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("inventory:server:addTrunkItems", GetVehicleNumberPlateText(veh), Config.CarItems)
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

function SetCarItemsInfo()
	local items = {}
	for k, item in pairs(Config.CarItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
		}
	end
	Config.CarItems = items
end

function IsArmoryWhitelist()
    local retval = false
    local citizenid = QBCore.Functions.GetPlayerData().citizenid
    for k, v in pairs(Config.ArmoryWhitelist) do
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

function SetWeaponSeries()
    for k, v in pairs(Config.Items.items) do
        if k < 6 then
            Config.Items.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end