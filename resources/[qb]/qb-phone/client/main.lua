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
local isLoggedIn = true

local callData = {
    number = nil,
    name = nil,
    callId = 0,
    inCall = false,
    incomingCall = false,
    outgoingCall = false
}

local defaultPhoneMeta = {
    ["settings"] = {
        notifications = true,
        background = "bg-1",
    }
}

local inPhone = false
local allowNotifys = true

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

Citizen.CreateThread(function()
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

RegisterNUICallback('getTweets', function()
    QBCore.Functions.TriggerCallback('qb-phone:server:getPhoneTweets', function(tweets)
        SendNUIMessage({
            task = "setupTweets",
            tweets = tweets
        })
    end)
end)

RegisterNUICallback('getAds', function()
    QBCore.Functions.TriggerCallback('qb-phone:server:getPhoneAds', function(ads)
        SendNUIMessage({
            task = "setupAds",
            ads = ads
        })
    end)
end)

RegisterNUICallback('postTweet', function(data)
    TriggerServerEvent('qb-phone:server:postTweet', data.message)
end)

RegisterNUICallback('postAdvert', function(data)
    TriggerServerEvent('qb-phone:server:postAdvert', data.message)
end)

RegisterNetEvent('qb-phone:client:newTweet')
AddEventHandler('qb-phone:client:newTweet', function(sender)
    if inPhone then
        QBCore.Functions.TriggerCallback('qb-phone:server:getPhoneTweets', function(tweets)
            SendNUIMessage({
                task = "newTweet",
                tweets = tweets,
                sender = sender
            })
        end)
    else
        SendNUIMessage({
            task = "newTweetNotify",
            sender = sender
        })
    end
end)

RegisterNetEvent('qb-phone:client:newAd')
AddEventHandler('qb-phone:client:newAd', function(sender)
    if inPhone then
        QBCore.Functions.TriggerCallback('qb-phone:server:getPhoneAds', function(ads)
            SendNUIMessage({
                task = "newAd",
                ads = ads,
                sender = sender
            })
        end)
    else
        SendNUIMessage({
            task = "newAdNotify",
            sender = sender
        })
    end
end)

--- CODE

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

        if callData.inCall or callData.outgoingCall or callData.incomingCall then
            SendNUIMessage({
                task = "callScreen",
                callData = callData
            })
        end

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

------------------------------
---- Call Phone Part YEET ----
------------------------------

RegisterNUICallback('CallContact', function(data)
    local contactData = data.contactData

    local callTime = 0
    
    local pData = QBCore.Functions.GetPlayerData()

    callData.number = contactData.number
    callData.name = contactData.name
    callData.callId = math.random(500, 1000) + math.random(1, 120)
    callData.inCall = false
    callData.incomingCall = false
    callData.outgoingCall = true

    QBCore.Functions.Notify('Oproep gestart met '..callData.name, 'primary', 2500)

    PhonePlayAnim('call')

    Citizen.CreateThread(function()
        for i = 1, 10, 1 do
            if callData.outgoingCall then
                Citizen.Wait(3000)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                QBCore.Functions.Notify('Oproep is bezig, /ophangen om gesprek te stoppen', 'primary', 2000)
                callTime = i
                if callTime == 10 then
                    Citizen.Wait(3000)
                    QBCore.Functions.Notify('Er word niet opgenomen..', 'error', 3500)
                    callData.number = nil
                    callData.name = nil
                    callData.callId = 0
                    callData.inCall = false
                    callData.incomingCall = false
                    callData.outgoingCall = false

                    PhonePlayOut()
                    break
                end
            else
                break
            end
        end
    end)

    TriggerServerEvent('qb-phone:server:CallContact', callData, pData.charinfo.phone)
end)

RegisterNetEvent('qb-phone:client:CallNumber')
AddEventHandler('qb-phone:client:CallNumber', function(number)
    if not callData.outgoingCall or not callData.inComingCall or not callData.inCall then
        local callTime = 0
        
        local pData = QBCore.Functions.GetPlayerData()

        callData.number = number
        callData.name = nil
        callData.callId = math.random(500, 1000) + math.random(1, 120)
        callData.inCall = false
        callData.incomingCall = false
        callData.outgoingCall = true

        QBCore.Functions.Notify('Oproep gestart met '..callData.number, 'primary', 2500)

        PhonePlayAnim('call')

        if inPhone then
            SendNUIMessage({
                task = "callScreen",
                callData = callData
            })
        end

        Citizen.CreateThread(function()
            for i = 1, 10, 1 do
                if callData.outgoingCall then
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                    QBCore.Functions.Notify('Oproep is bezig, /ophangen om gesprek te stoppen', 'primary', 2000)
                    callTime = i
                    if callTime == 5 then
                        Citizen.Wait(3000)
                        QBCore.Functions.Notify('Er word niet opgenomen..', 'error', 3500)
                        callData.number = nil
                        callData.name = nil
                        callData.callId = 0
                        callData.inCall = false
                        callData.incomingCall = false
                        callData.outgoingCall = false

                        PhonePlayOut()
                    end
                else
                    break
                end
                Citizen.Wait(3000)
            end
        end)

        TriggerServerEvent('qb-phone:server:CallContact', callData, pData.charinfo.phone)
    end
end)

RegisterNetEvent('qb-phone:client:IncomingCall')
AddEventHandler('qb-phone:client:IncomingCall', function(cData, caller)
    if not callData.inCall or not callData.incomingCall then
        callData.number = caller
        callData.callId = cData.callId
        callData.incomingCall = true

        if inPhone then
            SendNUIMessage({
                task = "callScreen",
                callData = callData
            })
        end
        
        inComingCall()
    end
end)

function inComingCall()
    QBCore.Functions.TriggerCallback('qb-phone:server:getContactName', function(name)
        callData.name = name

        local number = callData.number
        if callData.name ~= nil then number = callData.name end
        Citizen.CreateThread(function()
            for i = 1, 10, 1 do
                if callData.incomingCall then
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                    QBCore.Functions.Notify('Inkomend gesprek van '..number..', /opnemen of /ophangen', 'primary', 2000)
                else
                    break
                end
                Citizen.Wait(3000)
            end
        end)
    end, callData.number)
end

RegisterNUICallback('AnswerCall', function()
    TriggerEvent('qb-phone:client:AnswerCall')
end)

RegisterNUICallback('DenyCall', function()
    TriggerEvent('qb-phone:client:HangupCall')
end)

RegisterNetEvent('qb-phone:client:AnswerCall')
AddEventHandler('qb-phone:client:AnswerCall', function()
    if callData.incomingCall then
        if not callData.inCall then
            callData.inCall = true
            callData.incomingCall = false

            exports.tokovoip_script:addPlayerToRadio(callData.callId, 'Telefoon')
            TriggerServerEvent('qb-phone:server:AnswerCall', callData)

            if inPhone then
                SendNUIMessage({
                    task = "callScreen",
                    callData = callData
                })
            end
        else
            QBCore.Functions.Notify('Je bent al in gesprek..', 'error')
        end
    else
        QBCore.Functions.Notify('Je hebt geen inkomend oproep..', 'error')
    end
end)

RegisterNetEvent('qb-phone:client:AnswerCallOther')
AddEventHandler('qb-phone:client:AnswerCallOther', function()
    callData.inCall = true
    callData.outgoingCall = false

    if inPhone then
        SendNUIMessage({
            task = "callScreen",
            callData = callData
        })
    end

    exports.tokovoip_script:addPlayerToRadio(callData.callId, 'Telefoon')
end)

RegisterNetEvent('qb-phone:client:HangupCallOther')
AddEventHandler('qb-phone:client:HangupCallOther', function(cData)
    if cData.callId == callData.callId then
        exports.tokovoip_script:removePlayerFromRadio(callData.callId)
        QBCore.Functions.Notify('Het gesprek is beëindigd')

        callData.number = nil
        callData.name = nil
        callData.callId = 0
        callData.inCall = false
        callData.incomingCall = false
        callData.outgoingCall = false

        if inPhone then
            SendNUIMessage({
                task = "callScreen",
                callData = callData
            })
        end

        PhonePlayOut()
    end
end)

RegisterNetEvent('qb-phone:client:HangupCall')
AddEventHandler('qb-phone:client:HangupCall', function()
    if callData.inCall then
        exports.tokovoip_script:removePlayerFromRadio(callData.callId)

        TriggerServerEvent('qb-phone:server:HangupCall', callData)
        QBCore.Functions.Notify('Het gesprek is beëindigd')

        callData.number = nil
        callData.name = nil
        callData.callId = 0
        callData.inCall = false
        callData.incomingCall = false
        callData.outgoingCall = false

        PhonePlayOut()
    elseif callData.outgoingCall then

        TriggerServerEvent('qb-phone:server:HangupCall', callData)
        QBCore.Functions.Notify('Het gesprek is beëindigd')

        callData.number = nil
        callData.name = nil
        callData.callId = 0
        callData.inCall = false
        callData.incomingCall = false
        callData.outgoingCall = false

        PhonePlayOut()
    elseif callData.incomingCall then
        TriggerServerEvent('qb-phone:server:HangupCall', callData)
        QBCore.Functions.Notify('Het gesprek is beëindigd')

        callData.number = nil
        callData.name = nil
        callData.callId = 0
        callData.inCall = false
        callData.incomingCall = false
        callData.outgoingCall = false

        PhonePlayOut()
    else
        QBCore.Functions.Notify('Je zit niet in een gesprek..', 'error')
    end

    if inPhone then
        SendNUIMessage({
            task = "callScreen",
            callData = callData
        })
    end
end)