QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local creatingCharacter = false

local cam = -1							-- Camera control
local heading = 332.219879				-- Heading coord
local zoom = "character"					-- Define which tab is shown first (Default: Head)

RegisterNetEvent('qb-clothing:client:openMenu')
AddEventHandler('qb-clothing:client:openMenu', function()
    openMenu()
end)

function openMenu()
    SendNUIMessage({
        action = "open",
        items = Config.Menus["clothing"]
    })
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)
    creatingCharacter = true

    enableCam()
end

function enableCam()
    SetEntityHeading(GetPlayerPed(-1), heading)
    -- Camera
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
    end
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    if zoom == "character" then
        SetCamCoord(cam, x+0.3, y+2.0, z+0.0)
        SetCamRot(cam, 0.0, 0.0, 170.0)
    end
end

function disableCam()
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)
end

function closeMenu()
    SendNUIMessage({
        action = "close",
    })
    disableCam()
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    creatingCharacter = false
    disableCam()
end)

RegisterNUICallback('getCatergoryItems', function(data, cb)
    cb(Config.Menus[data.category])
end)

local skinData = {
    face = 1,
    skin = 1,
}

RegisterNUICallback('updateSkin', function(data)
    local ped = GetPlayerPed(-1)
    local clothingCategory = data.clothingType
    local type = data.type
    local item = data.articleNumber
    local texture = 3

    if clothingCategory == "pants" then
        if type == "item" then
            SetPedComponentVariation(ped, 4, item, 0, 2)
        elseif type == "texture" then
            local curPants = GetPedDrawableVariation(ped, 4)
            SetPedComponentVariation(ped, 4, curPants, item, 2)
        end
    elseif clothingCategory == "face" then
        if type == "item" then
            SetPedHeadBlendData(ped, item, item, item, skinData.skin, skinData.skin, skinData.skin, 1.0, 1.0, 1.0, true)
            skinData.face = item
        elseif type == "texture" then
            SetPedHeadBlendData(ped, skinData.face, skinData.face, skinData.face, item, item, item, 1.0, 1.0, 1.0, true)
            skinData.skin = item
        end
    end
end)

RegisterNUICallback('updateSkinOnInput', function(data)
    local ped = GetPlayerPed(-1)
    local clothingCategory = data.clothingType
    local type = data.type
    local articleNumber = tonumber(data.articleNumber)

    if clothingCategory == "pants" then
        if type == "item" then
            SetPedComponentVariation(ped, 4, articleNumber, 0, 2)
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 4)
            SetPedComponentVariation(ped, 4, curItem, articleNumber, 2)
        end
    end
end)