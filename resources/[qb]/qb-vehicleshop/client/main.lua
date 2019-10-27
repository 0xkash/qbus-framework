QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

--- CODE

local inVehicleShop = false

function openVehicleShop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        ui = bool
    })
end

function setupVehicles(category)
    SendNUIMessage({
        action = "setupVehicles",
        vehicles = QB.Vehicles[category]
    })
end

RegisterNUICallback('GetCategoryVehicles', function(data)
    setupVehicles(data.selectedCategory)
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)

RegisterNUICallback('buyVehicle', function(data)
    local vehicleData = data.vehicleData
    local garage = data.garage

    TriggerServerEvent('qb-vehicleshop:server:buyVehicle', vehicleData, garage)
    openVehicleShop(false)
end)

RegisterNetEvent('qb-vehicleshop:client:spawnBoughtVehicle')
AddEventHandler('qb-vehicleshop:client:spawnBoughtVehicle', function(vehicle)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, QB.SpawnPoint.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    end, QB.SpawnPoint, true)
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k, v in pairs(QB.VehicleShops) do
            local dist = GetDistanceBetweenCoords(pos, QB.VehicleShops[k].x, QB.VehicleShops[k].y, QB.VehicleShops[k].z)
            if dist <= 15 then
                DrawMarker(2, QB.VehicleShops[k].x, QB.VehicleShops[k].y, QB.VehicleShops[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if dist <= 1.5 then
                    QBCore.Functions.DrawText3D(QB.VehicleShops[k].x, QB.VehicleShops[k].y, QB.VehicleShops[k].z + 0.3, '~g~E~w~ - Premium Deluxe Motorsports')
                    if IsControlJustPressed(0, 51) then
                        openVehicleShop(true)
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(QB.VehicleShops) do
        Dealer = AddBlipForCoord(QB.VehicleShops[k].x, QB.VehicleShops[k].y, QB.VehicleShops[k].z)

        SetBlipSprite (Dealer, 326)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.75)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Premium Deluxe Motorsports")
        EndTextCommandSetBlipName(Dealer)
    end
end)