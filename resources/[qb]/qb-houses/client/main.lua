local Keys = {
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

inside = false
closesthouse = nil
hasKey = false
isOwned = false

isLoggedIn = true
local contractOpen = false

local cam = nil
local viewCam = false

stashLocation = nil
outfitLocation = nil
logoutLocation = nil

local CurrentDoorBell = 0
local rangDoorbell = nil

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

RegisterNetEvent('qb-houses:client:sellHouse')
AddEventHandler('qb-houses:client:sellHouse', function()
    if closesthouse ~= nil and hasKey then
        TriggerServerEvent('qb-houses:server:viewHouse', closesthouse)
    end
end)

--------------------------------------------------------------
Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        if isLoggedIn then
            SetClosestHouse()
            Citizen.Wait(100)
            TriggerEvent('qb-garages:client:setHouseGarage', closesthouse, hasKey)
        end
        Citizen.Wait(10000)
    end
end)

function doorText(x, y, z, text)
    SetTextScale(0.325, 0.325)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.011, -0.025+ factor, 0.03, 0, 0, 0, 68)
    ClearDrawOrigin()
end

local houseObj = {}
local POIOffsets = nil
local entering = false
local data = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    SetClosestHouse()
    TriggerEvent('qb-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    TriggerEvent('qb-garages:client:setHouseGarage', closesthouse, hasKey)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    inside = false
    closesthouse = nil
    hasKey = false
    isOwned = false
end)

RegisterNetEvent('qb-houses:client:lockHouse')
AddEventHandler('qb-houses:client:lockHouse', function(bool, house)
    Config.Houses[house].locked = bool
end)

RegisterNetEvent('qb-houses:client:toggleDoorlock')
AddEventHandler('qb-houses:client:toggleDoorlock', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    
    if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
        if hasKey then
            if Config.Houses[closesthouse].locked then
                TriggerServerEvent('qb-houses:server:lockHouse', false, closesthouse)
                QBCore.Functions.Notify("Huis is ontgrendeld!", "success", 2500)
            else
                TriggerServerEvent('qb-houses:server:lockHouse', true, closesthouse)
                QBCore.Functions.Notify("Huis is vergrendeld!", "error", 2500)
            end
        else
            QBCore.Functions.Notify("Je hebt niet de sleutels van dit huis...", "error", 3500)
        end
    else
        QBCore.Functions.Notify("Er is geen deur te bekennen??", "error", 3500)
    end
end)

