local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

QBCore = nil

local HasKey = false
local LastVehicle = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) and QBCore ~= nil then
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
            if LastVehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false) then
                QBCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
                    if result then
                        HasKey = true
                        SetVehicleEngineOn(veh, true, false, true)
                    else
                        HasKey = false
                    end
                end, plate)
            end

        end

        if not HasKey and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) and not IsLockPicking then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
            local vehpos = GetEntityCoords(veh, false)
            SetVehicleEngineOn(veh, false, false, true)
            QBCore.Functions.DrawText3D(vehpos.x, vehpos.y, vehpos.z, "Je hebt ~r~geen~w~ sleutels")
            LastVehicle = veh
        end

        if IsControlJustPressed(0, Keys["L"]) then
            LockVehicle()
        end
    end
end)

RegisterNetEvent('vehiclekeys:client:SetOwner')
AddEventHandler('vehiclekeys:client:SetOwner', function(plate)
    local VehPlate = plate
    if VehPlate == nil then
        VehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
    end
    TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', VehPlate)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), true), true, false, true)
    end
end)

RegisterNetEvent('vehiclekeys:client:GiveKeys')
AddEventHandler('vehiclekeys:client:GiveKeys', function(target)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
    TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', plate, target)
end)

RegisterNetEvent('vehiclekeys:client:ToggleEngine')
AddEventHandler('vehiclekeys:client:ToggleEngine', function()
    local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if HasKey then
        if EngineOn then
            SetVehicleEngineOn(veh, false, false, true)
        else
            SetVehicleEngineOn(veh, true, false, true)
        end
    end
end)

function LockVehicle()
    local veh = QBCore.Functions.GetClosestVehicle()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local vehpos = GetEntityCoords(veh, false)
    if veh ~= nil and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0 then
        QBCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
            if result then
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,8.0, -8.0, -1, 49, 0, false, false, false)
                if(vehLockStatus < 2)then
                    Citizen.Wait(750)
                    ClearPedTasks(GetPlayerPed(-1))
                    vehLockStatus = 4
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                    SetVehicleDoorsLocked(veh, vehLockStatus)
                    SetVehicleDoorsLockedForAllPlayers(veh, true)
                    QBCore.Functions.Notify("Voertuig staat op slot..")
                elseif(vehLockStatus > 2)then
                    Citizen.Wait(750)
                    ClearPedTasks(GetPlayerPed(-1))
                    vehLockStatus = 1
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                    SetVehicleDoorsLocked(veh, vehLockStatus)
                    SetVehicleDoorsLockedForAllPlayers(veh, false)
                    QBCore.Functions.Notify("Voertuig staat op open..")
                end
            end
        end, GetVehicleNumberPlateText(veh))
    end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end