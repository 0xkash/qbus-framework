Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

QBCore = nil


local phoneMeta = {}
local isLoggedIn = false

local defaultPhoneMeta = {
    ["settings"] = {
        notifications = true,
        background = "bg-1",
    }
}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    Wait(1000)
    setPhoneMeta()
end)

function setPhoneMeta()
    phoneMeta = QBCore.Functions.GetPlayerData().metadata["phone"]

    if next(phoneMeta) == nil then
        phoneMeta = defaultPhoneMeta
        TriggerServerEvent('qb-phone:server:setPhoneMeta', defaultPhoneMeta)
    end

    SendNUIMessage({
        task = "setPhoneMeta",
        pMeta = phoneMeta,
        pNum = QBCore.Functions.GetPlayerData().charinfo.phone
    })
    print(QBCore.Functions.GetPlayerData().charinfo.phone)
end

--- CODE

local inPhone = false
local allowNotifys = true

function openPhone(bool)
    SetNuiFocus(bool, bool)
    SetCursorLocation(0.87, 0.5)
    inPhone = bool
    if bool then
        SendNUIMessage({
            action = "phone",
            open = bool,
            apps = Config.PhoneApps
        })

        PhonePlayIn()
    else
        PhonePlayOut()
    end
end

Citizen.CreateThread(function()
    while true do

        if IsControlJustPressed(0, Keys["M"]) then
            openPhone(true)
        end

        Citizen.Wait(0)
    end
end)

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end

    if hour <= 9 then
        hour = "0" .. hour
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        if inPhone then
            local currentTime = CalculateTimeToDisplay()

            SendNUIMessage({
                task = "updateTime",
                time = currentTime,
            })
        end
        Citizen.Wait(1000)
    end
end)

RegisterNUICallback('setNotifications', function(data)
    local allow = data.allow
    if allow then
        QBCore.Functions.Notify('Telefoon notificaties zijn ingeschakeld...', 'primary', 3500) 
    else
        QBCore.Functions.Notify('Telefoon notificaties zijn uitgeschakeld...', 'primary', 3500)
    end
    phoneMeta["settings"].notifications = allow
    print(allow)
end)

RegisterNUICallback('closePhone', function()
    openPhone(false)
    inPhone = false
    TriggerServerEvent('qb-phone:server:setPhoneMeta', phoneMeta)
end)

RegisterNUICallback('setPlayersBackground', function(data)
    phoneMeta["settings"].background = data.background
end)

RegisterNUICallback("succesSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("errorSound", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)