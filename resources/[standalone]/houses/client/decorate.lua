DecoMode = false
local MainCamera = nil
local curPos
local speeds = {0.05, 0.1, 0.2, 0.4, 0.5}
local curSpeed = 1

local SelectedObj = nil
local SelObjHash
local SelObjPos
local SelObjRot

local ObjectList = {}

local tieten = false
local peanut = false
-- Only enable some controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if DecoMode then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys["W"], true)
			EnableControlAction(0, Keys["S"], true)
			EnableControlAction(0, Keys["T"], true)
			EnableControlAction(0, Keys["LEFTSHIFT"], true)
			EnableControlAction(0, Keys["F1"], true)
			EnableControlAction(0, Keys["F2"], true)
			EnableControlAction(0, Keys["ENTER"], true)
			EnableControlAction(0, Keys["LEFT"], true)
			EnableControlAction(0, Keys["RIGHT"], true)
			EnableControlAction(0, Keys["TOP"], true)
			EnableControlAction(0, Keys["DOWN"], true)
			EnableControlAction(0, Keys["PAGEUP"], true)
			EnableControlAction(0, Keys["PAGEDOWN"], true)

			if IsControlJustReleased(0, Keys["F1"]) then
				SetNuiFocus(true, true)
				SendNUIMessage({
                    action = "open",
                })
			end

			DisplayRadar(false)

			CheckRotationInput()
			CheckMovementInput()
		end

		if SelectedObj ~= nil and peanut then
			ShowHelpNotification("~g~F1~w~ - Object Spawner | ~g~F2~w~ - Toggle Rotation/Move | ~g~ENTER~w~ - Plaats Object")
			DrawMarker(21, SelObjPos.x, SelObjPos.y, SelObjPos.z + 1.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.6, 0.6, 0.6, 28, 149, 255, 100, true, true, 2, false, false, false, false)
			if tieten then 
				CheckObjRotationInput()
			else
				CheckObjMovementInput()
			end
			if IsControlJustReleased(0, Keys["F2"]) then
				tieten = not tieten
			end
			if IsControlJustReleased(0, Keys["ENTER"]) then
				SaveDecorations()
				FreezeEntityPosition(SelectedObj, true)
				SelectedObj = nil
				peanut = false
			end
		end
	end
end)

-- Out of area
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(7)
		if DecoMode then
			local camPos = GetCamCoord(MainCamera)
			if GetDistanceBetweenCoords(camPos.x, camPos.y, camPos.z, Houses[InHouse].coords.spawn.x, Houses[InHouse].coords.spawn.y, Houses[InHouse].coords.spawn.z, false) > Houses[InHouse].coords.maxrange then
				DisableEditMode()
				ShowNotification("Je bent buiten de range gegaan!")
			end
		end
	end
end)


RegisterNetEvent("houses:client:decorate")
AddEventHandler("houses:client:decorate", function()
	if InHouse ~= nil then 
		if HasKey(InHouse) then 
			if not DecoMode then
				EnableEditMode()
			else
				DisableEditMode()
			end
		else
			ShowNotification("~r~Je moet de sleutels van het huis hebben!")
		end
	else
		ShowNotification("~r~Je bent niet in een huis!")
	end
end)

RegisterNetEvent("houses:client:setdecoration")
AddEventHandler("houses:client:setdecoration", function(house, objlist)
	if house ~= nil then
		Houses[house].decorations = objlist
	end
end)

