local currentCarKey, currentCarValue = nil
local inMenu = false

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function MenuVehicleList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Dealer"
    ClearMenu()
    Menu.addButton("Assortiment Bekijken", "VehicleCategories", nil)
    Menu.addButton("Sluit Menu", "close", nil) 
end

function VehicleCategories()
    ped = GetPlayerPed(-1);
    MenuTitle = "Veh Cats"
    ClearMenu()
    for k, v in pairs(QB.VehicleMenuCategories) do
        Menu.addButton(QB.VehicleMenuCategories[k].label, "GetCatVehicles", k)
    end
    
    Menu.addButton("Sluit Menu", "close", nil) 
end

function GetCatVehicles(catergory)
    ped = GetPlayerPed(-1)
    MenuTitle = "Cat Vehs"
    ClearMenu()
    for k, v in pairs(QB.CategoryVehicles[catergory]) do
        Menu.addButton(QB.CategoryVehicles[catergory][k].label, "SelectVehicle", v)
    end

    Menu.addButton("Sluit Menu", "close", nil) 
end

function SelectVehicle(vehicleData)
    local vehCoords = GetClosestVehicle(currentCarValue.coords.x, currentCarValue.coords.y, currentCarValue.coords.z, 1.0, 0, 70)
    QBCore.Functions.DeleteVehicle(vehCoords)

    QBCore.Functions.SpawnVehicle(vehicleData.vehicle, function(veh)
        SetEntityHeading(veh, currentCarValue.coords.h)
        SetVehicleDoorsLocked(veh, 3)
    end, currentCarValue.coords)
    QB.ShowroomVehicles[currentCarKey].chosenVehicle = vehicleData.vehicle
    close()
end

function close()
    Menu.hidden = true
    ClearMenu()
    QB.ShowroomVehicles[currentCarKey].inUse = false
    TriggerServerEvent('qb-vehicleshop:server:setShowroomCarInUse', currentCarKey, false)
    inMenu = false
    currentCarKey, currentCarValue = nil
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(QB.ShowroomVehicles) do
        local oldVehicle = GetClosestVehicle(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z, 1.0, 0, 70)
        if oldVehicle ~= 0 then
            QBCore.Functions.DeleteVehicle(oldVehicle)
        end

        QBCore.Functions.SpawnVehicle(QB.ShowroomVehicles[k].defaultVehicle, function(veh)
            SetEntityHeading(veh, QB.ShowroomVehicles[k].coords.h)
            SetVehicleDoorsLocked(veh, 3)
        end, QB.ShowroomVehicles[k].coords)
    end
end)

Citizen.CreateThread(function()
    while true do
        
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k, v in pairs(QB.ShowroomVehicles) do
            local dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z)

            if dist < 2.5 then
                if not QB.ShowroomVehicles[k].inUse then
                    local vehicleHash = GetHashKey(QB.ShowroomVehicles[k].chosenVehicle)
                    local displayName = GetDisplayNameFromVehicleModel(vehicleHash)

                    if QB.ShowroomVehicles[k].chosenVehicle ~= "retrieving" then
                        DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.5, '~g~G~w~ - Om voertuig te veranderen: ~b~'..displayName)
                        DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.35, '~g~E~w~ - Om voertuig te kopen')
                    else
                        DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.35, 'Voertuig word opgehaald, een moment geduld...')
                    end

                    if IsControlJustPressed(0, Keys["G"]) then
                        MenuVehicleList()
                        Menu.hidden = not Menu.hidden
                        currentCarKey, currentCarValue = k, v
                        TriggerServerEvent('qb-vehicleshop:server:setShowroomCarInUse', k, true)
                        inMenu = true
                    end

                    if IsControlJustPressed(0, Keys["E"]) then
                        local class = GetVehicleClassFromName(GetHashKey(QB.ShowroomVehicles[k].chosenVehicle))
                        TriggerServerEvent('qb-vehicleshop:server:buyShowroomVehicle', QB.ShowroomVehicles[k].chosenVehicle, QB.Classes[class])
                    end

                    if not Menu.hidden then
                        Menu.renderGUI()
                    end
                elseif QB.ShowroomVehicles[k].inUse and inMenu then
                    local vehicleHash = GetHashKey(QB.ShowroomVehicles[k].chosenVehicle)
                    local displayName = GetDisplayNameFromVehicleModel(vehicleHash)

                    if QB.ShowroomVehicles[k].chosenVehicle ~= "retrieving" then
                        DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.5, '~g~G~w~ - Om voertuig te veranderen: ~b~'..displayName)
                        DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.35, '~g~E~w~ - Om voertuig te kopen')
                    else
                        DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.35, 'Voertuig word opgehaald, een moment geduld...')
                    end

                    if not Menu.hidden then
                        Menu.renderGUI()
                    end

                    if dist > 2.49 then
                        if not Menu.hidden then
                            close()
                            print('Menu closed')
                        end
                    end
                else
                    DrawText3Ds(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z + 0.5, 'Voertuig is in gebruik')
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-vehicleshop:client:setShowroomCarInUse')
AddEventHandler('qb-vehicleshop:client:setShowroomCarInUse', function(showroomVehicle, inUse)
    QB.ShowroomVehicles[showroomVehicle].inUse = inUse
end)

RegisterNetEvent('qb-vehicleshop:client:buyShowroomVehicle')
AddEventHandler('qb-vehicleshop:client:buyShowroomVehicle', function(vehicle, plate)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, QB.DefaultBuySpawn.h)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
    end, QB.DefaultBuySpawn)
end)