Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

ClosestHouse = nil
InHouse = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if ClosestHouse ~= nil then
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Houses[ClosestHouse].coords.enter.x, Houses[ClosestHouse].coords.enter.y, Houses[ClosestHouse].coords.enter.z, true) < 2.5 then 
				if not Houses[ClosestHouse].locked or HasKey(ClosestHouse) then 
					if HasKey(ClosestHouse) and not Houses[ClosestHouse].locked then 
						DrawText3D(Houses[ClosestHouse].coords.enter.x, Houses[ClosestHouse].coords.enter.y, Houses[ClosestHouse].coords.enter.z, "[~g~E~w~] om naar binnen te gaan / [~g~L~w~] om deur op slot te doen")
					elseif HasKey(ClosestHouse) and Houses[ClosestHouse].locked then 
						DrawText3D(Houses[ClosestHouse].coords.enter.x, Houses[ClosestHouse].coords.enter.y, Houses[ClosestHouse].coords.enter.z, "[~g~E~w~] om naar binnen te gaan / [~g~L~w~] om deur open te doen")
					else 
						DrawText3D(Houses[ClosestHouse].coords.enter.x, Houses[ClosestHouse].coords.enter.y, Houses[ClosestHouse].coords.enter.z, "[~g~E~w~] om naar binnen te gaan")
					end
					if IsControlJustReleased(0, Keys["E"]) then 
						TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 1.0)
						DoScreenFadeOut(500)
		   				while not IsScreenFadedOut() do
		        			Citizen.Wait(10)
		    			end
		    			SetEntityCoords(GetPlayerPed(-1), Houses[ClosestHouse].coords.exit.x, Houses[ClosestHouse].coords.exit.y, Houses[ClosestHouse].coords.exit.z)
		    			SetEntityHeading(GetPlayerPed(-1),  Houses[ClosestHouse].coords.exit.a)
		    			InHouse = ClosestHouse
		    			ClosestHouse = nil
    					Citizen.Wait(1000)
    					TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 1.0)
		    			DoScreenFadeIn(1000)
					end
					if IsControlJustReleased(0, Keys["L"]) then 
						local currentstate = not Houses[ClosestHouse].locked
						if currentstate then
							TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_lock", 1.0)
						else
							TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_unlock", 1.0)
						end
						TriggerServerEvent("houses:server:sethousedoorstate", ClosestHouse, currentstate)
					end
				end
			end
		elseif InHouse ~= nil and not DecoMode then
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Houses[InHouse].coords.exit.x, Houses[InHouse].coords.exit.y, Houses[InHouse].coords.exit.z, true) < 2.5 then 
				if HasKey(InHouse) and not Houses[InHouse].locked then 
					DrawText3D(Houses[InHouse].coords.exit.x, Houses[InHouse].coords.exit.y, Houses[InHouse].coords.exit.z, "[~g~E~w~] om naar buiten te gaan / [~g~L~w~] om deur op slot te doen")
				elseif HasKey(InHouse) and Houses[InHouse].locked then 
					DrawText3D(Houses[InHouse].coords.exit.x, Houses[InHouse].coords.exit.y, Houses[InHouse].coords.exit.z, "[~g~E~w~] om naar buiten te gaan / [~g~L~w~] om deur open te doen")
				else 
					DrawText3D(Houses[InHouse].coords.exit.x, Houses[InHouse].coords.exit.y, Houses[InHouse].coords.exit.z, "[~g~E~w~] om naar buiten te gaan")
				end
				if IsControlJustReleased(0, Keys["E"]) then 
					TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 1.0)
					DoScreenFadeOut(500)
	   				while not IsScreenFadedOut() do
	        			Citizen.Wait(10)
	    			end
	    			SetEntityCoords(GetPlayerPed(-1), Houses[InHouse].coords.enter.x, Houses[InHouse].coords.enter.y, Houses[InHouse].coords.enter.z)
	    			SetEntityHeading(GetPlayerPed(-1),  Houses[InHouse].coords.enter.a)
	    			ClosestHouse = InHouse
	    			InHouse = nil
					Citizen.Wait(1000)
					TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 1.0)
	    			DoScreenFadeIn(1000)
				end
				if IsControlJustReleased(0, Keys["L"]) then 
					local currentstate = not Houses[InHouse].locked
					if currentstate then
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2.5, "houses_door_lock", 1.0)
					else
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2.5, "houses_door_unlock", 1.0)
					end
					TriggerServerEvent("houses:server:sethousedoorstate", InHouse, currentstate)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if InHouse == nil then
			SetClosestHouse()
		end
		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(3000)
	if NetworkIsHost() then
		if Houses ~= nil then
			for key, House in pairs(Houses) do
				if House.object ~= nil then
					if DoesEntityExist(House.object) then
						House.object = DeleteObject()
					end
				end
				local modelHash = GetHashKey("custom_appartment_medium")

				RequestModel(modelHash)

				while not HasModelLoaded(modelHash) do
				    Citizen.Wait(1000)
				    print("loading model")
				end
				House.object = CreateObject(modelHash, House.coords.spawn.x, House.coords.spawn.y, House.coords.spawn.z, true, false, false)
				FreezeEntityPosition(House.object, true)
			end
		end
	end
end)

RegisterNetEvent("houses:client:sethousedoorstate")
AddEventHandler("houses:client:sethousedoorstate", function(house, state)
	Houses[house].locked = state
end)

RegisterNetEvent("houses:ShowNotification")
AddEventHandler("houses:ShowNotification", function(msg)
	ShowNotification(msg)
end)

function HasKey(house)
	return true
end

function SetClosestHouse()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local current = nil
	local lastdist = 0
	if Houses ~= nil then
		for name, House in pairs(Houses) do
			if current ~= nil then 
				if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Houses[name].coords.enter.x, Houses[name].coords.enter.y, Houses[name].coords.enter.z, true) < lastdist then 
					current = name
					lastdist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Houses[name].coords.enter.x, Houses[name].coords.enter.y, Houses[name].coords.enter.z, true)
				end
			else
				current = name
			end
		end
		ClosestHouse = current
	end
end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

function DrawText3D(x, y, z, text)
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

function ShowHelpNotification(msg)
	BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function getTableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function degToRad( degs )
    return degs * 3.141592653589793 / 180
end