Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

QBCore = nil
local isLoggedIn = false
local CurrentCops = 0

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

local requiredItemsShowed = false
local requiredItems = {}
local currentSpot = 0

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 1.0 then
                if not Config.Locations["thermite"].isDone then 
                    if not requiredItemsShowed then
                        requiredItems = {
                            [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                        }
                        requiredItemsShowed = true
                        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                    end
                end
            else
                if requiredItemsShowed then
                    requiredItems = {
                        [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                    }
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            for spot, location in pairs(Config.Locations["takeables"]) do
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z, true)
                if dist < 1.0 then
                    inRange = true
                    if dist < 0.6 then
                        if not requiredItemsShowed then
                            requiredItems = {
                                [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                            }
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                        if not Config.Locations["takeables"][spot].isBusy and not Config.Locations["takeables"][spot].isDone then
                            DrawText3Ds(Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z, '~g~E~w~ Om item te pakken')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if CurrentCops >= 3 then
                                    if Config.Locations["thermite"].isDone then 
                                        QBCore.Functions.TriggerCallback('qb-radio:server:GetItem', function(hasItem)
                                            if hasItem then
                                                currentSpot = spot
                                                TriggerEvent("qb-lockpick:client:openLockpick", lockpickDone)
                                            else
                                                QBCore.Functions.Notify("Je mist een grote lockpick..", "error")
                                            end
                                        end, "advancedlockpick")
                                    else
                                        QBCore.Functions.Notify("Beveiliging is nog actief..", "error")
                                    end
                                else
                                    QBCore.Functions.Notify("Niet genoeg politie..", "error")
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                if requiredItemsShowed then
                    requiredItems = {
                        [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                    }
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
                Citizen.Wait(2000)
            end
        end
    end
end)

function lockpickDone(success)
    if (math.random(1, 100) <= 80 and not IsWearingHandshoes()) or (math.random(1, 100) <= 20 and IsWearingHandshoes()) then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    
    if success then
        GrabItem(currentSpot)
    else
        TriggerServerEvent("QBCore:Server:RemoveItem", "advancedlockpick", 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["advancedlockpick"], "remove")
    end
end

function GrabItem(spot)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if requiredItemsShowed then
        requiredItemsShowed = false
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
    QBCore.Functions.Progressbar("grab_ifruititem", "Item loskoppelen..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('qb-ifruitstore:server:setSpotState', "isDone", true, spot)
        TriggerServerEvent('qb-ifruitstore:server:setSpotState', "isBusy", false, spot)
        TriggerServerEvent('qb-ifruitstore:server:itemReward', spot)
        TriggerServerEvent('qb-ifruitstore:server:PoliceAlertMessage', 'Personen proberen spullen te stelen bij de iFruit winkel', pos, true)
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('qb-jewellery:server:setSpotState', "isBusy", false, spot)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    TriggerServerEvent("qb-ifruitstore:server:LoadLocationList")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('qb-ifruitstore:client:LoadList')
AddEventHandler('qb-ifruitstore:client:LoadList', function(list)
    Config.Locations = list
end)

RegisterNetEvent('thermite:UseThermite')
AddEventHandler('thermite:UseThermite', function()
    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 1.0 then
        if CurrentCops >= 3 then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if (math.random(1, 100) <= 80 and not IsWearingHandshoes()) or (math.random(1, 100) <= 20 and IsWearingHandshoes()) then
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            end
            if requiredItemsShowed then
                requiredItems = {
                    [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                }
                requiredItemsShowed = false
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["thermite"], "remove")
                TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isBusy", true)
                SendNUIMessage({
                    action = "openThermite",
                    amount = math.random(5, 10),
                })
            end
        else
            QBCore.Functions.Notify("Niet genoeg politie..", "error")
        end
    end
end)

RegisterNetEvent('qb-ifruitstore:client:setSpotState')
AddEventHandler('qb-ifruitstore:client:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
end)

RegisterNetEvent('qb-ifruitstore:client:SetThermiteStatus')
AddEventHandler('qb-ifruitstore:client:SetThermiteStatus', function(stateType, state))
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
end)

RegisterNetEvent('qb-ifruitstore:client:PoliceAlertMessage')
AddEventHandler('qb-ifruitstore:client:PoliceAlertMessage', function(msg, coords, blip)
    if blip then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent("chatMessage", "112-MELDING", "error", msg)
        local transG = 100
        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        SetBlipSprite(blip, 9)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, transG)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("112 - Verdachte situatie iFruit winkel")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    else
        if not robberyAlert then
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("chatMessage", "112-MELDING", "error", msg)
            robberyAlert = true
        end
    end
end)

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isBusy", false)
end)

RegisterNUICallback('thermitesuccess', function()
    QBCore.Functions.Notify("De zekeringen zijn kapot", "success")
    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 1.0 then
        TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isDone", true)
        TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isBusy", false)
    end
end)

function DrawText3Ds(x, y, z, text)
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