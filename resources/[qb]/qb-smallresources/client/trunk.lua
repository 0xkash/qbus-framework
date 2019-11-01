local inTrunk = false

local geluidjes = {
    [1] = "*fart*"
}

function loadDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

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

RegisterNetEvent('qb-smallresources:trunk:client:getInTrunk')
AddEventHandler('qb-smallresources:trunk:client:getInTrunk', function()
    local ped = GetPlayerPed(-1)
    local closestVehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    local plate = GetVehicleNumberPlateText(closestVehicle)

    QBCore.Functions.TriggerCallback('qb-smallresources:trunk:server:getTrunkBusy', function(isBusy)
        if closestVehicle ~= 0 then
            if not inTrunk then
                if not isBusy then
                    if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                        AttachEntityToEntity(ped, closestVehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
                        loadDict('timetable@floyd@cryingonbed@base')
                        TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                        TriggerServerEvent('qb-smallresources:trunk:server:setTrunkBusy', plate, true)
                        inTrunk = true
                        Citizen.Wait(500)
                        SetVehicleDoorShut(closestVehicle, 5, false)
                        QBCore.Functions.Notify('Je ligt in de kofferbak, /kofferbak om er uit te gaan.', 'success', 4000)
                    else
                        QBCore.Functions.Notify('Is de kofferbak dicht?', 'error', 2500)
                    end
                else
                    QBCore.Functions.Notify('Ziet er al iemand in?', 'error', 2500)
                end
            else
                SetVehicleDoorOpen(closestVehicle, 5, false)
                Citizen.Wait(500)
                local vehCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0, -3.5, 0)
                DetachEntity(ped, true, true)
                ClearPedTasks(ped)
                inTrunk = false
                TriggerServerEvent('qb-smallresources:trunk:server:setTrunkBusy', plate, nil)
                SetEntityCoords(ped, vehCoords.x, vehCoords.y, vehCoords.z)
                SetEntityCollision(PlayerPedId(), true, true)
            end
        else
            print('yeet')
        end
    end, plate)
end)

Citizen.CreateThread(function()
    while true do
        if inTrunk then
            local vehCoords = GetEntityCoords(GetPlayerPed(-1))
            local randomText = math.random(10)

            print(randomText)

            DrawText3Ds(vehCoords.x, vehCoords.y, vehCoords.z, '~g~E~w~ Om geluidje te maken')

            if IsControlJustPressed(0, 51) then
                TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
            end
        end
        Citizen.Wait(3)
    end
end)