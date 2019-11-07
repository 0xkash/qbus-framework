Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, "~g~E~w~ - Omkleden | ~g~H~w~ - Outfit opslaan | ~g~G~w~ - Outfits")
                            if IsControlJustReleased(0, Keys["E"]) then
                                if PlayerData.charinfo.gender == 0 then
                                    TriggerEvent("maleclothesstart", false)
                                else
                                    TriggerEvent("femaleclothesstart", false)
                                end
                                DoScreenFadeIn(50)
                            elseif IsControlJustReleased(0, Keys["H"]) then
                                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP9N", "", "", "", "", "", 20)
                                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                                    Citizen.Wait(7)
                                end
                                local outfitName = GetOnscreenKeyboardResult()
                                TriggerEvent("clothes:client:SaveOutfit", false, outfitName)
                            elseif IsControlJustPressed(0, Keys["G"]) then
                                MenuOutfits()
                                Menu.hidden = not Menu.hidden
                            end
                            Menu.renderGUI()
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 4.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, "Omkleden")
                        end  
                    end
                end)
            end
    
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 1.5) then
                            if not PlayerData.job.onduty then
                                QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "~g~E~w~ - In dienst gaan")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "~r~E~w~ - Uit dienst gaan")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerServerEvent("QBCore:ToggleDuty")
                            end
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true) < 4.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "In/Uit dienst")
                        end  
                    end
                end)
            end
    
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" and PlayerData.job.onduty then
                        DrawMarker(2, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.DrawText3D(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, "~g~E~w~ - Voertuig opbergen")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, "~g~E~w~ - Voertuigen")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end  
                    end
                end)
            end
    
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicledown"].x, Config.Locations["vehicledown"].y, Config.Locations["vehicledown"].z, true) < 4.5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" and PlayerData.job.onduty then
                        DrawMarker(2, Config.Locations["vehicledown"].x, Config.Locations["vehicledown"].y, Config.Locations["vehicledown"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicledown"].x, Config.Locations["vehicledown"].y, Config.Locations["vehicledown"].z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.DrawText3D(Config.Locations["vehicledown"].x, Config.Locations["vehicledown"].y, Config.Locations["vehicledown"].z, "~g~E~w~ - Voertuig opbergen")
                            else
                                QBCore.Functions.DrawText3D(Config.Locations["vehicledown"].x, Config.Locations["vehicledown"].y, Config.Locations["vehicledown"].z, "~g~E~w~ - Voertuigen")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuGarage(true)
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end  
                    end
                end)
            end
    
            if isStatusChecking then
                for k, v in pairs(statusChecks) do
                    local x,y,z = table.unpack(GetPedBoneCoords(statusCheckPed, v.bone))
                    DrawText3D(x, y, z, v.label)
                end
            end
    
            if isHealingPerson then
                if not IsEntityPlayingAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3) then
                    loadAnimDict(healAnimDict)	
                    TaskPlayAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end
            end
        end
    end
end)

RegisterNetEvent('hospital:client:SendAlert')
AddEventHandler('hospital:client:SendAlert', function(msg)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent("chatMessage", "PAGER", "error", msg)
end)

RegisterNetEvent('112:client:SendAlert')
AddEventHandler('112:client:SendAlert', function(msg, blipSettings)
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "112-MELDING", "error", msg)

    if blipSettings ~= nil then
        local transG = 250
        local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
        SetBlipSprite(blip, blipSettings.sprite)
        SetBlipColour(blip, blipSettings.color)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, blipSettings.scale)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipSettings.text)
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
    end
end)


RegisterNetEvent('hospital:client:AiCall')
AddEventHandler('hospital:client:AiCall', function()
    local players = QBCore.Functions.GetPlayers()
    local PlayerPedList = {}
    for i=1, #players, 1 do
        table.insert(PlayerPedList, GetPlayerPed(i))
    end
    table.insert(PlayerPedList, GetPlayerPed(-1))
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPedList)
    local gender = QBCore.Functions.GetPlayerData().gender
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    if closestDistance < 50.0 then
        MakeCall(closestPed, gender, street1, street2)
    end
end)

function MakeCall(ped, male, street1, street2)
    local callAnimDict = "cellphone@"
    local callAnim = "cellphone_call_listen_base"
    local rand = (math.random(6,9) / 100) + 0.3
    local rand2 = (math.random(6,9) / 100) + 0.3
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local blipsettings = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        sprite = 280,
        color = 4,
        scale = 0.9,
        text = "180 - Gewond persoon"
    }

    if math.random(10) > 5 then
        rand = 0.0 - rand
    end

    if math.random(10) > 5 then
        rand2 = 0.0 - rand2
    end

    local moveto = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), rand, rand2, 0.0)

    TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(ped, true) 

    local dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)

    while dist > 3.5 and isDead do
        TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
        dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)
        Citizen.Wait(100)
    end

    ClearPedTasksImmediately(ped)
    TaskLookAtEntity(ped, GetPlayerPed(-1), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, GetPlayerPed(-1), 5500)

    Citizen.Wait(3000)

    --TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_MOBILE", 0, 1)
    loadAnimDict(callAnimDict)
    TaskPlayAnim(ped, callAnimDict, callAnim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)

    SetPedKeepTask(ped, true) 

    Citizen.Wait(5000)

    TriggerServerEvent("hospital:server:MakeDeadCall", blipsettings, male, street1, street2)

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)
end

RegisterNetEvent('hospital:client:RevivePlayer')
AddEventHandler('hospital:client:RevivePlayer', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "doctor" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                QBCore.Functions.Progressbar("hospital_revive", "Persoon omhoog helpen..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Je hebt de persoon geholpen!")
                    TriggerServerEvent("hospital:server:RevivePlayer", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                end)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:CheckStatus')
AddEventHandler('hospital:client:CheckStatus', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                statusCheckPed = GetPlayerPed(player)
                QBCore.Functions.TriggerCallback('hospital:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            if k ~= "BLEED" then
                                table.insert(statusChecks, {bone = Config.BoneIndexes[k], label = v.label .." (".. Config.WoundStates[v.severity] ..")"})
                            elseif result[k] > 0 then
                                TriggerEvent("chatMessage", "STATUS CHECK", "error", "Is "..Config.BleedingStates[v].label)
                            end
                        end
                        isStatusChecking = true
                        statusCheckTime = Config.CheckTime
                    end
                end, playerId)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:TreatWounds')
AddEventHandler('hospital:client:TreatWounds', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                QBCore.Functions.Progressbar("hospital_healwounds", "Wonden genezen..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Je hebt de persoon geholpen!")
                    TriggerServerEvent("hospital:server:TreatWounds", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                end)
            end
        end
    end)
end)

function MenuGarage(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Mijn Voertuigen", "VehicleList", isDown)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", {k, isDown}, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"]
    if vehicleInfo[2] then
        coords = Config.Locations["vehicledown"]
    end
    QBCore.Functions.SpawnVehicle(vehicleInfo[1], function(veh)
        SetVehicleNumberPlateText(veh, "AMBU"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end