RegisterNUICallback("CloseUI", function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("SpawnObject", function(data, cb)
	local modelHash = GetHashKey(tostring(data.objname))
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
	    Citizen.Wait(1000)
	end
    SelectedObj = CreateObject(modelHash, curPos.x + GetEntityForwardX(MainCamera), curPos.y +  GetEntityForwardY(MainCamera), curPos.z, true, false, false)
    local pos = GetEntityCoords(SelectedObj, true)
    local rot = GetEntityRotation(SelectedObj)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = data.objname
    PlaceObjectOnGroundProperly(SelectedObj)
    peanut = true
end)

function EnableEditMode()
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	curPos = {x = pos.x, y = pos.y, z = pos.z}
	SetEntityVisible(GetPlayerPed(-1), false)
	CreateEditCamera()
	DecoMode = true
end

function DisableEditMode()
	SaveDecorations()
	SetEntityVisible(GetPlayerPed(-1), true)
	SetDefaultCamera()
	EnableAllControlActions(0)
	ObjectList = nil
	SelectedObj = nil
	peanut = false
	DecoMode = false
end

function LoadDecorations()
	if InHouse ~= nil then
		if Houses[InHouse].decorations ~= nil then
			for _, decObj in pairs(Houses[InHouse].decorations) do
				if decObj.object ~= nil then
					if DoesEntityExist(decObj.object) then
						decObj.object = DeleteObject()
					end
				end
				local modelHash = GetHashKey(decObj.hashname)
				RequestModel(modelHash)

				while not HasModelLoaded(modelHash) do
				    Citizen.Wait(1000)
				end
				local HouseObj = CreateObject(modelHash, decObj.x, decObj.y, decObj.z, true, false, false)
				decObj.object = HouseObj
				SetEntityRotation(HouseObj, decObj.rotx, decObj.roty, decObj.rotz)
				table.insert(ObjectList, {hashname = decObj.hashname, x = decObj.x, y = decObj.y, z = decObj.z, rotx = decObj.rotx, roty = decObj.roty, rotz = decObj.rotz, object = HouseObj})
				FreezeEntityPosition(HouseObj, true)
			end
		end
	end
end

function SaveDecorations()
	if InHouse ~= nil then
		if SelectedObj ~= nil then
			table.insert(ObjectList, {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.rotx, roty = SelObjRot.roty, rotz = SelObjRot.rotz, object = SelectedObj})
		end
		TriggerServerEvent("houses:server:savedecorations", InHouse, ObjectList)
	end
end

function CheckObjMovementInput()
	local xVect = speeds[curSpeed]
    local yVect = speeds[curSpeed]
    local zVect = speeds[curSpeed]

    if IsControlPressed( 1, Keys["TOP"]) or IsDisabledControlPressed(1, Keys["TOP"]) then
    	SelObjPos.x = SelObjPos.x + xVect
    end

    if IsControlPressed( 1, Keys["DOWN"]) or IsDisabledControlPressed(1, Keys["DOWN"]) then
    	SelObjPos.x = SelObjPos.x - xVect
    end

    if IsControlPressed( 1, Keys["LEFT"]) or IsDisabledControlPressed(1, Keys["LEFT"]) then
    	SelObjPos.y = SelObjPos.y + yVect
    end

    if IsControlPressed( 1, Keys["RIGHT"]) or IsDisabledControlPressed(1, Keys["RIGHT"]) then
    	SelObjPos.y = SelObjPos.y - yVect
    end

    if IsControlPressed( 1, Keys["PAGEUP"]) or IsDisabledControlPressed(1, Keys["PAGEUP"]) then
    	SelObjPos.z = SelObjPos.z + zVect
    end

    if IsControlPressed( 1, Keys["PAGEDOWN"]) or IsDisabledControlPressed(1, Keys["PAGEDOWN"]) then
    	SelObjPos.z = SelObjPos.z - zVect
    end

    SetEntityCoords(SelectedObj, SelObjPos.x, SelObjPos.y, SelObjPos.z)
end

function CheckObjRotationInput()
	local xVect = speeds[curSpeed] * 5.5
    local yVect = speeds[curSpeed] * 5.5
    local zVect = speeds[curSpeed] * 5.5

	if IsControlPressed( 1, Keys["TOP"]) or IsDisabledControlPressed(1, Keys["TOP"]) then
    	SelObjRot.x = SelObjRot.x + xVect
    end

    if IsControlPressed( 1, Keys["DOWN"]) or IsDisabledControlPressed(1, Keys["DOWN"]) then
    	SelObjRot.x = SelObjRot.x - xVect
    end

    if IsControlPressed( 1, Keys["LEFT"]) or IsDisabledControlPressed(1, Keys["LEFT"]) then
    	SelObjRot.z = SelObjRot.z + zVect
    end

    if IsControlPressed( 1, Keys["RIGHT"]) or IsDisabledControlPressed(1, Keys["RIGHT"]) then
    	SelObjRot.z = SelObjRot.z - zVect
    end

    if IsControlPressed( 1, Keys["PAGEUP"]) or IsDisabledControlPressed(1, Keys["PAGEUP"]) then
    	SelObjRot.y = SelObjRot.y + yVect
    end

    if IsControlPressed( 1, Keys["PAGEDOWN"]) or IsDisabledControlPressed(1, Keys["PAGEDOWN"]) then
    	SelObjRot.y = SelObjRot.y - yVect
    end

	SetEntityRotation(SelectedObj, SelObjRot.x, SelObjRot.y, SelObjRot.z)
end

function CheckRotationInput()
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(MainCamera, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(2.0)*(4.0+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(2.0)*(4.0+0.1)), -20.5)
		SetCamRot(MainCamera, new_x, 0.0, new_z, 2)
	end
end

function CheckMovementInput()
	local rotation = GetCamRot(MainCamera, 2)

	if IsControlJustReleased(0, Keys["LEFTSHIFT"]) then
		curSpeed = curSpeed + 1
		if curSpeed > getTableLength(speeds) then
			curSpeed = 1
		end
		ShowNotification("Speed is ".. tostring(speeds[curSpeed]))
	end

	local xVect = speeds[curSpeed] * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = speeds[curSpeed] * math.cos( degToRad( rotation.z ) )
    local zVect = speeds[curSpeed] * math.tan( degToRad( rotation.x ) - degToRad( rotation.y ))

    if IsControlPressed( 1, Keys["W"]) or IsDisabledControlPressed(1, Keys["W"]) then
    	curPos.x = curPos.x + xVect
        curPos.y = curPos.y + yVect
        curPos.z = curPos.z + zVect
    end

    if IsControlPressed( 1, Keys["S"]) or IsDisabledControlPressed(1, Keys["S"]) then
    	curPos.x = curPos.x - xVect
        curPos.y = curPos.y - yVect
        curPos.z = curPos.z - zVect
    end


	SetCamCoord(MainCamera, curPos.x, curPos.y, curPos.z)
end

function CreateEditCamera()
	local rot = GetEntityRotation(GetPlayerPed(-1))
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	MainCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 60.00, false, 0)
	SetCamActive(MainCamera, true)
	RenderScriptCams(true, false, 1, true, true)
end

function SetDefaultCamera()
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(MainCamera, false)
	DestroyCam(MainCamera, true)
	DestroyAllCams(true)
end

