local inTrunk = false

local disabledTrunk = {
    [1] = "penetrator",
    [2] = "vacca",
    [3] = "monroe",
    [4] = "turismor",
    [5] = "osiris",
    [6] = "comet",
    [7] = "ardent",
    [8] = "jester",
    [9] = "nero",
    [10] = "nero2",
    [11] = "vagner",
    [12] = "infernus",
    [13] = "zentorno",
    [14] = "comet2",
    [15] = "comet3",
    [16] = "comet4",
    [17] = "lp700r",
    [18] = "r8ppi",
    [19] = "911turbos",
    [20] = "rx7rb",
    [21] = "fnfrx7",
    [22] = "delsoleg",
    [23] = "s15rb",
    [24] = "gtr",
    [25] = "fnf4r34",
    [26] = "ap2",
    [27] = "bullet",
}

function loadDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

function disabledCarCheck(veh)
    for i=1,#disabledTrunk do
        if GetEntityModel(veh) == GetHashKey(disabledTrunk[i]) then
            return true
        end
    end
    return false
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

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

function TrunkCam(bool)
    local ped = GetPlayerPed(-1)
    local vehicle = GetEntityAttachedTo(PlayerPedId())
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
    else
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        cam = nil
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local vehicle = GetEntityAttachedTo(PlayerPedId())
        local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
    
        local vehHeading = GetEntityHeading(vehicle)

        if cam ~= nil then
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('qb-smallresources:trunk:client:getInTrunk')
AddEventHandler('qb-smallresources:trunk:client:getInTrunk', function()
    local ped = GetPlayerPed(-1)
    local closestVehicle = getNearestVeh()
    local plate = GetVehicleNumberPlateText(closestVehicle)
    local vehClass = GetVehicleClass(closestVehicle)

    if Config.TrunkClasses[vehClass].allowed then
        QBCore.Functions.TriggerCallback('qb-smallresources:trunk:server:getTrunkBusy', function(isBusy)
            if not disabledCarCheck(closestVehicle) then
                if closestVehicle ~= 0 then
                    if not inTrunk then
                        if not isBusy then
                            if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                                offset = {
                                    x = Config.TrunkClasses[vehClass].x,
                                    y = Config.TrunkClasses[vehClass].y,
                                    z = Config.TrunkClasses[vehClass].z,
                                }
                                loadDict("fin_ext_p1-7")
                                TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                                -- AttachEntityToEntity(ped, closestVehicle, -1, 0.0, -2.0, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                AttachEntityToEntity(ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
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
                else
                    QBCore.Functions.Notify('Geen voertuig te bekennen..', 'error', 2500)
                end
            else
                QBCore.Functions.Notify('Dit voertuig kan je niet in de kofferbak..', 'error', 2500)
            end
        else
            QBCore.Functions.Notify('Dit voertuig kan je niet in de kofferbak..', 'error', 2500)
        end
    end, plate)
end)

Citizen.CreateThread(function()
    while true do

        if inTrunk then
            local ped = GetPlayerPed(-1)
            local vehicle = GetEntityAttachedTo(PlayerPedId())
            local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
            local plate = GetVehicleNumberPlateText(vehicle)

            if DoesEntityExist(vehicle) then
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
                        if not IsVehicleSeatFree(vehicle, -1) then
                            TriggerServerEvent('qb-radialmenu:trunk:server:Door', false, plate, 5)
                        else
                            SetVehicleDoorShut(vehicle, 5, false)
                        end
                    end
                else
                    DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5, '[G] Kofferbak te openen')
                    if IsControlJustPressed(0, Keys["G"]) then
                        if not IsVehicleSeatFree(vehicle, -1) then
                            TriggerServerEvent('qb-radialmenu:trunk:server:Door', true, plate, 5)
                        else
                            SetVehicleDoorOpen(vehicle, 5, false, false)
                        end
                    end
                end
            end
        end

        if not inTrunk then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)