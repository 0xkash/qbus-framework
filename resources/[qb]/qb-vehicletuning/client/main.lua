QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

local ModdedVehicles = {}
local VehicleStatus = {}
isLoggedIn = false
PlayerJob = {}

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

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
    isLoggedIn = true

    QBCore.Functions.TriggerCallback('qb-vehicletuning:server:GetAttachedVehicle', function(veh)
        Config.AttachedVehicle = veh
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

Citizen.CreateThread(function()
    Wait(250)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
    isLoggedIn = true
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        if isLoggedIn then
            if PlayerJob.name == "mechanic" then
                local coords = {
                    [1] = Config.Locations[1],
                    [2] = Config.Locations[2],
                    [3] = Config.Locations[3],
                } 
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local dist1 = GetDistanceBetweenCoords(pos, coords[1].x, coords[1].y, coords[1].z)
                local dist2 = GetDistanceBetweenCoords(pos, coords[2].x, coords[2].y, coords[2].z)
                if dist1 < 20 then
                    inRange = true

                    if Config.AttachedVehicle == nil then
                        DrawMarker(2, coords[1].x, coords[1].y, coords[1].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                        if dist1 < 2 then
                            local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
                            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                if not IsThisModelABicycle(GetEntityModel(veh)) then
                                    DrawText3Ds(coords[1].x, coords[1].y, coords[1].z, "[E] Voertuig op de plaat zetten")
                                    if IsControlJustPressed(0, Config.Keys["E"]) then
                                        DoScreenFadeOut(150)
                                        Wait(150)
                                        Config.AttachedVehicle = veh
                                        SetEntityCoords(veh, coords[1].x, coords[1].y, coords[1].z)
                                        SetEntityHeading(veh, coords[1].h)
                                        FreezeEntityPosition(veh, true)
                                        SetEntityCoords(GetPlayerPed(-1), coords[2].x, coords[2].y, coords[2].z)
                                        SetEntityHeading(GetPlayerPed(-1), coords[2].h)
                                        Wait(500)
                                        DoScreenFadeIn(250)
                                        TriggerServerEvent('qb-vehicletuning:server:SetAttachedVehicle', veh)
                                    end
                                else
                                    QBCore.Functions.Notify("Je kan geen fietsen op de plaat zetten!", "error")
                                end
                            else
                                DrawText3Ds(coords[1].x, coords[1].y, coords[1].z, "Je moet in een voertuig zitten!")
                            end
                        end
                    end
                end

                if dist2 < 20 then
                    DrawMarker(2, coords[2].x, coords[2].y, coords[2].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                    if dist2 < 1.2 then
                        local text = "Er staat nog geen voertuig op de plaat"
                        if Config.AttachedVehicle ~= nil then
                            text = "[E] Menu openen"
                            if IsControlJustPressed(0, Keys["E"]) then
                                OpenMenu()
                                Menu.hidden = not Menu.hidden
                            end
                            Menu.renderGUI()
                        end
                        DrawText3Ds(coords[2].x, coords[2].y, coords[2].z, text)
                    elseif dist2 > 1.1 then
                        if not Menu.hidden then
                            CloseMenu()
                        end
                    end
                end

                if not inRange then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end

        Citizen.Wait(3)
    end
end)

function OpenMenu()
    ClearMenu()
    Menu.addButton("Opties", "VehicleOptions", nil)
    Menu.addButton("Sluit Menu", "CloseMenu", nil) 
end

function VehicleOptions()
    ClearMenu()
    Menu.addButton("Voertuig Loskoppelen", "UnattachVehicle", nil)
    Menu.addButton("Check Status", "CheckStatus", nil)
    Menu.addButton("Onderdelen", "PartsMenu", nil)
    Menu.addButton("Sluit Menu", "CloseMenu", nil)
    SetVehicleDoorsShut(Config.AttachedVehicle)
end

local Doors = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
}

function PartsMenu()
    ClearMenu()
    for k, v in pairs(Doors) do
        SetVehicleDoorOpen(Config.AttachedVehicle, v, false, false)
    end
    local plate = GetVehicleNumberPlateText(Config.AttachedVehicle)
    if VehicleStatus[plate] ~= nil then
        for k, v in pairs(Config.ValuesLabels) do
            Menu.addButton(v..": "..math.ceil(VehicleStatus[plate][k]), "PartMenu", k) 
        end
    else
        for k, v in pairs(Config.ValuesLabels) do
            Menu.addButton(v..": "..Config.MaxStatusValues[k], "VehicleOptions", nil) 
        end
    end
    Menu.addButton("Terug", "VehicleOptions", nil) 
    Menu.addButton("Sluit Menu", "CloseMenu", nil) 
end

function CheckStatus()
    local plate = GetVehicleNumberPlateText(Config.AttachedVehicle)
    SendStatusMessage(VehicleStatus[plate])
end

function PartMenu(part)
    ClearMenu()
    Menu.addButton("Repareer ("..Config.ValuesLabels[part]..")", "RepairPart", part)
    Menu.addButton("Terug", "VehicleOptions", nil)
    Menu.addButton("Sluit Menu", "CloseMenu", nil) 
end

function RepairPart(part)
    local plate = GetVehicleNumberPlateText(Config.AttachedVehicle)
    TriggerServerEvent('qb-vehicletuning:server:SetPartLevel', plate, part, Config.MaxStatusValues[part])
    QBCore.Functions.Notify(Config.ValuesLabels[part].." is gerepareerd!", "success")
    PartsMenu()
end

function UnattachVehicle()
    local coords = {
        [1] = Config.Locations[1],
        [2] = Config.Locations[2],
        [3] = Config.Locations[3],
    } 

    DoScreenFadeOut(150)
    Wait(150)
    FreezeEntityPosition(Config.AttachedVehicle, false)
    SetEntityCoords(Config.AttachedVehicle, coords[3].x, coords[3].y, coords[3].z)
    SetEntityHeading(Config.AttachedVehicle, coords[3].h)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), Config.AttachedVehicle, -1)
    Wait(500)
    DoScreenFadeIn(250)
    Config.AttachedVehicle = nil
    TriggerServerEvent('qb-vehicletuning:server:SetAttachedVehicle', nil)
