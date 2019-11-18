QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local isLoggedIn = false
local PlayerData = {}

local meterIsOpen = false

local meterActive = false
local currentTaxi = nil

local lastLocation = nil

local meterData = {
    fareAmount = 3,
    currentFare = 0,
    distanceTraveled = 0,
}

local dutyPlate = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

Citizen.CreateThread(function()
    while true do
  
        Citizen.Wait(2000)
        calculateFareAmount()
    end
end)

function calculateFareAmount()
    if meterIsOpen and meterActive then
        start = lastLocation
  
        if start then
            current = GetEntityCoords(GetPlayerPed(-1))
            distance = CalculateTravelDistanceBetweenPoints(start, current)
            meterData['distanceTraveled'] = distance
    
            fareAmount = (meterData['distanceTraveled'] / 400.00) * meterData['fareAmount']
    
            meterData['currentFare'] = math.ceil(fareAmount)

            SendNUIMessage({
                action = "updateMeter",
                meterData = meterData
            })
        end
    end
end

Citizen.CreateThread(function()
    while true do

        inRange = false

        if QBCore ~= nil then
            if isLoggedIn then

                if PlayerData.job.name == "taxi" then
                    local ped = GetPlayerPed(-1)
                    local pos = GetEntityCoords(ped)

                    local vehDist = GetDistanceBetweenCoords(pos, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

                    if vehDist < 30 then
                        inRange = true

                        DrawMarker(2, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"], 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if vehDist < 1.5 then
                            if whitelistedVehicle() then
                                DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, '[E] Voertuig Parkeren')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                    end
                                end
                            else
                                DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, '[E] Voertuig Pakken')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TaxiGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(3000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-taxi:client:toggleMeter')
AddEventHandler('qb-taxi:client:toggleMeter', function()
    local ped = GetPlayerPed(-1)
    
    if IsPedInAnyVehicle(ped, false) then
        if whitelistedVehicle() then
            if not meterIsOpen then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    meterData = Config.Meter
                })
                meterIsOpen = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                meterIsOpen = false
            end
        else
            QBCore.Functions.Notify('Dit voertuig heeft geen Taxi Meter..', 'error')
        end
    else
        QBCore.Functions.Notify('Je zit niet in een voertuig..', 'error')
    end
end)

RegisterNetEvent('qb-taxi:client:enableMeter')
AddEventHandler('qb-taxi:client:enableMeter', function()
    local ped = GetPlayerPed(-1)

    if meterIsOpen then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        QBCore.Functions.Notify('De Taxi Meter is niet actief..', 'error')
    end
end)

RegisterNUICallback('enableMeter', function(data)
    meterActive = data.enabled

    if not data.enabled then
        SendNUIMessage({
            action = "resetMeter"
        })
    end
    lastLocation = GetEntityCoords(GetPlayerPed(-1))
end)

RegisterNetEvent('qb-taxi:client:toggleMuis')
AddEventHandler('qb-taxi:client:toggleMuis', function()
    Citizen.Wait(400)
    if meterIsOpen then
        if not mouseActive then
            SetNuiFocus(true, true)
            mouseActive = true
        end
    else
        QBCore.Functions.Notify('Geen Taxi Meter te bekennen..', 'error')
    end
end)

RegisterNUICallback('hideMouse', function()
    SetNuiFocus(false, false)
    mouseActive = false
end)

function whitelistedVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    return retval
end

function TaxiGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Voertuigen", "VehicleList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function VehicleList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.AllowedVehicles) do
        Menu.addButton(Config.AllowedVehicles[k].label, "TakeVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "TaxiGarage",nil)
end

function TakeVehicle(k)
    local coords = {x = Config.Locations["vehicle"]["x"], y = Config.Locations["vehicle"]["y"], z = Config.Locations["vehicle"]["z"]}
    QBCore.Functions.SpawnVehicle(Config.AllowedVehicles[k].model, function(veh)
        SetVehicleNumberPlateText(veh, "TAXI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Config.Locations["vehicle"]["h"])
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        dutyPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3D(x, y, z, text)
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

Citizen.CreateThread(function()
    TaxiBlip = AddBlipForCoord(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

    SetBlipSprite (TaxiBlip, 198)
    SetBlipDisplay(TaxiBlip, 4)
    SetBlipScale  (TaxiBlip, 0.6)
    SetBlipAsShortRange(TaxiBlip, true)
    SetBlipColour(TaxiBlip, 5)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Downtown Cab")
    EndTextCommandSetBlipName(TaxiBlip)
end)