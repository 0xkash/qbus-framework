QBCore = nil
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

local isLoggedIn = true
local InApartment = false
local ClosestHouse = nil
local IsOwned = true

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn and not InApartment then
            SetClosestApartment()
        end
        Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    for name, apartment in pairs(Apartments.Locations) do
        Apartments.Locations[name].blip = AddBlipForCoord(Apartments.Locations[name].coords.enter.x, Apartments.Locations[name].coords.enter.y, Apartments.Locations[name].coords.enter.z)
        SetBlipSprite(Apartments.Locations[name].blip, 475)
        SetBlipDisplay(Apartments.Locations[name].blip, 4)
        SetBlipScale(Apartments.Locations[name].blip, 0.65)
        SetBlipAsShortRange(Apartments.Locations[name].blip, true)
        SetBlipColour(Apartments.Locations[name].blip, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Apartments.Locations[name].label)
        EndTextCommandSetBlipName(Apartments.Locations[name].blip)
    end
    while true do
        Citizen.Wait(7)
        if isLoggedIn and ClosestHouse ~= nil then
            if InApartment then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.exit.x, Apartments.Locations[ClosestHouse].coords.exit.y,Apartments.Locations[ClosestHouse].coords.exit.z, true) < 1.5)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.exit.x, Apartments.Locations[ClosestHouse].coords.exit.y, Apartments.Locations[ClosestHouse].coords.exit.z, '~g~E~w~ - Ga in appartement')
                    if IsControlJustPressed(0, Keys["E"]) then
                        LeaveApartment(ClosestHouse)
                    end
                end
            elseif IsOwned then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z, true) < 1.5)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y, Apartments.Locations[ClosestHouse].coords.enter.z, '~g~E~w~ - Ga in appartement')
                    if IsControlJustPressed(0, Keys["E"]) then
                        EnterApartment(ClosestHouse)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

function EnterApartment(house)
    Citizen.CreateThread(function()
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 1.0)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        SetRainFxIntensity(0.0)
        TriggerEvent('qb-weathersync:client:DisableSync')
        Citizen.Wait(100)
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
        NetworkOverrideClockTime(23, 0, 0)
        SetEntityCoords(GetPlayerPed(-1), Apartments.Locations[house].coords.exit.x, Apartments.Locations[house].coords.exit.y,Apartments.Locations[house].coords.exit.z, 0, 0, 0, false)
        SetEntityHeading(GetPlayerPed(-1), Apartments.Locations[house].coords.exit.h)

        Citizen.Wait(1000)

        DoScreenFadeIn(1000)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 1.0)
        InApartment = true
    end)
end

function LeaveApartment(house)
    Citizen.CreateThread(function()
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 1.0)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        TriggerEvent('qb-weathersync:client:EnableSync')
        Citizen.Wait(100)
        SetEntityCoords(GetPlayerPed(-1), Apartments.Locations[house].coords.enter.x, Apartments.Locations[house].coords.enter.y,Apartments.Locations[house].coords.enter.z, 0, 0, 0, false)
        SetEntityHeading(GetPlayerPed(-1), Apartments.Locations[house].coords.enter.h)

        Citizen.Wait(1000)
        
        DoScreenFadeIn(1000)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 1.0)
        InApartment = false
    end)
end

function SetClosestApartment()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, house in pairs(Apartments.Locations) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z, true)
            current = id
        end
    end
    if current ~= ClosestHouse then
        ClosestHouse = current
        --[[QBCore.Functions.TriggerCallback('apartments:IsOwner', function(result)
            IsOwned = result
        end, ClosestHouse)]]--
    end
    
end
