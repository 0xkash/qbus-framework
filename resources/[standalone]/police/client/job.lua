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
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 4.5) then
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
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 4.5) then
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

            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "police" and PlayerData.job.onduty then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, "~g~E~w~ - Wapenkluis")
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", Config.Items)
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, true) < 3.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["armory"].x, Config.Locations["armory"].y, Config.Locations["armory"].z, "Wapenkluis")
                        end  
                    end
                end)
            end
        end
    end
end)

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