end

RegisterNetEvent('qb-vehicletuning:client:SetAttachedVehicle')
AddEventHandler('qb-vehicletuning:client:SetAttachedVehicle', function(veh)
    Config.AttachedVehicle = veh
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
            if ModdedVehicles[tostring(veh)] == nil and not IsThisModelABicycle(GetEntityModel(veh)) then
                --[[local fSteeringLock = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock')
                fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1

                SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)]]--

                local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel')
                if IsThisModelABike(GetEntityModel(veh)) then
                    local fTractionCurveMin = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin')

                    fTractionCurveMin = fTractionCurveMin * 0.6
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)
                    SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)   

                    local fTractionCurveMax = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax')

                    fTractionCurveMax = fTractionCurveMax * 0.6
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)
                    SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)

                    local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
                    fInitialDriveForce = fInitialDriveForce * 2.4
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)

                    local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')
                    fBrakeForce = fBrakeForce * 1.4
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)
                    
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)
                    SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)
                    SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)
                    SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.500000)
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.120000)
                else
                    local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')
                    fBrakeForce = fBrakeForce * 0.5
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)

                    local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
                    if fInitialDriveForce < 0.289 then
                        fInitialDriveForce = fInitialDriveForce * 1.2
                        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)
                    else
                        fInitialDriveForce = fInitialDriveForce * 0.9
                        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)
                    end
                                
                    local fInitialDragCoeff = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff')
                    fInitialDragCoeff = fInitialDragCoeff * 0.3
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', fInitialDragCoeff)

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.100000)
                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.900000)

                end
                SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDeformationDamageMult', 1.000000)
                SetVehicleHasBeenOwnedByPlayer(veh,true)
                ModdedVehicles[tostring(veh)] = { 
                    ["fInitialDriveMaxFlatVel"] = fInitialDriveMaxFlatVel, 
                    ["fSteeringLock"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock'), 
                    ["fTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionLossMult'), 
                    ["fLowSpeedTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult') 
                }
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)
local effectTimer = 0
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
            if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                local engineHealth = GetVehicleEngineHealth(veh)
                local bodyHealth = GetVehicleBodyHealth(veh)
                local plate = GetVehicleNumberPlateText(veh)
                if VehicleStatus[plate] == nil then 
                    TriggerServerEvent("vehiclemod:server:setupVehicleStatus", plate, engineHealth, bodyHealth)
                else
                    TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", engineHealth)
                    TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", bodyHealth)
                    effectTimer = effectTimer + 1
                    if effectTimer >= math.random(10, 15) then
                        ApplyEffects(veh)
                        effectTimer = 0
                    end
                end
            else
                effectTimer = 0
                Citizen.Wait(1000)
            end
        else
            effectTimer = 0
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('vehiclemod:client:setVehicleStatus')
AddEventHandler('vehiclemod:client:setVehicleStatus', function(plate, status)
    VehicleStatus[plate] = status
end)

RegisterNetEvent('vehiclemod:client:getVehicleStatus')
AddEventHandler('vehiclemod:client:getVehicleStatus', function(plate, status)
    if not (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if veh ~= nil and veh ~= 0 then
            local vehpos = GetEntityCoords(veh)
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0 then
                if not IsThisModelABicycle(GetEntityModel(veh)) then
                    local plate = GetVehicleNumberPlateText(veh)
                    if VehicleStatus[plate] ~= nil then 
                        SendStatusMessage(VehicleStatus[plate])
                    else
                        QBCore.Functions.Notify("Geen status bekend..", "error")
                    end
                else
                    QBCore.Functions.Notify("Geen geldig voertuig..", "error")
                end
            else
                QBCore.Functions.Notify("Je staat niet dicht genoeg bij het voertuig..", "error")
            end
        else
            QBCore.Functions.Notify("Je moet eerst in het voertuig zitten..", "error")
        end
    else
        QBCore.Functions.Notify("Je moet buiten het voertuig staan..", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:fixEverything')
AddEventHandler('vehiclemod:client:fixEverything', function()
    if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            local plate = GetVehicleNumberPlateText(veh)
            TriggerServerEvent("vehiclemod:server:fixEverything", plate)
        else
            QBCore.Functions.Notify("Je bent geen bestuurder of zit op een fiets..", "error")
        end
    else
        QBCore.Functions.Notify("Je zit niet in een voertuig..", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:setPartLevel')
AddEventHandler('vehiclemod:client:setPartLevel', function(part, level)
    if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            local plate = GetVehicleNumberPlateText(veh)
            if part == "engine" then
                SetVehicleEngineHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", GetVehicleEngineHealth(veh))
            elseif part == "body" then
                SetVehicleBodyHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", GetVehicleBodyHealth(veh))
            else
                TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
            end
        else
            QBCore.Functions.Notify("Je bent geen bestuurder of zit op een fiets..", "error")
        end
    else
        QBCore.Functions.Notify("Je zit niet in een voertuig..", "error")
    end
end)
local openingDoor = false

RegisterNetEvent('vehiclemod:client:repairPart')
AddEventHandler('vehiclemod:client:repairPart', function(part, level, needAmount)
    -- if CanReapair() then
        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
            if veh ~= nil and veh ~= 0 then
                local vehpos = GetEntityCoords(veh)
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0 then
                    if not IsThisModelABicycle(GetEntityModel(veh)) then
                        local plate = GetVehicleNumberPlateText(veh)
                        if VehicleStatus[plate] ~= nil and VehicleStatus[plate][part] ~= nil then
                            local lockpickTime = (1000 * level)
                            if part == "body" then
                                lockpickTime = lockpickTime / 10
                            end
                            ScrapAnim(lockpickTime)
                            QBCore.Functions.Progressbar("repair_advanced", "Voertuig repareren..", lockpickTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                if part == "body" then
                                    SetVehicleBodyHealth(veh, GetVehicleBodyHealth(veh) + level)
                                    SetVehicleFixed(veh)
                                    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, GetVehicleBodyHealth(veh))
                                    TriggerServerEvent("QBCore:Server:RemoveItem", Config.RepairCost[part], needAmount)
                                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.RepairCost[part]], "remove")
                                elseif part ~= "engine" then
                                    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, GetVehicleStatus(plate, part) + level)
                                    TriggerServerEvent("QBCore:Server:RemoveItem", Config.RepairCost[part], level)
                                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.RepairCost[part]], "remove")
                                end
                            end, function() -- Cancel
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                QBCore.Functions.Notify("Proces geannuleerd..", "error")
                            end)
                        else
                            QBCore.Functions.Notify("Geen geldige onderdeel..", "error")
                        end
                    else
                        QBCore.Functions.Notify("Geen geldig voertuig..", "error")
                    end
                else
                    QBCore.Functions.Notify("Je staat niet dicht genoeg bij het voertuig..", "error")
                end
            else
                QBCore.Functions.Notify("Je moet eerst in het voertuig zitten..", "error")
            end
        else
            QBCore.Functions.Notify("Je zit niet in een voertuig..", "error")
        end
    -- end
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

function CanReapair()
    local retval = false
    for k, v in pairs(Config.Businesses) do
        retval = exports['qb-companies']:IsEmployee(v)
    end
    return retval
end

function ApplyEffects(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if GetVehicleClass(vehicle) ~= 13 and GetVehicleClass(vehicle) ~= 21 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 14 then
        if VehicleStatus[plate] ~= nil then 
            local chance = math.random(1, 100)
            if VehicleStatus[plate]["radiator"] <= 80 and (chance >= 1 and chance <= 20) then
                local engineHealth = GetVehicleEngineHealth(vehicle)
                if VehicleStatus[plate]["radiator"] <= 80 and VehicleStatus[plate]["radiator"] >= 60 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(10, 15))
                elseif VehicleStatus[plate]["radiator"] <= 59 and VehicleStatus[plate]["radiator"] >= 40 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(15, 20))
                elseif VehicleStatus[plate]["radiator"] <= 39 and VehicleStatus[plate]["radiator"] >= 20 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(20, 30))
                elseif VehicleStatus[plate]["radiator"] <= 19 and VehicleStatus[plate]["radiator"] >= 6 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(30, 40))
                else
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(40, 50))
                end
            end

            if VehicleStatus[plate]["axle"] <= 80 and (chance >= 21 and chance <= 40) then
                if VehicleStatus[plate]["axle"] <= 80 and VehicleStatus[plate]["axle"] >= 60 then
                    for i=0,360 do					
                        SetVehicleSteeringScale(vehicle,i)
                        Citizen.Wait(5)
                    end
                elseif VehicleStatus[plate]["axle"] <= 59 and VehicleStatus[plate]["axle"] >= 40 then
                    for i=0,360 do	
                        Citizen.Wait(10)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                elseif VehicleStatus[plate]["axle"] <= 39 and VehicleStatus[plate]["axle"] >= 20 then
                    for i=0,360 do
                        Citizen.Wait(15)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                elseif VehicleStatus[plate]["axle"] <= 19 and VehicleStatus[plate]["axle"] >= 6 then
                    for i=0,360 do
                        Citizen.Wait(20)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                else
                    for i=0,360 do
                        Citizen.Wait(25)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                end
            end

            if VehicleStatus[plate]["brakes"] <= 80 and (chance >= 41 and chance <= 60) then
                if VehicleStatus[plate]["brakes"] <= 80 and VehicleStatus[plate]["brakes"] >= 60 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(1000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 59 and VehicleStatus[plate]["brakes"] >= 40 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(3000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 39 and VehicleStatus[plate]["brakes"] >= 20 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(5000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 19 and VehicleStatus[plate]["brakes"] >= 6 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(7000)
                    SetVehicleHandbrake(vehicle, false)
                else
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(9000)
                    SetVehicleHandbrake(vehicle, false)
                end
            end

            if VehicleStatus[plate]["clutch"] <= 80 and (chance >= 61 and chance <= 80) then
                if VehicleStatus[plate]["clutch"] <= 80 and VehicleStatus[plate]["clutch"] >= 60 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(50)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                    Citizen.Wait(500)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["clutch"] <= 59 and VehicleStatus[plate]["clutch"] >= 40 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(100)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                    Citizen.Wait(750)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["clutch"] <= 39 and VehicleStatus[plate]["clutch"] >= 20 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(150)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                    Citizen.Wait(1000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["clutch"] <= 19 and VehicleStatus[plate]["clutch"] >= 6 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(200)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                    Citizen.Wait(1250)
                    SetVehicleHandbrake(vehicle, false)
                else
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(250)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                    Citizen.Wait(1500)
                    SetVehicleHandbrake(vehicle, false)
                end
            end

            if VehicleStatus[plate]["fuel"] <= 80 and (chance >= 81 and chance <= 100) then
                local fuel = exports['LegacyFuel']:GetFuel(vehicle)
                if VehicleStatus[plate]["fuel"] <= 80 and VehicleStatus[plate]["fuel"] >= 60 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 2.0)
                elseif VehicleStatus[plate]["fuel"] <= 59 and VehicleStatus[plate]["fuel"] >= 40 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 4.0)
                elseif VehicleStatus[plate]["fuel"] <= 39 and VehicleStatus[plate]["fuel"] >= 20 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 6.0)
                elseif VehicleStatus[plate]["fuel"] <= 19 and VehicleStatus[plate]["fuel"] >= 6 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 8.0)
                else
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 10.0)
                end
            end
        end
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function GetVehicleStatusList(plate)
    local retval = nil
    if VehicleStatus[plate] ~= nil then 
        retval = VehicleStatus[plate]
    end
    return retval
