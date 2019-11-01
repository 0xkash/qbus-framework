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

--CODE

local choosingSpawn = false

RegisterNetEvent('qb-spawn:client:openUI')
AddEventHandler('qb-spawn:client:openUI', function(value)
    SetEntityVisible(GetPlayerPed(-1), false)
    DoScreenFadeOut(250)
    Citizen.Wait(2000)
    DoScreenFadeIn(250)
    QBCore.Functions.GetPlayerData(function(PlayerData)     
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end)
    Citizen.Wait(500)
    SetDisplay(value)
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

local cam = nil

-- function setupSpawnLocations()
--     SendNUIMessage({
--         action = "setupLocations",
--         locations = QB.Spawns
--     })
-- end

RegisterNUICallback('setCam', function(data)
    local location = tostring(data.posname)

    if location == "current" then
        QBCore.Functions.GetPlayerData(function(PlayerData)     
            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 1, true, true)
        end)
    else
        local campos = QB.Spawns[location].coords

        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end
end)

RegisterNUICallback('spawnplayer', function(data)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = GetPlayerPed(-1)

    print(type)

    if type == "current" then
        print('current')
        SetDisplay(false)
        DoScreenFadeOut(500)
        Citizen.Wait(5000)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            SetEntityCoords(GetPlayerPed(-1), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityHeading(GetPlayerPed(-1), PlayerData.position.a)
            FreezeEntityPosition(GetPlayerPed(-1), false)
        end)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        SetEntityVisible(GetPlayerPed(-1), true)
        Citizen.Wait(500)
        DoScreenFadeIn(250)
    elseif type == "house" then
        SetDisplay(false)
        DoScreenFadeOut(500)
        Citizen.Wait(5000)
        TriggerEvent('qb-houses:client:enterOwnedHouse', location)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        SetEntityVisible(GetPlayerPed(-1), true)
        Citizen.Wait(500)
        DoScreenFadeIn(250)
        print('house')
    elseif type == "normal" then
        print('normal')
        local pos = QB.Spawns[location].coords
        SetDisplay(false)
        DoScreenFadeOut(500)
        Citizen.Wait(5000)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        Citizen.Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.h)
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        SetEntityVisible(GetPlayerPed(-1), true)
        Citizen.Wait(500)
        DoScreenFadeIn(250)
    end
end)

function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

Citizen.CreateThread(function()
    while choosingSpawn do
        Citizen.Wait(0)

        DisableAllControlActions(0)
    end
end)

RegisterNetEvent('qb-spawn:client:setupHouseSpawns')
AddEventHandler('qb-spawn:client:setupHouseSpawns', function(cData)
    print('yeet?')
    QBCore.Functions.TriggerCallback('qb-spawn:server:getOwnedHouses', function(houses)
        local myHouses = {}
        if houses ~= nil then
            for i = 1, (#houses), 1 do
                table.insert(myHouses, {
                    house = houses[i].house,
                    label = Config.Houses[houses[i].house].adress,
                })
            end
        end

        Citizen.Wait(500)
        SendNUIMessage({
            action = "setupLocations",
            locations = QB.Spawns,
            houses = myHouses,
        })
    end, cData.citizenid)
end)