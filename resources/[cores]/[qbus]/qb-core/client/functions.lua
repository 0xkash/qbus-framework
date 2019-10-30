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

    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))

    if cb ~= nil then
        cb(veh)
    end
end

QBCore.Functions.DeleteVehicle = function(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
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

QBCore.Functions.EnumerateEntities = function(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

QBCore.Functions.GetVehicles = function()
    local vehicles = {}
	for vehicle in QBCore.Functions.EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) do
		table.insert(vehicles, vehicle)
	end
	return vehicles
end

QBCore.Functions.GetPeds = function(ignore)
    local ignore = ignore ~= nil and ignore or {}
	local peds = {}
	for ped in QBCore.Functions.EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) do
		local found = false
		for j=1, #ignore, 1 do
			if ignore[j] == ped then
				found = true
			end
		end
		if not found then
			table.insert(peds, ped)
		end
	end
	return peds
end

QBCore.Functions.GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
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

QBCore.Functions.GetClosestPed = function(coords, ignoreList)
	local ignoreList = ignoreList or {}
	local peds = QBCore.Functions.GetPeds(ignoreList)
	local closestDistance = -1
    local closestPed = -1

	if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
	end

	for i=1, #peds, 1 do
		local pos = GetEntityCoords(peds[i])
		local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end


QBCore.Functions.GetClosestPlayer = function(coords)
	local players = QBCore.Functions.GetPlayers()
	local closestDistance = -1
    local closestPlayer = -1

	if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
	end

	for i=1, #players, 1 do
		local pos = GetEntityCoords(players[i])
		local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPlayer = players[i]
			closestDistance = distance
		end
	end

	return closestPlayer, closestDistance
end

QBCore.Functions.GetPlayersFromCoords = function(coords, distance)
    local players = QBCore.Functions.GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    
    return closePlayers
end

QBCore.Functions.Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)
end