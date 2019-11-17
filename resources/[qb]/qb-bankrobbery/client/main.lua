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

local closestBank = nil
local inRange
local requiredItemsShowed = false

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist

        if QBCore ~= nil then
            requiredItems = {
                [1] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
                [2] = {name = QBCore.Shared.Items["trojan_usb"]["name"], image = QBCore.Shared.Items["trojan_usb"]["image"]},
            }
            inRange = false

            for k, v in pairs(Config.SmallBanks) do
                dist = GetDistanceBetweenCoords(pos, Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"])

                if dist < 30 then
                    closestBank = k
                    inRange = true
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if dist > 1 then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                end
            end

            if not inRange then
                Citizen.Wait(2000)
                closestBank = nil
            end
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if QBCore ~= nil then
            if closestBank ~= nil then
                if Config.SmallBanks[closestBank]["isOpened"] then
                    for k, v in pairs(Config.SmallBanks[closestBank]["lockers"]) do
                        local lockerDist = GetDistanceBetweenCoords(pos, Config.SmallBanks[closestBank]["lockers"][k].x, Config.SmallBanks[closestBank]["lockers"][k].y, Config.SmallBanks[closestBank]["lockers"][k].z)
                        if not Config.SmallBanks[closestBank]["lockers"][k]["isBusy"] then
                            if not Config.SmallBanks[closestBank]["lockers"][k]["isOpened"] then
                                if lockerDist < 5 then
                                    DrawMarker(2, Config.SmallBanks[closestBank]["lockers"][k].x, Config.SmallBanks[closestBank]["lockers"][k].y, Config.SmallBanks[closestBank]["lockers"][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)

                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.SmallBanks[closestBank]["lockers"][k].x, Config.SmallBanks[closestBank]["lockers"][k].y, Config.SmallBanks[closestBank]["lockers"][k].z + 0.3, '[E] Kluis openbreken')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            openLocker(closestBank, k)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(2500)
            end
        end

        Citizen.Wait(3)
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

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    
    QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(isBusy)
        if not isBusy then
            if closestBank ~= nil then
                local dist = GetDistanceBetweenCoords(pos, Config.SmallBanks[closestBank]["coords"]["x"], Config.SmallBanks[closestBank]["coords"]["y"], Config.SmallBanks[closestBank]["coords"]["z"])

                if dist < 1.5 then
                    if not Config.SmallBanks[closestBank]["isOpened"] then 
                        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                            if result then 
                                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                QBCore.Functions.Progressbar("hack_gate", "Electronic kit aansluiten..", math.random(5000, 10000), false, true, {
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
                                    TriggerEvent("mhacking:show")
                                    TriggerEvent("mhacking:start", math.random(5, 9), --[[math.random(10, 18)]]60, OnHackDone)
                                end, function() -- Cancel
                                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                    QBCore.Functions.Notify("Geannuleerd..", "error")
                                end)
                            else
                                QBCore.Functions.Notify("Je mist een item..", "error")
                            end
                        end, "trojan_usb")
                    else
                        QBCore.Functions.Notify("Het lijkt erop dat de bank al open is..", "error")
                    end
                end
            end
        else
            QBCore.Functions.Notify("Het beveiligingsslot is actief, het openen van de deur is momenteel niet mogelijk..", "error", 5500)
        end
    end)
end)

RegisterNetEvent('qb-bankrobbery:client:setBankState')
AddEventHandler('qb-bankrobbery:client:setBankState', function(bankId, state)
    Config.SmallBanks[bankId]["isOpened"] = state
    TriggerServerEvent('qb-bankrobbery:server:setTimeout')

    if state then
        OpenBankDoor(bankId)
    end
end)

function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.SmallBanks[bankId]["coords"]["x"], Config.SmallBanks[bankId]["coords"]["y"], Config.SmallBanks[bankId]["coords"]["z"], 5.0, `v_ilev_gb_vauldr`, false, false, false)
    local timeOut = 10
    local entHeading = 250.0

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do

                if entHeading ~= 160.0 then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Citizen.Wait(10)
            end
        end)
    end
end

function ResetBankDoors()
    for k, v in pairs(Config.SmallBanks) do
        local object = GetClosestObjectOfType(Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"], 5.0, `v_ilev_gb_vauldr`, false, false, false)

        SetEntityHeading(object, 250.0)
    end
end

function openLocker(bankId, lockerId)
    TriggerServerEvent('qb-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', true)
    QBCore.Functions.Progressbar("open_locker", "Kluis aan het openbreken..", math.random(8000, 16000), false, true, {
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
        TriggerServerEvent('qb-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
        TriggerServerEvent('qb-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
        TriggerServerEvent('qb-bankrobbery:server:recieveItem', 'small')
        QBCore.Functions.Notify("Gelukt!", "success")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('qb-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

RegisterNetEvent('qb-bankrobbery:client:setLockerState')
AddEventHandler('qb-bankrobbery:client:setLockerState', function(bankId, lockerId, state, bool)
    Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    print(Config.SmallBanks[bankId]["lockers"][lockerId][state])
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('qb-bankrobbery:server:setBankState', closestBank, true)
    else
		TriggerEvent('mhacking:hide')
	end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ResetBankDoors()
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function searchPockets()
    if ( DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) ) then 
        loadAnimDict( "random@mugging4" )
        TaskPlayAnim( GetPlayerPed(-1), "random@mugging4", "agitated_loop_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    end
end

function giveAnim()
    if ( DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end