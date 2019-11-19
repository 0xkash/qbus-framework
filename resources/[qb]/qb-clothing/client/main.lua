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
        action = "open"
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
    elseif clothingCategory == "model" then
        local playerData = QBCore.Functions.GetPlayerData()

        if playerData.charinfo.gender == 0 then
            ChangeToSkinNoUpdate(Config.ManPlayerModels[item])
        else
            ChangeToSkinNoUpdate(Config.WomanPlayerModels[item])
        end
    end
end)

function ChangeToSkinNoUpdate(skin)
	SetEntityInvincible(GetPlayerPed(-1),true)
	local model = GetHashKey(skin)
	if IsModelInCdimage(model) and IsModelValid(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
		if skin ~= "tony" and skin ~= "g_m_m_chigoon_02_m" and skin ~= "u_m_m_jesus_01" and skin ~= "a_m_y_stbla_m" and skin ~= "ig_terry_m" and skin ~= "a_m_m_ktown_m" and skin ~= "a_m_y_skater_m" and skin ~= "u_m_y_coop" and skin ~= "ig_car3guy1_m" then
			SetPedRandomComponentVariation(GetPlayerPed(-1), true)
		end
		
		SetModelAsNoLongerNeeded(model)
	end

	SetEntityInvincible(GetPlayerPed(-1),false)
end

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

RegisterNUICallback('setCurrentPed', function(data, cb)
    local playerData = QBCore.Functions.GetPlayerData()
    if playerData.charinfo.gender == 0 then
        cb(Config.ManPlayerModels[data.ped])
    else
        cb(Config.WomanPlayerModels[data.ped])
    end
end)