DrawText3Ds = function(x, y, z, text)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        local pos = GetEntityCoords(GetPlayerPed(-1), true)

        if hasKey then
            -- ENTER HOUSE
            if not inside then
                if closesthouse ~= nil then
                    if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                        if Config.Houses[closesthouse].locked then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z + 0.98, '~r~E~w~ - Ga naar binnen')
                        elseif not Config.Houses[closesthouse].locked then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z + 0.98, '~g~E~w~ - Ga naar binnen')
                        end
                        if IsControlJustPressed(0, Keys["E"]) then
                            enterOwnedHouse(closesthouse)
                        end
                    end
                end
            end


            if CurrentDoorBell ~= 0 then
                if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                    DrawText3Ds(Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z + 0.35, '~g~G~w~ - Om deur open te doen')
                    if IsControlJustPressed(0, Keys["G"]) then
                        TriggerServerEvent("qb-houses:server:OpenDoor", CurrentDoorBell, closesthouse)
                        CurrentDoorBell = 0
                    end
                end
            end
            -- EXIT HOUSE
            if inside then
                if not entering then
                    if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                        DrawText3Ds(Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Om huis te verlaten')
                        if IsControlJustPressed(0, Keys["E"]) then
                            leaveOwnedHouse(closesthouse)
                        end
                    end
                end
            end

            local StashObject = nil
            -- STASH
            if inside then
                if closesthouse ~= nil then
                    if stashLocation ~= nil then
                        if(GetDistanceBetweenCoords(pos, stashLocation.x, stashLocation.y, stashLocation.z, true) < 1.5)then
                            DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, '~g~E~w~ - Stash')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TriggerEvent("inventory:client:SetCurrentStash", closesthouse)
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", closesthouse)
                            end
                        elseif(GetDistanceBetweenCoords(pos, stashLocation.x, stashLocation.y, stashLocation.z, true) < 3)then
                            DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, 'Stash')
                        end
                    end
                end
            end

            if inside then
                if closesthouse ~= nil then
                    if outfitLocation ~= nil then
                        if(GetDistanceBetweenCoords(pos, outfitLocation.x, outfitLocation.y, outfitLocation.z, true) < 1.5)then
                            DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, '~g~E~w~ - Outfits')
                            if IsControlJustPressed(0, Keys["E"]) then
                                MenuOutfits()
                                Menu.hidden = not Menu.hidden
                            end

                            Menu.renderGUI()
                        elseif(GetDistanceBetweenCoords(pos, outfitLocation.x, outfitLocation.y, outfitLocation.z, true) < 3)then
                            DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, 'Outfits')
                        end
                    end
                end
            end

            if inside then
                if closesthouse ~= nil then
                    if logoutLocation ~= nil then
                        if(GetDistanceBetweenCoords(pos, logoutLocation.x, logoutLocation.y, logoutLocation.z, true) < 1.5)then
                            DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, '~g~E~w~ - Uitloggen')
                            if IsControlJustPressed(0, Keys["E"]) then
                                exports['qb-interior']:DespawnInterior(houseObj, function()
                                    DoScreenFadeIn(500)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(10)
                                    end
                                    TriggerEvent('qb-weathersync:client:EnableSync')
                                    SetEntityCoords(GetPlayerPed(-1), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z + 0.5)
                                    SetEntityHeading(GetPlayerPed(-1), Config.Houses[closesthouse].coords.enter.h)
                                    inOwned = false
                                    inside = false
                                    TriggerServerEvent('qb-houses:server:logOut')
                                end)
                            end
                        elseif(GetDistanceBetweenCoords(pos, logoutLocation.x, logoutLocation.y, logoutLocation.z, true) < 3)then
                            DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, 'Uitloggen')
                        end
                    end
                end
            end
        else
            if not isOwned then
                if closesthouse ~= nil then
                    if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                        if not viewCam then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '[~g~E~w~] Om het huis te bezichtigen')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TriggerServerEvent('qb-houses:server:viewHouse', closesthouse)
                            end
                        end
                    end
                end
            elseif isOwned then
                if closesthouse ~= nil then
                    if not inOwned then
                        if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                            if not Config.Houses[closesthouse].locked then
                                DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z + 1.2, '[~g~E~w~] Om naar ~b~binnen~w~ te gaan')
                                if IsControlJustPressed(0, Keys["E"])  then
                                    enterNonOwnedHouse(closesthouse)
                                end
                            else
                                DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z + 1.2, 'De deur is ~r~vergrendeld / ~g~G~w~ - Aanbellen')
                                if IsControlJustPressed(0, Keys["G"]) then
                                    TriggerServerEvent('qb-houses:server:RingDoor', closesthouse)
                                end
                            end
                        end
                    elseif inOwned then
                        if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '[~g~E~w~] Om huis te verlaten')
                            if IsControlJustPressed(0, Keys["E"]) then
                                leaveNonOwnedHouse(closesthouse)
                            end
                        end

                        -- STASH
                        local StashObject = nil
                        if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x - POIOffsets.stash.x, Config.Houses[closesthouse].coords.enter.y - POIOffsets.stash.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.stash.z, true) < 1.5)then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x - POIOffsets.stash.x, Config.Houses[closesthouse].coords.enter.y - POIOffsets.stash.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.stash.z, '~g~E~w~ - Stash')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TriggerEvent("inventory:client:SetCurrentStash", closesthouse)
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", closesthouse)
                            end
                        elseif(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x - POIOffsets.stash.x, Config.Houses[closesthouse].coords.enter.y - POIOffsets.stash.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.stash.z, true) < 3)then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x - POIOffsets.stash.x, Config.Houses[closesthouse].coords.enter.y - POIOffsets.stash.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.stash.z, 'Stash')
                        end
                    end
                end
            end
        end          
    end
