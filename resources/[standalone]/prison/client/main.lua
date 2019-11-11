Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

QBCore = nil
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = true
inJail = false
jailTime = 0

currentJob = "electrician"

--[[
	Decrease jailtime every minute
]]
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(7)
		if jailTime > 0 and inJail then 
			Citizen.Wait(1000 * 60)
			jailTime = jailTime - 1
			if jailTime <= 0 then
				jailTime = 0
			end
			TriggerServerEvent("prison:server:SetJailStatus", jailTime)
		else
			Citizen.Wait(5000)
		end
	end
end)

--[[
	Locations n stuff
]]
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		if isLoggedIn then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["cells"].coords.x, Config.Locations["cells"].coords.y, Config.Locations["cells"].coords.z, true) < 1.5) then
				QBCore.Functions.DrawText3D(Config.Locations["cells"].coords.x, Config.Locations["cells"].coords.y, Config.Locations["cells"].coords.z, "~g~E~w~ - Bezoek / ~g~G~w~ - Buiten")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Citizen.Wait(10)
					end
					SetEntityCoords(PlayerPedId(), Config.Locations["meeting"].coords.x, Config.Locations["meeting"].coords.y, Config.Locations["meeting"].coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), Config.Locations["meeting"].coords.h)
					Citizen.Wait(500)
	
					DoScreenFadeIn(1000)
				end
				if IsControlJustReleased(0, Keys["G"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Citizen.Wait(10)
					end
					SetEntityCoords(PlayerPedId(), Config.Locations["yard"].coords.x, Config.Locations["yard"].coords.y, Config.Locations["yard"].coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), Config.Locations["yard"].coords.h)
					Citizen.Wait(500)
	
					DoScreenFadeIn(1000)
				end
			end
			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["meeting"].coords.x, Config.Locations["meeting"].coords.y, Config.Locations["meeting"].coords.z, true) < 1.5) then
				QBCore.Functions.DrawText3D(Config.Locations["meeting"].coords.x, Config.Locations["meeting"].coords.y, Config.Locations["meeting"].coords.z, "~g~E~w~ - Cellen")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Citizen.Wait(10)
					end
					SetEntityCoords(PlayerPedId(), Config.Locations["cells"].coords.x, Config.Locations["cells"].coords.y, Config.Locations["cells"].coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), Config.Locations["cells"].coords.h)
					Citizen.Wait(500)
	
					DoScreenFadeIn(1000)
				end
			end
			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["yard"].coords.x, Config.Locations["yard"].coords.y, Config.Locations["yard"].coords.z, true) < 1.5) then
				QBCore.Functions.DrawText3D(Config.Locations["yard"].coords.x, Config.Locations["yard"].coords.y, Config.Locations["yard"].coords.z, "~g~E~w~ - Cellen")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Citizen.Wait(10)
					end
					SetEntityCoords(PlayerPedId(), Config.Locations["cells"].coords.x, Config.Locations["cells"].coords.y, Config.Locations["cells"].coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), Config.Locations["cells"].coords.h)
					Citizen.Wait(500)
	
					DoScreenFadeIn(1000)
				end
			end

			if inJail then
				if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z, true) < 1.5) then
					QBCore.Functions.DrawText3D(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z, "~g~E~w~ - Check tijd")
					if IsControlJustReleased(0, Keys["E"]) then
						TriggerEvent("prison:client:Leave")
					end
				elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z, true) < 2.5) then
					QBCore.Functions.DrawText3D(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z, "Check tijd")
				end  
			end
	
			if not inJail then 
				if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, true) < 1.5) then
					QBCore.Functions.DrawText3D(Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, "~g~E~w~ - Bezoek")
					if IsControlJustReleased(0, Keys["E"]) then
						DoScreenFadeOut(500)
						while not IsScreenFadedOut() do
							Citizen.Wait(10)
						end
						SetEntityCoords(PlayerPedId(), Config.Locations["visit"].coords.x, Config.Locations["visit"].coords.y, Config.Locations["visit"].coords.z, 0, 0, 0, false)
						SetEntityHeading(PlayerPedId(), Config.Locations["visit"].coords.h)
						Citizen.Wait(500)
	
						DoScreenFadeIn(1000)
					end
				end
				if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["visit"].coords.x, Config.Locations["visit"].coords.y, Config.Locations["visit"].coords.z, true) < 1.5) then
					QBCore.Functions.DrawText3D(Config.Locations["visit"].coords.x, Config.Locations["visit"].coords.y, Config.Locations["visit"].coords.z, "~g~E~w~ - Uitgang")
					if IsControlJustReleased(0, Keys["E"]) then
						DoScreenFadeOut(500)
						while not IsScreenFadedOut() do
							Citizen.Wait(10)
						end
						SetEntityCoords(PlayerPedId(), Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, 0, 0, 0, false)
						SetEntityHeading(PlayerPedId(), Config.Locations["exit"].coords.h)
						Citizen.Wait(500)
	
						DoScreenFadeIn(1000)
					end
				end
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	isLoggedIn = true
	QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] > 0 then
			TriggerEvent("prison:client:Enter", PlayerData.metadata["injail"])
		end
	end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
	isLoggedIn = false
	inJail = false
	currentJob = nil
	RemoveBlip(currentBlip)
end)

RegisterNetEvent('prison:client:Enter')
AddEventHandler('prison:client:Enter', function(time)
	QBCore.Functions.Notify("Je zit in de gevangenis voor "..time.." maanden..", "error")
	TriggerEvent("chatMessage", "SYSTEM", "warning", "Je bezit is in beslag genomen, je krijgt alles terug wanneer je tijd erop zit..")
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
	SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.9, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.h)
	Citizen.Wait(500)
	TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition.animation})

	inJail = true
	jailTime = time
	TriggerServerEvent("prison:server:SetJailStatus", jailTime)
	TriggerServerEvent("prison:server:SaveJailItems", jailTime)

	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)
	
	Citizen.Wait(2000)

	DoScreenFadeIn(1000)
	QBCore.Functions.Notify("Doe wat werk voor strafvermindering, momentele baan: "..Config.Jobs[currentJob])
end)

RegisterNetEvent('prison:client:Leave')
AddEventHandler('prison:client:Leave', function()
	if jailTime > 0 then 
		QBCore.Functions.Notify("Je moet nog "..jailTime.." maanden zitten..")
	else
		TriggerServerEvent("prison:server:SetJailStatus", 0)
		TriggerServerEvent("prison:server:GiveJailItems")
		TriggerEvent("chatMessage", "SYSTEM", "warning", "Je hebt je bezit weer terug ontvangen..")
		inJail = false
		RemoveBlip(currentBlip)
		QBCore.Functions.Notify("Je bent vrij! Geniet ervan :)")
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z - 0.9, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["freedom"].coords.h)

		Citizen.Wait(500)

		DoScreenFadeIn(1000)
	end
end)