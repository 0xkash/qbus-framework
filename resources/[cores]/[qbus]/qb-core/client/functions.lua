QBCore.Functions = {}
QBCore.RequestId = 0

QBCore.Functions.GetPlayerData = function(cb)
    if cb ~= nil then
        cb(QBCore.PlayerData)
    else
        return QBCore.PlayerData
    end
end

QBCore.Functions.DrawText = function(x, y, width, height, scale, r, g, b, a, text)
	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

QBCore.Functions.DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    --DrawText(_x,_y)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    --DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
    ClearDrawOrigin()
end

QBCore.Functions.GetCoords = function(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        a = heading
    }
end

QBCore.Functions.SpawnVehicle = function(model, cb, coords, isnetworked)
    local model = (type(model)=="number" and model or GetHashKey(model))
    local coords = coords ~= nil and coords or QBCore.Functions.GetCoords(GetPlayerPed(-1))
    local isnetworked = isnetworked ~= nil and isnetworked or true

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.a, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)

    SetNetworkIdCanMigrate(netid, true)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, "OFF")

    SetModelAsNoLongerNeeded(model)

    if cb ~= nil then
        cb(veh)
    end
end

QBCore.Functions.DeleteVehicle = function(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

QBCore.Functions.GetClosestVehicle = function(coords, radius)
    local coords = coords ~= nil and coords or QBCore.Functions.GetCoords(GetPlayerPed(-1))
    local radius = radius ~= nil and radius or 10.0
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, radius, 0.0)
    local rayHandle = CastRayPointToPoint(coords.x, coords.y, coords.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)

    if targetVehicle ~= nil then
       return targetVehicle
    end
    return 0
end

QBCore.Functions.Notify = function(text, textype, length) -- [text] = message, [type] = primary | error | success, [length] = time till fadeout.
    local ttype = textype ~= nil and textype or "primary"
    local length = length ~= nil and length or 2500
    SendNUIMessage({
        action = "show",
        type = ttype,
        length = length,
        text = text,
    })
end

QBCore.Functions.TriggerCallback = function(name, cb, ...)
    QBCore.ServerCallbacks[name] = cb
    TriggerServerEvent("QBCore:Server:TriggerCallback", name, ...)
end