end)

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

RegisterNetEvent('qb-houses:client:RingDoor')
AddEventHandler('qb-houses:client:RingDoor', function(player, house)
    if closesthouse == house and inside then
        CurrentDoorBell = player
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        QBCore.Functions.Notify("Iemand belt aan de deur!")
    end
end)

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('qb-houses:client:giveHouseKey')
AddEventHandler('qb-houses:client:giveHouseKey', function(data)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('qb-houses:server:giveHouseKey', playerId, closesthouse)
    else
        QBCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('qb-houses:client:refreshHouse')
AddEventHandler('qb-houses:client:refreshHouse', function(data)
    SetClosestHouse()
    Citizen.Wait(100)
    TriggerEvent('qb-garages:client:setHouseGarage', closesthouse, hasKey)
end)

RegisterNetEvent('qb-houses:client:SpawnInApartment')
AddEventHandler('qb-houses:client:SpawnInApartment', function(house)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if rangDoorbell ~= nil then
        if(GetDistanceBetweenCoords(pos, Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z, true) > 5)then
            return
        end
    end
    closesthouse = house
    enterNonOwnedHouse(house)
    inOwned = false
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
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
    QBCore.Functions.TriggerCallback('qb-houses:server:getSavedOutfits', function(outfits)
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

function openContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
    contractOpen = bool
end

function enterOwnedHouse(house)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Citizen.Wait(250)
    local coords = { x = Config.Houses[house].coords.enter.x, y = Config.Houses[house].coords.enter.y, z= Config.Houses[house].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)
    if Config.Houses[house].tier == 1 then
        data = exports['qb-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['qb-interior']:CreateMichaelShell(coords)
        print('vilaaa')
    end
    Citizen.Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    inside = true
    entering = true
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerEvent('qb-weathersync:client:DisableSync')
    TriggerEvent('qb-weed:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
    entering = false
end

RegisterNetEvent('qb-houses:client:enterOwnedHouse')
AddEventHandler('qb-houses:client:enterOwnedHouse', function(house)
    QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(house)
		end
	end)
end)

function leaveOwnedHouse(house)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Citizen.Wait(250)
    DoScreenFadeOut(250)
    Citizen.Wait(500)
    exports['qb-interior']:DespawnInterior(houseObj, function()
        UnloadDecorations()
        TriggerEvent('qb-weathersync:client:EnableSync')
        Citizen.Wait(250)
        DoScreenFadeIn(250)
        SetEntityCoords(GetPlayerPed(-1), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z + 0.5)
        SetEntityHeading(GetPlayerPed(-1), Config.Houses[closesthouse].coords.enter.h)
        inside = false
        TriggerEvent('qb-weed:client:leaveHouse')
    end)
end

function enterNonOwnedHouse(house)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Citizen.Wait(250)
    local coords = { x = Config.Houses[closesthouse].coords.enter.x, y = Config.Houses[closesthouse].coords.enter.y, z= Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)
    if Config.Houses[house].tier == 1 then
        data = exports['qb-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['qb-interior']:CreateMichaelShell(coords)
        print('vilaaa')
    end
    houseObj = data[1]
    POIOffsets = data[2]
    inside = true
    entering = true
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerEvent('qb-weathersync:client:DisableSync')
    TriggerEvent('qb-weed:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
    inOwned = true
end

function leaveNonOwnedHouse(house)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Citizen.Wait(250)
    DoScreenFadeOut(250)
    Citizen.Wait(500)
    exports['qb-interior']:DespawnInterior(houseObj, function()
        UnloadDecorations()
        TriggerEvent('qb-weathersync:client:EnableSync')
        Citizen.Wait(250)
        DoScreenFadeIn(250)
        SetEntityCoords(GetPlayerPed(-1), Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z + 0.5)
        SetEntityHeading(GetPlayerPed(-1), Config.Houses[house].coords.enter.h)
        inOwned = false
        TriggerEvent('qb-weed:client:leaveHouse')
    end)
end

RegisterNetEvent('qb-houses:client:setupHouseBlips')
AddEventHandler('qb-houses:client:setupHouseBlips', function()
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        if isLoggedIn then
            QBCore.Functions.TriggerCallback('qb-houses:server:getOwnedHouses', function(ownedHouses)
                if ownedHouses ~= nil then
                    for k, v in pairs(ownedHouses) do
                        local house = Config.Houses[ownedHouses[k]]
                        HouseBlip = AddBlipForCoord(house.coords.enter.x, house.coords.enter.y, house.coords.enter.z)

                        SetBlipSprite (HouseBlip, 40)
                        SetBlipDisplay(HouseBlip, 4)
                        SetBlipScale  (HouseBlip, 0.65)
                        SetBlipAsShortRange(HouseBlip, true)
                        SetBlipColour(HouseBlip, 3)

                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentSubstringPlayerName(house.adress)
                        EndTextCommandSetBlipName(HouseBlip)
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent('qb-houses:client:SetClosestHouse')
AddEventHandler('qb-houses:client:SetClosestHouse', function()
    SetClosestHouse()
end)

function setViewCam(coords, h, yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    viewCam = true
end

function disableViewCam()
    if viewCam then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        viewCam = false
    end
end

RegisterNUICallback('buy', function()
    openContract(false)
    disableViewCam()
    TriggerServerEvent('qb-houses:server:buyHouse', closesthouse)
end)

RegisterNUICallback('exit', function()
    openContract(false)
    disableViewCam()
end)

RegisterNetEvent('qb-houses:client:viewHouse')
AddEventHandler('qb-houses:client:viewHouse', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    print(closesthouse)
    setViewCam(Config.Houses[closesthouse].coords.cam, Config.Houses[closesthouse].coords.cam.h, Config.Houses[closesthouse].coords.yaw)
    Citizen.Wait(500)
    openContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[closesthouse].adress,
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

function SetClosestHouse()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, house in pairs(Config.Houses) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true)
            current = id
        end
    end
    closesthouse = current

    QBCore.Functions.TriggerCallback('qb-houses:server:hasKey', function(result)
        hasKey = result
    end, closesthouse)

    QBCore.Functions.TriggerCallback('qb-houses:server:isOwned', function(result)
        isOwned = result
    end, closesthouse)

    QBCore.Functions.TriggerCallback('qb-houses:server:getHouseLocations', function(result)
        if result ~= nil then
            if result.stash ~= nil then
                stashLocation = json.decode(result.stash)
            end

            if result.outfit ~= nil then
                outfitLocation = json.decode(result.outfit)
            end

            if result.logout ~= nil then
                logoutLocation = json.decode(result.logout)
            end
        end
    end, closesthouse)
end

RegisterNetEvent('qb-houses:client:setLocation')
AddEventHandler('qb-houses:client:setLocation', function(data)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}

    if inside then
        if hasKey then
            if data.id == 'setstash' then
                TriggerServerEvent('qb-houses:server:setLocation', coords, closesthouse, 1)
            elseif data.id == 'setoutift' then
                TriggerServerEvent('qb-houses:server:setLocation', coords, closesthouse, 2)
            elseif data.id == 'setlogout' then
                TriggerServerEvent('qb-houses:server:setLocation', coords, closesthouse, 3)
            end
        else
            QBCore.Functions.Notify('Je bent niet de eigenaar van het huis..', 'error')
        end
    else    
        QBCore.Functions.Notify('Je bent niet in een huis..', 'error')
    end
end)

RegisterNetEvent('qb-houses:client:refreshLocations')
AddEventHandler('qb-houses:client:refreshLocations', function(house, location, type)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse == house then
        if inside then
            if type == 1 then
                stashLocation = json.decode(location)
            elseif type == 2 then
                outfitLocation = json.decode(location)
            elseif type == 3 then
                logoutLocation = json.decode(location)
            end
        end
    end
end)