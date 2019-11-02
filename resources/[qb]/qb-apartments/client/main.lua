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

local isLoggedIn = false
local InApartment = false
local ClosestHouse = nil
local CurrentApartment = nil
local IsOwned = false

local CurrentDoorBell = 0

local CurrentOffset = 0

local houseObj = nil
local POIOffsets = nil
local data = nil

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
    while true do
        Citizen.Wait(1)
        if isLoggedIn and ClosestHouse ~= nil then
            if InApartment then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if CurrentDoorBell ~= 0 then
                    if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.exit.x, Apartments.Locations[ClosestHouse].coords.exit.y,Apartments.Locations[ClosestHouse].coords.exit.z, true) < 1.2)then
                        QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.exit.x, Apartments.Locations[ClosestHouse].coords.exit.y, Apartments.Locations[ClosestHouse].coords.exit.z + 0.1, '~g~G~w~ - Open deur')
                        if IsControlJustPressed(0, Keys["G"]) then
                            print(CurrentDoorBell)
                            print(CurrentApartment)
                            print(ClosestHouse)
                            TriggerServerEvent("apartments:server:OpenDoor", CurrentDoorBell, CurrentApartment, ClosestHouse)
                            CurrentDoorBell = 0
                        end
                    end
                end

                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x + POIOffsets.exit.x, Apartments.Locations[ClosestHouse].coords.enter.y + POIOffsets.exit.y, Apartments.Locations[ClosestHouse].coords.enter.z + POIOffsets.exit.z, true) < 1.2)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x + POIOffsets.exit.x, Apartments.Locations[ClosestHouse].coords.enter.y + POIOffsets.exit.y, Apartments.Locations[ClosestHouse].coords.enter.z + POIOffsets.exit.z, '~g~E~w~ - Ga uit appartement')
                    if IsControlJustPressed(0, Keys["E"]) then
                        loadAnimDict("anim@heists@keycard@") 
                        TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
                        Citizen.Wait(400)
                        ClearPedTasks(GetPlayerPed(-1))
                        LeaveApartment(ClosestHouse)
                    end
                end

                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.stash.x, Apartments.Locations[ClosestHouse].coords.stash.y,Apartments.Locations[ClosestHouse].coords.stash.z, true) < 1.2)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.stash.x, Apartments.Locations[ClosestHouse].coords.stash.y, Apartments.Locations[ClosestHouse].coords.stash.z, '~g~E~w~ - Stash')
                    if IsControlJustPressed(0, Keys["E"]) then
                        if CurrentApartment ~= nil then
                            TriggerEvent("inventory:client:SetCurrentStash", CurrentApartment)
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentApartment)
                        end
                    end
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.stash.x, Apartments.Locations[ClosestHouse].coords.stash.y, Apartments.Locations[ClosestHouse].coords.stash.z, true) < 3)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.stash.x, Apartments.Locations[ClosestHouse].coords.stash.y, Apartments.Locations[ClosestHouse].coords.stash.z, 'Stash')
                end
                
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.outfits.x, Apartments.Locations[ClosestHouse].coords.outfits.y, Apartments.Locations[ClosestHouse].coords.outfits.z, true) < 1.2)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.outfits.x, Apartments.Locations[ClosestHouse].coords.outfits.y, Apartments.Locations[ClosestHouse].coords.outfits.z, '~g~E~w~ - Outfits')
                    if IsControlJustPressed(0, Keys["E"]) then
                        MenuOutfits()
                        Menu.hidden = not Menu.hidden
                    end
                    Menu.renderGUI()
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.outfits.x, Apartments.Locations[ClosestHouse].coords.outfits.y, Apartments.Locations[ClosestHouse].coords.outfits.z, true) < 3)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.outfits.x, Apartments.Locations[ClosestHouse].coords.outfits.y, Apartments.Locations[ClosestHouse].coords.outfits.z, 'Outfits')
                end

                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.logout.x, Apartments.Locations[ClosestHouse].coords.logout.y,Apartments.Locations[ClosestHouse].coords.logout.z, true) < 1.5)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.logout.x, Apartments.Locations[ClosestHouse].coords.logout.y, Apartments.Locations[ClosestHouse].coords.logout.z, '~g~E~w~ - Uitloggen')
                    if IsControlJustPressed(0, Keys["E"]) then
                        TriggerServerEvent('qb-houses:server:logOut')
                    end
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.logout.x, Apartments.Locations[ClosestHouse].coords.logout.y,Apartments.Locations[ClosestHouse].coords.logout.z, true) < 3)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.logout.x, Apartments.Locations[ClosestHouse].coords.logout.y, Apartments.Locations[ClosestHouse].coords.logout.z, 'Uitloggen')
                end
            elseif IsOwned then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z, true) < 1.2)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y, Apartments.Locations[ClosestHouse].coords.enter.z, '~g~E~w~ - Ga in appartement')
                    if IsControlJustPressed(0, Keys["E"]) then
                        QBCore.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
                            loadAnimDict("anim@heists@keycard@") 
                            TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
                            Citizen.Wait(400)
                            ClearPedTasks(GetPlayerPed(-1))
                            EnterApartment(ClosestHouse, result.name)
                        end)
                    end
                end
            elseif not IsOwned then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z, true) < 1.2)then
                    QBCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y, Apartments.Locations[ClosestHouse].coords.enter.z, '~g~G~w~ - Verander van appartement')
                    if IsControlJustPressed(0, Keys["G"]) then
                        TriggerServerEvent("apartments:server:UpdateApartment", ClosestHouse)
                        IsOwned = true
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    QBCore.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
        if result ~= nil then
            TriggerEvent("apartments:client:SetHomeBlip", result.type)
        else
            -- keuze menu yeet
            TriggerServerEvent("apartments:server:CreateApartment", "apartment1")
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('apartments:client:SpawnInApartment')
AddEventHandler('apartments:client:SpawnInApartment', function(apartmentId, apartment)
    --TriggerEvent('instances:client:JoinInstance', apartmentId, apartment)
    ClosestHouse = apartment
    EnterApartment(apartment, apartmentId)
end)

