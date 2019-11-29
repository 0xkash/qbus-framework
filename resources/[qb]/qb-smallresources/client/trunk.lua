local inTrunk = false

local geluidjes = {
    [1] = "*fart*",
    [2] = "*fart*",
    [3] = "*fart*",
    [4] = "*fart*",
    [5] = "*fart*",
    [6] = "*fart*",
    [7] = "*fart*",
    [8] = "*fart*",
    [9] = "*fart*",
    [10] = "*fart*",
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

local cam = nil

function TrunkCam(bool)
    local ped = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)

    local vehHeading = GetEntityHeading(vehicle)

    if bool then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if not DoesCamExist(cam) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamActive(cam, true)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            RenderScriptCams(true, false, 0, true, true)
        end
        Citizen.CreateThread(function()
            while true do
                local ped = GetPlayerPed(-1)
                local vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
                local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
            
                local vehHeading = GetEntityHeading(vehicle)
        
                if cam ~= nil then
                    SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
                else
                    break
                end
        
                Citizen.Wait(3)
            end
        end)
    else
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        cam = nil
    end
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
                        AttachEntityToEntity(ped, closestVehicle, -1, 0.0, -2.0, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                        loadDict('timetable@floyd@cryingonbed@base')
                        TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                        TriggerServerEvent('qb-smallresources:trunk:server:setTrunkBusy', plate, true)
                        inTrunk = true
                        Citizen.Wait(500)
                        SetVehicleDoorShut(closestVehicle, 5, false)
                        QBCore.Functions.Notify('Je ligt in de kofferbak.', 'success', 4000)
                        TrunkCam(true)
                    else
                        QBCore.Functions.Notify('Is de kofferbak dicht?', 'error', 2500)
                    end
                else
                    QBCore.Functions.Notify('Ziet er al iemand in?', 'error', 2500)
                end
            else
                QBCore.Functions.Notify('Je ligt al in de kofferbak', 'error', 2500)
            end
        end
    end, plate)
end)

Citizen.CreateThread(function()
    while true do

        if inTrunk then
            local ped = GetPlayerPed(-1)
            local vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
            local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
            local plate = GetVehicleNumberPlateText(vehicle)

            DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.75, '[E] Om uit kofferbak te stappen')

            if IsControlJustPressed(0, Keys["E"]) then
                if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                    local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
                    DetachEntity(ped, true, true)
                    ClearPedTasks(ped)
                    inTrunk = false
                    TriggerServerEvent('qb-smallresources:trunk:server:setTrunkBusy', plate, nil)
                    SetEntityCoords(ped, vehCoords.x, vehCoords.y, vehCoords.z)
                    SetEntityCollision(PlayerPedId(), true, true)
                    TrunkCam(false)
                else
                    QBCore.Functions.Notify('Is de kofferbak dicht?', 'error', 2500)
                end
            end

            if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5, '[G] Kofferbak te sluiten')
                if IsControlJustPressed(0, Keys["G"]) then
                    SetVehicleDoorShut(vehicle, 5, false)
                end
            else
                DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5, '[G] Kofferbak te openen')
                if IsControlJustPressed(0, Keys["G"]) then
                    SetVehicleDoorOpen(vehicle, 5, false)
                end
            end
        end

        if not inTrunk then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)