end

function GetVehicleStatus(plate, part)
    local retval = nil
    if VehicleStatus[plate] ~= nil then 
        retval = VehicleStatus[plate][part]
    end
    return retval
end

function SetVehicleStatus(plate, part, level)
    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
end

function SendStatusMessage(statusList)
    if statusList ~= nil then 
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message normal"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>'.. Config.ValuesLabels["engine"] ..' (engine):</strong> {1} <br><strong>'.. Config.ValuesLabels["body"] ..' (body):</strong> {2} <br><strong>'.. Config.ValuesLabels["radiator"] ..' (radiator):</strong> {3} <br><strong>'.. Config.ValuesLabels["axle"] ..' (axle):</strong> {4}<br><strong>'.. Config.ValuesLabels["brakes"] ..' (brakes):</strong> {5}<br><strong>'.. Config.ValuesLabels["clutch"] ..' (clutch):</strong> {6}<br><strong>'.. Config.ValuesLabels["fuel"] ..' (fuel):</strong> {7}</div></div>',
            args = {'Voertuig Status', round(statusList["engine"]) .. "/" .. Config.MaxStatusValues["engine"] .. " ("..QBCore.Shared.Items["advancedrepairkit"]["label"]..")", round(statusList["body"]) .. "/" .. Config.MaxStatusValues["body"] .. " ("..QBCore.Shared.Items[Config.RepairCost["body"]]["label"]..")", round(statusList["radiator"]) .. "/" .. Config.MaxStatusValues["radiator"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["radiator"]]["label"]..")", round(statusList["axle"]) .. "/" .. Config.MaxStatusValues["axle"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["axle"]]["label"]..")", round(statusList["brakes"]) .. "/" .. Config.MaxStatusValues["brakes"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["brakes"]]["label"]..")", round(statusList["clutch"]) .. "/" .. Config.MaxStatusValues["clutch"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["clutch"]]["label"]..")", round(statusList["fuel"]) .. "/" .. Config.MaxStatusValues["fuel"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["fuel"]]["label"]..")"}
        })
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 1) .. "f", num))
end

-- Menu Functions


CloseMenu = function()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
    SetVehicleDoorsShut(Config.AttachedVehicle)
end

ClearMenu = function()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end