RegisterNetEvent('apartments:client:SetHomeBlip')
AddEventHandler('apartments:client:SetHomeBlip', function(home)
    Citizen.CreateThread(function()
        SetClosestApartment()
        for name, apartment in pairs(Apartments.Locations) do
            RemoveBlip(Apartments.Locations[name].blip)

            Apartments.Locations[name].blip = AddBlipForCoord(Apartments.Locations[name].coords.enter.x, Apartments.Locations[name].coords.enter.y, Apartments.Locations[name].coords.enter.z)
            if (name == home) then
                SetBlipSprite(Apartments.Locations[name].blip, 475)
            else
                SetBlipSprite(Apartments.Locations[name].blip, 476)
            end
            SetBlipDisplay(Apartments.Locations[name].blip, 4)
            SetBlipScale(Apartments.Locations[name].blip, 0.65)
            SetBlipAsShortRange(Apartments.Locations[name].blip, true)
            SetBlipColour(Apartments.Locations[name].blip, 3)
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Apartments.Locations[name].label)
            EndTextCommandSetBlipName(Apartments.Locations[name].blip)
        end
    end)
end)

RegisterNetEvent('apartments:client:RingDoor')
AddEventHandler('apartments:client:RingDoor', function(player)
    print(player)
    CurrentDoorBell = player
    QBCore.Functions.Notify("Iemand belt aan de deur!")
end)

