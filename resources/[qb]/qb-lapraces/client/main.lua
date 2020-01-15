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

local CurrentRace = nil
local Races = {}
local CurrentCheckpoint = 0
local CurrentLap = 0
local ClosestRace = nil

QBCore = nil

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

-- Checkpoints & Laps
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(10)
        if QBCore ~= nil then
            if CurrentRace ~= nil then 
                if Races[CurrentRace].started then 
                    if Races[CurrentRace].checkpoints[CurrentCheckpoint+1] ~= nil then 
                        local pos = GetEntityCoords(GetPlayerPed(-1))
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Races[CurrentRace].checkpoints[CurrentCheckpoint+1].x, Races[CurrentRace].checkpoints[CurrentCheckpoint+1].y, Races[CurrentRace].checkpoints[CurrentCheckpoint+1].z, true) < 5.0 then
                            CurrentCheckpoint = CurrentCheckpoint + 1
                            SetNewWaypoint(Races[CurrentRace].checkpoints[CurrentCheckpoint+1].x, Races[CurrentRace].checkpoints[CurrentCheckpoint+1].y)
                        end
                    else
                        CurrentCheckpoint = 0
                        CurrentLap = CurrentLap + 1
                        if CurrentLap >= Races[CurrentRace].laps then 
                            TriggerServerEvent("qb-lapraces:server:RaceWinner", CurrentRace)
                        end
                    end
                end
            else
                if ClosestRace ~= nil and CurrentRace == nil then 
                    if Races[ClosestRace].active and not Races[ClosestRace].started then 
                        local pos = GetEntityCoords(GetPlayerPed(-1))
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Races[ClosestRace].checkpoints[1].x, Races[ClosestRace].checkpoints[1].y, Races[ClosestRace].checkpoints[1].z, true) < 10.0 then
                            DrawText3Ds(Races[ClosestRace].checkpoints[1].x, Races[ClosestRace].checkpoints[1].y, Races[ClosestRace].checkpoints[1].z, "~g~H~w~ Doe mee met de race (~g~€" .. Races[ClosestRace].price .. "~w~ cash)")
                            if IsControlJustReleased(0, Keys["H"]) then
                                TriggerServerEvent("qb-lapraces:server:JoinRace", ClosestRace)
                            end
                        end
                    end
                end
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('qb-lapraces:client:RaceCreated')
AddEventHandler('qb-lapraces:client:RaceCreated', function(raceId, raceInfo)
    Races[raceId] = raceInfo
end)

RegisterNetEvent('qb-lapraces:client:RaceJoined')
AddEventHandler('qb-lapraces:client:RaceJoined', function(raceId)
    CurrentRace = raceId
    ClosestRace = nil
    for k, v in pairs(Races[CurrentRace].checkpoints) do
        Races[CurrentRace].checkpoints[k].blip = AddBlipForCoord(Races[CurrentRace].checkpoints[k].x, Races[CurrentRace].checkpoints[k].y, Races[CurrentRace].checkpoints[k].z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 15)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        ShowNumberOnBlip(blip, k)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Checkpoint: " .. k)
        EndTextCommandSetBlipName(blip)
    end
    QBCore.Functions.Notify("Joined race: " .. Races[CurrentRace].label)
end)

RegisterNetEvent('qb-lapraces:client:StartRace')
AddEventHandler('qb-lapraces:client:StartRace', function(raceId)
    if Races[raceId] ~= nil then
        Races[raceId].started = true
        if CurrentRace == raceId then
            local countDown = 5
            FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), true), true)
            while countDown > 0 do
                PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
                QBCore.Functions.Notify(countDown, 'primary', 800)
                countDown = countDown - 1
                Citizen.Wait(1000)
            end
            FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), true), false)
            QBCore.Functions.Notify("GOOOOOOOO!")
        end
    else
        QBCore.Functions.Notify("Race doesn't exist???", "error")
    end
end)

RegisterNetEvent('qb-lapraces:client:RaceFinished')
AddEventHandler('qb-lapraces:client:RaceFinished', function(raceId, winner)
    if Races[raceId] ~= nil then
        if CurrentRace == raceId then
            QBCore.Functions.Notify("De race is afgelopen! De winnaar is: " .. winner)
            TriggerEvent("qb-lapraces:client:RaceLeft")
        end
    end
end)

RegisterNetEvent('qb-lapraces:client:RaceStopped')
AddEventHandler('qb-lapraces:client:RaceStopped', function(raceId)
    if Races[raceId] ~= nil then
        if CurrentRace == raceId then
            QBCore.Functions.Notify("De race is stopgezet!", "error")
            TriggerServerEvent("qb-lapraces:client:Refund", raceId)
            TriggerEvent("qb-lapraces:client:RaceLeft")
        end
    end
end)

RegisterNetEvent('qb-lapraces:client:LeaveRace')
AddEventHandler('qb-lapraces:client:LeaveRace', function()
    if Races[raceId] ~= nil then
        if CurrentRace == raceId then
            QBCore.Functions.Notify("De race is stopgezet!", "error")
            TriggerServerEvent("qb-lapraces:client:Refund", raceId)
            TriggerEvent("qb-lapraces:client:RaceLeft")
        end
    end
end)

RegisterNetEvent('qb-lapraces:client:RaceLeft')
AddEventHandler('qb-lapraces:client:RaceLeft', function()
    for k, v in pairs(Races[CurrentRace].checkpoints) do
        if DoesBlipExist(Races[CurrentRace].checkpoints[k].blip) then
            RemoveBlip(Races[CurrentRace].checkpoints[k].blip)
        end
    end
    QBCore.Functions.Notify("Left race: " .. Races[CurrentRace].label, "error")
    CurrentRace = nil
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