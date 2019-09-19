local seatbeltOn = false
local prevSpeed = 0.0
local Speed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local vehHealth = 0.0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            prevSpeed = Speed
            Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1)))
            vehHealth = GetEntityHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        else
            seatbeltOn = false
        end
        
        if IsControlJustReleased(0, Keys["G"]) then 
            if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
                if seatbeltOn then
                    --seatbelt off sound
                else
                    --seatbelt on sound
                end
                TriggerEvent("seatbelt:client:ToggleSeatbelt")
            end
        end
    end
end)

local thresholdSpeed = 45
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            if not seatbeltOn or (GetEntitySpeed(GetPlayerPed(-1)) * 3.6) > 180 then
                local ForwardSpeed = GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true).y > 1.0
                local vehAcc = (prevSpeed - Speed) / GetFrameTime()
                local position = GetEntityCoords(GetPlayerPed(-1))
                if (vehHealth ~= GetEntityHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
                    if (ForwardSpeed and (prevSpeed > (thresholdSpeed / 3.6)) and (vehAcc > (thresholdSpeed * 6.81))) then
                        SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(GetPlayerPed(-1), (prevVelocity.x + (1.34 * 3.6)), prevVelocity.y, prevVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                    else
                        prevVelocity = GetEntityVelocity(veh)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function()
    seatbeltOn = not seatbeltOn
end)