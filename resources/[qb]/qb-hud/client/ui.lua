local speed = 0.0
Citizen.CreateThread(function()
    while true do 
        if showUI then
            speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
            local pos = GetEntityCoords(player)
            local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                health = (GetEntityHealth(GetPlayerPed(-1)) / 2),
                armor = GetPedArmour(GetPlayerPed(-1)),
                stamina = (100 - GetPlayerSprintStaminaRemaining(PlayerId())),
                direction = GetDirectionText(GetEntityHeading(GetPlayerPed(-1))),
                street1 = GetStreetNameFromHashKey(street1),
                street2 = GetStreetNameFromHashKey(street2),
                area = current_zone,
                speed = math.ceil(speed),
            })
            Citizen.Wait(500)
        else
            Citizen.Wait(100)
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) and showUI then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
        end
    end
end)

function GetDirectionText(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "Noord"
    elseif (heading >= 45 and heading < 135) then
        return "Oost"
    elseif (heading >=135 and heading < 225) then
        return "Zuid"
    elseif (heading >= 225 and heading < 315) then
        return "West"
    end
end