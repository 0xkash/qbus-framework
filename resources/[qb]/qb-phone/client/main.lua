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

local playerContacts = {}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60 * 1000 * 3)
        if isLoggedIn then
            QBCore.Functions.TriggerCallback('qb-phone:server:getUserContacts', function(result)
                playerContacts = result
            end)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    Wait(500)
    setPhoneMeta()
    QBCore.Functions.TriggerCallback('qb-phone:server:getUserContacts', function(result)
        playerContacts = result
    end)
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
        pData = QBCore.Functions.GetPlayerData(),
    })
    
    TriggerServerEvent('qb-phone:server:getContacts')
end

RegisterNUICallback('setupContacts', function()
    setupContacts()
end)

function setupContacts()
    SendNUIMessage({
        task = "setUserContacts",
        pContacts = playerContacts,
        pData = QBCore.Functions.GetPlayerData(),
    })

    print(json.encode(playerContacts))
end

RegisterNUICallback('getBankData', function()
    SendNUIMessage({
        task = "setupBankData",
        pData = QBCore.Functions.GetPlayerData(),
    })
end)

RegisterNUICallback('getVehicles', function()
    QBCore.Functions.TriggerCallback('qb-phone:server:GetAllUserVehicles', function(vehicles)
        local myVehicles = {}

        for k, v in pairs(vehicles) do
            local garage
            local state = "Binnen"
            if vehicles[k].garage ~= nil then garage = Config.Garages[vehicles[k].garage].label else garage = "Depot" end
            if vehicles[k].state == 0 then state = "Uit" elseif vehicles[k].state == 2 then state = "In Beslag" end
            table.insert(myVehicles, {name = QBCore.Shared.Vehicles[vehicles[k].vehicle]["name"], plate = vehicles[k].plate, garage = garage, state = state, engine = vehicles[k].engine, body = vehicles[k].body, fuel = vehicles[k].fuel, image = QBCore.Shared.Vehicles[vehicles[k].vehicle]["image"]})
        end

        SendNUIMessage({
            task = "getVehicles",
            vehicles = myVehicles,
        })
    end)
end)

RegisterNUICallback('addToContact', function(data)
    local contactName = data.contactName
    local contactNum = data.contactNum

    table.insert(playerContacts, {
        name = contactName,
        number = contactNum,
        status = "unknown",
    })
    setupContacts()

    TriggerServerEvent('qb-phone:server:addContact', contactName, contactNum)
    QBCore.Functions.Notify(contactNum..' is toegevoegd aan je contacten!', 'success', 3500)
end)

RegisterNUICallback('editContact', function(data)
    local oldContactName = data.oldContactName
    local oldContactNum = data.oldContactNum
    local newContactName = data.newContactName
    local newContactNum = data.newContactNum

    print(json.encode(data))

    for k, v in pairs(playerContacts) do
        if playerContacts[k].name == oldContactName and playerContacts[k].number == oldContactNum then
            playerContacts[k].name = newContactName
            playerContacts[k].number = newContactNum
        end
    end
    setupContacts()

    TriggerServerEvent('qb-phone:server:editContact', oldContactName, oldContactNum, newContactName, newContactNum)
    QBCore.Functions.Notify(oldContactNum..' is aangepast!', 'success', 3500)
end)

RegisterNUICallback('transferMoney', function(data)
    TriggerServerEvent('qb-phone:server:transferBank', data.amount, data.iban)
end)

RegisterNUICallback('getUserMails', function()
    QBCore.Functions.TriggerCallback('qb-phone:server:GetUserMails', function(mails)
        SendNUIMessage({
            task = "setupMail",
            mails = mails
        })
    end)
end)

RegisterNUICallback('setEmailRead', function(data)
    TriggerServerEvent('qb-phone:server:setEmailRead', data.mailId)
    SetTimeout(500, function()
        QBCore.Functions.TriggerCallback('qb-phone:server:GetUserMails', function(mails)
            SendNUIMessage({
                task = "setupMail",
                mails = mails
            })
        end)
    end)
end)

RegisterNetEvent('qb-phone:client:newMailNotify')
AddEventHandler('qb-phone:client:newMailNotify', function()
    SendNUIMessage({
        task = "newMailNotify",
    })
end)

RegisterNUICallback('removeMail', function(data)
    TriggerServerEvent('qb-phone:server:removeMail', data.mailId)
end)

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

RegisterNUICallback('clickMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)

    TriggerServerEvent('qb-phone:server:clearButtonData', data.mailId)
end)