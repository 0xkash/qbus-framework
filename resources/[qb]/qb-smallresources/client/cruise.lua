local cruiseOn = false
local Speed = 0.0
local cruiseSpeed = 0.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1)))
        end
        if IsControlJustReleased(0, Keys["B"]) then 
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                cruiseSpeed = Speed
                if cruiseOn then
                    QBCore.Functions.Notify("Begrenzer uitgeschakeld!")
                else
                    QBCore.Functions.Notify("Begrenzer gezet op "..tostring(math.floor(cruiseSpeed * 3.6)).."km/u")
                end
                TriggerEvent("seatbelt:client:ToggleCruise")
            else
                cruiseOn = false
            end
        end
    end
end)

RegisterNetEvent("seatbelt:client:ToggleCruise")
AddEventHandler("seatbelt:client:ToggleCruise", function()
    cruiseOn = not cruiseOn
    local maxSpeed = cruiseOn and cruiseSpeed or GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false),"CHandlingData","fInitialDriveMaxFlatVel")
    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), maxSpeed)
end)