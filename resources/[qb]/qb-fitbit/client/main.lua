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

local inWatch = false

function openWatch()
    SendNUIMessage({
        action = "openWatch",
        watchData = {}
    })
    SetNuiFocus(true, true)
    inWatch = true
end

function closeWatch()
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', function()
    closeWatch()
end)

RegisterNUICallback('setFoodWarning', function(data)
    local foodValue = tonumber(data.value)

    TriggerServerEvent('qb-fitbit:server:setValue', 'food', foodValue)

    QBCore.Functions.Notify('Fitbit: Voedsel waarschuwing ingesteld op '..foodValue..'%')
    print('setet')
end)

RegisterNUICallback('setThirstWarning', function(data)
    local thirstValue = tonumber(data.value)

    TriggerServerEvent('qb-fitbit:server:setValue', 'thirst', thirstValue)

    QBCore.Functions.Notify('Fitbit: Dorst waarschuwing ingesteld op '..thirstValue..'%')
end)

Citizen.CreateThread(function()
    while true do

        if IsControlJustPressed(0, Keys["N"]) then
            QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                if result then
                    openWatch()
                else
                    QBCore.Functions.Notify('Je hebt geen Fitbit', 'error')
                end
            end, "fitbit")
        end

        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(1000)
        
        if QBCore ~= nil then
            QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                if result then
                    local PlayerData = QBCore.Functions.GetPlayerData()
                    if PlayerData.metadata["fitbit"].food ~= nil then
                        if PlayerData.metadata["hunger"] < PlayerData.metadata["fitbit"].food then
                            TriggerEvent("chatMessage", "FITBIT ", "warning", "Je voedsel is "..PlayerData.metadata["hunger"].."%")
                            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                        end
                    end
        
                    if PlayerData.metadata["fitbit"].thirst ~= nil then
                        if PlayerData.metadata["thirst"] < PlayerData.metadata["fitbit"].thirst  then
                            TriggerEvent("chatMessage", "FITBIT ", "warning", "Je hydratatie is "..PlayerData.metadata["thirst"].."%")
                            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                        end
                    end
                end
            end, "fitbit")
        end

        Citizen.Wait(3 * 60 * 1000)
    end
end)