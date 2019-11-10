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

isLoggedIn = false
inJail = false
jailTime = 0

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
				TriggerEvent("prison:client:Leave")
				jailTime = 0
			end
			TriggerServerEvent("prison:server:SetJailStatus", jailTime)
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
end)

RegisterNetEvent('prison:client:Enter')
AddEventHandler('prison:client:Enter', function(time)
	inJail = true
	jailTime = time
	QBCore.Functions.Notify("Je zit in de gevangenis voor "..jailTime.." maanden..", "error")
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
	SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.9, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.h)
	Citizen.Wait(500)
	TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition.animation})

	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)
	Citizen.Wait(2000)

	DoScreenFadeIn(1000)
end)

RegisterNetEvent('prison:client:Leave')
AddEventHandler('prison:client:Leave', function()
	if jailTime > 0 then 
		QBCore.Functions.Notify("Je moet nog "..jailTime.." maanden zitten..")
	else
		TriggerServerEvent("prison:server:SetJailStatus", 0)
		inJail = false
		QBCore.Functions.Notify("Je bent vrij! Geniet ervan :)")
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z - 0.9, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["exit"].coords.h)

		Citizen.Wait(500)

		DoScreenFadeIn(1000)
	end
end)