function EnterApartment(house, apartmentId)
    QBCore.Functions.TriggerCallback('apartments:GetApartmentOffset', function(offset)
        if offset == 0 then
            QBCore.Functions.TriggerCallback('apartments:GetApartmentOffsetCount', function(count)
                CurrentOffset = (count * Apartments.SpawnOffset)
                local coords = { x = Apartments.Locations[house].coords.enter.x, y = Apartments.Locations[house].coords.enter.y, z = Apartments.Locations[house].coords.enter.z - CurrentOffset}
                data = exports['qb-interior']:CreateTier1HouseFurnished(coords, false)
                TriggerServerEvent("apartments:server:SetApartmentOffset", house, apartmentId, CurrentOffset)
                Citizen.Wait(100)
                houseObj = data[1]
                POIOffsets = data[2]
                --TriggerEvent('instances:client:JoinInstance', apartmentId, house)
                CurrentApartment = apartmentId
                
                InApartment = true
                Citizen.CreateThread(function()
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 1.0)
                    Citizen.Wait(500)
                    SetRainFxIntensity(0.0)
                    TriggerEvent('qb-weathersync:client:DisableSync')
                    TriggerEvent('qb-houses:client:insideHouse', true)
                    Citizen.Wait(100)
                    SetWeatherTypePersist('EXTRASUNNY')
                    SetWeatherTypeNow('EXTRASUNNY')
                    SetWeatherTypeNowPersist('EXTRASUNNY')
                    NetworkOverrideClockTime(23, 0, 0)
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 1.0)
                end)
            end, house)
        else
            CurrentOffset = offset
            local coords = { x = Apartments.Locations[house].coords.enter.x, y = Apartments.Locations[house].coords.enter.y, z = Apartments.Locations[house].coords.enter.z - CurrentOffset}
            data = exports['qb-interior']:CreateTier1HouseFurnished(coords, false)
            TriggerServerEvent("apartments:server:SetApartmentOffset", house, apartmentId, CurrentOffset)
            Citizen.Wait(100)
            houseObj = data[1]
            POIOffsets = data[2]
            --TriggerEvent('instances:client:JoinInstance', apartmentId, house)
            CurrentApartment = apartmentId
            InApartment = true
            Citizen.CreateThread(function()
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 1.0)
                Citizen.Wait(500)
                SetRainFxIntensity(0.0)
                TriggerEvent('qb-weathersync:client:DisableSync')
                TriggerEvent('qb-houses:client:insideHouse', true)
                Citizen.Wait(100)
                SetWeatherTypePersist('EXTRASUNNY')
                SetWeatherTypeNow('EXTRASUNNY')
                SetWeatherTypeNowPersist('EXTRASUNNY')
                NetworkOverrideClockTime(23, 0, 0)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 1.0)
            end)
        end
    end, house, apartmentId)
end

function LeaveApartment(house)
    --TriggerEvent('instances:client:LeaveInstance')
    InApartment = false
    CurrentApartment = nil
    DoScreenFadeOut(250)
    Citizen.Wait(500)
    exports['qb-interior']:DespawnInterior(houseObj, function()
        TriggerEvent('qb-weathersync:client:EnableSync')
        Citizen.Wait(100)
        TriggerServerEvent("apartments:server:RemoveApartmentOffset", house, apartmentId)
        DoScreenFadeIn(250)
        SetEntityCoords(GetPlayerPed(-1), Apartments.Locations[house].coords.enter.x, Apartments.Locations[house].coords.enter.y, Apartments.Locations[house].coords.enter.z)
        SetEntityHeading(GetPlayerPed(-1), Apartments.Locations[house].coords.enter.h)
        inside = false
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
        QBCore.Functions.TriggerCallback('apartments:IsOwner', function(result)
            IsOwned = result
        end, ClosestHouse)
    end
end

function MenuOwners()
    ped = GetPlayerPed(-1);
    MenuTitle = "Owners"
    ClearMenu()
    Menu.addButton("Aanbellen", "OwnerList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function OwnerList()
    QBCore.Functions.TriggerCallback('instance:GetOwnerList', function(owners)
        ped = GetPlayerPed(-1);
        MenuTitle = "Aanbellen bij: "
        ClearMenu()

        if owners == nil then
            QBCore.Functions.Notify("Er is niemand aanwezig..", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(owners) do
                print(v)
                Menu.addButton(GetPlayerName(GetPlayerFromServerId(v)), "RingDoor", v) 
            end
        end
        Menu.addButton("Terug", "MenuOwners",nil)
    end, ClosestHouse)
end

function RingDoor(source)
    TriggerServerEvent("apartments:server:RingDoor", source)
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("Mijn Outfits", "OutfitsLijst", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    QBCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Outfits :"
        ClearMenu()

        if outfits == nil then
            QBCore.Functions.Notify("Je hebt geen outfits opgeslagen...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Terug", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()

    Menu.addButton("Kies Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Verwijder Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Terug", "OutfitsLijst",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    QBCore.Functions.Notify(oData.outfitname.." gekozen", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    QBCore.Functions.Notify(oData.outfitname.." is verwijderd", "success", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end
