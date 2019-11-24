local closestStation = 0
local currentStation = 0
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist

        if QBCore ~= nil then
            local inRange = false
            for k, v in pairs(Config.PowerStations) do
                dist = GetDistanceBetweenCoords(pos, Config.PowerStations[k].coords.x, Config.PowerStations[k].coords.y, Config.PowerStations[k].coords.z)
                if dist < 5 then
                    closestStation = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(1000)
                closestStation = 0
            end
        end
        Citizen.Wait(3)
    end
end)
local requiredItemsShowed = false
local requiredItems = {}
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    requiredItems = {
        [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
    }
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if QBCore ~= nil then
            if closestStation ~= 0 then
                if not Config.PowerStations[closestStation].hit then
                    DrawMarker(2, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                    local dist = GetDistanceBetweenCoords(pos, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z)
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            else
                Citizen.Wait(1500)
            end
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('thermite:UseThermite')
AddEventHandler('thermite:UseThermite', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestStation ~= 0 then
        local dist = GetDistanceBetweenCoords(pos, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z)
        if dist < 1.5 then
            QBCore.Functions.TriggerCallback('police:GetCops', function(cops)
                if cops >= 0 then
                    if not Config.PowerStations[closestStation].hit then
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            action = "openThermite",
                            amount = math.random(5, 10),
                        })
                        currentStation = closestStation
                    else
                        QBCore.Functions.Notify("Het lijkt erop dat de zekeringen zijn doorgebrand..", "error")
                    end
                else
                    QBCore.Functions.Notify("Niet genoeg politie.. (2 nodig)", "error")
                end
            end)
        end
    end
end)

RegisterNetEvent('qb-bankrobbery:client:SetStationStatus')
AddEventHandler('qb-bankrobbery:client:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
end)

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('thermitesuccess', function()
    QBCore.Functions.Notify("De zekeringen zijn kapot", "success")
    if currentStation ~= 0 then
        TriggerServerEvent("qb-bankrobbery:server:SetStationStatus", currentStation, true)
    end
end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)