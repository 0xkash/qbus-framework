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

Citizen.CreateThread(function()
    while true do

        if IsControlJustPressed(0, 51) then
            openVehicleShop(true)
        end

        Citizen.Wait(3)
    end
end)

RegisterNUICallback('GetCategoryVehicles', function(data)
    setupVehicles(data.selectedCategory)
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)