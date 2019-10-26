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

--- CODE

local choosingCharacter = false
local cam = nil

function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "openUI",
        toggle = bool,
    })
    choosingCharacter = bool
    skyCam(bool)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
        if NetworkIsSessionStarted() then
            Citizen.Wait(100)
            selectChar()
			return
		end
	end
end)


RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('disconnectButton', function()
    TriggerServerEvent('qb-multicharacter:server:disconnect')
end)

RegisterNUICallback('selectCharacter', function(data)
    local cData = data.cData
    
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    TriggerEvent('qb-spawn:client:openUI', true)
    openCharMenu(false)
end)

RegisterNetEvent('qb-multicharacter:client:closeNUI')
AddEventHandler('qb-multicharacter:client:closeNUI', function()
    openCharMenu(false)
end)

RegisterNetEvent('qb-multicharacter:client:chooseChar')
AddEventHandler('qb-multicharacter:client:chooseChar', function()
    openCharMenu(true)
end)

function selectChar()
    openCharMenu(true)
end

RegisterNUICallback('setupCharacters', function()
    QBCore.Functions.TriggerCallback("test:yeet", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    cData.gender = tonumber (cData.gender)

    TriggerServerEvent('qb-multicharacter:server:createCharacter', cData)
    Citizen.Wait(500)
end)

RegisterNUICallback('removeCharacter', function(data)
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', data.citizenid)
end)

function skyCam(bool)
    if bool then
        DoScreenFadeIn(10)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(GetPlayerPed(-1), true)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -358.56, -981.96, 286.25, 320.00, 0.00, -50.00, 90.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end

skyCam(false)