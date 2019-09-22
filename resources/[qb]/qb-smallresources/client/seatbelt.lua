local seatbeltOn = false
local SpeedBuffer = {}
local vehVelocity = {x = 0.0, y = 0.0, z = 0.0}
local vehHealth = 0.0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            --
        else
            seatbeltOn = false
        end
        
        if IsControlJustReleased(0, Keys["G"]) then 
            if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
                if seatbeltOn then
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
                else
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "carbuckle", 0.25)
                end
                TriggerEvent("seatbelt:client:ToggleSeatbelt")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            SpeedBuffer[2] = SpeedBuffer[1]
            SpeedBuffer[1] = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        end
    end
end)

local thresholdSpeed = 45
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            if not seatbeltOn or (math.floor(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * 3.6)) > 180 then
                local ForwardSpeed = GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true).y > 1.0
                vehHealth = GetEntityHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                Citizen.Wait(20)
                if (vehHealth ~= GetEntityHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
                    if (ForwardSpeed and SpeedBuffer[2] ~= nil and (SpeedBuffer[2] > (thresholdSpeed / 3.6)) and (SpeedBuffer[2] - SpeedBuffer[1]) > (SpeedBuffer[1] * 0.178)) then
                        local pos = GetEntityCoords(GetPlayerPed(-1))
                        local fwd = GetFwd(GetPlayerPed(-1))
                        SetEntityCoords(GetPlayerPed(-1), pos.x + fwd.x, pos.y + fwd.y, pos.z - 0.47, true, true, true)
                        SetEntityVelocity(GetPlayerPed(-1), vehVelocity.x, vehVelocity.y, vehVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                    else
                        vehVelocity = GetEntityVelocity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                    end
                end
            end
        end
    end
end)

function GetFwd(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 5.73, y = math.sin(hr) * 5.73 }
end

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function()
    seatbeltOn = not seatbeltOn
end)