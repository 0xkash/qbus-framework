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

local uiOpen            = false
local currentRegister   = nil

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k, v in pairs(Config.Registers) do
            local dist = GetDistanceBetweenCoords(pos, Config.Registers[k].x, Config.Registers[k].y, Config.Registers[k].z)

            if dist <= 1 and IsControlJustPressed(0, 51) and not Config.Registers[k].robbed then
                lockpick(true)
                currentRegister = k
            elseif dist <= 1 and Config.Registers[k].robbed then
                DrawText3Ds(Config.Registers[k].x, Config.Registers[k].y, Config.Registers[k].z, 'This cash register is empty')
            end
        end
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Registers) do
        Blip = AddBlipForCoord(Config.Registers[k].x, Config.Registers[k].y, Config.Registers[k].z)

        SetBlipSprite (Blip, 286)
        SetBlipDisplay(Blip, 4)
        SetBlipScale  (Blip, 0.4)
        SetBlipAsShortRange(Blip, true)
        SetBlipColour(Blip, 0)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Register Robbery")
        EndTextCommandSetBlipName(Blip)
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

function lockpick(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
    uiOpen = bool
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

function takeAnim()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(1000)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

RegisterNUICallback('success', function()
    local ped = GetPlayerPed(-1)
    TriggerServerEvent('qb-storerobbery:server:takeMoney')
    TriggerServerEvent('qb-storerobbery:server:setRegisterStatus', currentRegister)
    lockpick(false)
    loadAnimDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(1000)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end)

RegisterNUICallback('fail', function()
    lockpick(false)
end)

RegisterNUICallback('exit', function()
    lockpick(false)
end)

RegisterNetEvent('qb-storerobbery:client:setRegisterStatus')
AddEventHandler('qb-storerobbery:client:setRegisterStatus', function(register, bool)
    Config.Registers[register].robbed = bool
end)