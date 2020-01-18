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

phoneProp = 0
local phoneModel = `prop_npc_phone_02`

local PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
}

RegisterNetEvent('qb-phone_new:client:AddRecentCall')
AddEventHandler('qb-phone_new:client:AddRecentCall', function(CallData, type, time)
    table.insert(PhoneData.RecentCalls, {
        name = CallData.TargetData.name,
        time = time,
        type = type,
        number = CallData.TargetData.number
    })
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    cb('ok')
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    PhoneData.MetaData.background = background
    TriggerServerEvent('qb-phone_new:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenPhone) then
            OpenPhone()
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
            })
            Citizen.Wait(29000)
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function() 
    Citizen.Wait(1000)
    isLoggedIn = true
    print('2')
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetPhoneData', function(pData)
        print('1')
        SendNUIMessage({ 
            action = "LoadPhoneApplications", 
            applications = Config.PhoneApplications 
        })
        PhoneData.PlayerData = QBCore.Functions.GetPlayerData()
        PhoneData.MetaData = PhoneData.PlayerData.metadata["phone"]
        
        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do 
                Config.PhoneApplications[k].Alerts = v 
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then 
            PhoneData.MentionedTweets = pData.MentionedTweets 
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        else
            PhoneData.Chats = {}
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        Citizen.Wait(300)
    
        SendNUIMessage({ 
            action = "LoadPhoneData", 
            PhoneData = PhoneData, 
            PlayerData = PhoneData.PlayerData, 
        })
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        if isLoggedIn then
            QBCore.Functions.TriggerCallback('qb-phone_new:server:GetPhoneData', function(pData)   
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
                    PhoneData.Contacts = pData.PlayerContacts
                end

                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    Citizen.Wait(100)
    SendNUIMessage({ action = "LoadPhoneApplications", applications = Config.PhoneApplications })
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetUserContacts', function(PlayerContacts) 
        PhoneData.Contacts = PlayerContacts
    end)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetAppAlerts', function(Applications) 
        if Applications ~= nil then
            for k, v in pairs(Applications) do
                Config.PhoneApplications[k].Alerts = v
            end
        end
    end)
    Citizen.Wait(500)
    PhoneData.PlayerData = QBCore.Functions.GetPlayerData()
    SendNUIMessage({ 
        action = "LoadPhoneData", 
        PhoneData = PhoneData,
        PlayerData = PhoneData.PlayerData,
    })
end)

function OpenPhone()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        Tweets = PhoneData.Tweets,
        AppData = Config.PhoneApplications,
        CallData = PhoneData.CallData,
    })
    -- SetNuiFocusKeepInput(true)
    PhoneData.isOpen = true
    PhonePlayIn()
end

RegisterNUICallback('Close', function()
    PhonePlayOut()
    SetNuiFocus(false, false)
    -- SetNuiFocusKeepInput(false)
    PhoneData.isOpen = false
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('qb-phone_new:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil and next(PhoneData.Chats[data.phone]) ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType

    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)

    if PhoneData.Chats[ChatNumber] ~= nil then
        if PhoneData.Chats[ChatNumber].messages[ChatDate] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[ChatNumber].messages[ChatDate], {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[ChatNumber].messages[ChatDate], {
                    message = "Gedeelde Locatie",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('qb-phone_new:server:UpdateMessages', PhoneData.Chats[ChatNumber].messages, ChatNumber, false)
        else
            PhoneData.Chats[ChatNumber].messages[ChatDate] = {}
            if ChatType == "message" then
                table.insert(PhoneData.Chats[ChatNumber].messages[ChatDate], {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[ChatNumber].messages[ChatDate], {
                    message = "Gedeelde Locatie",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('qb-phone_new:server:UpdateMessages', PhoneData.Chats[ChatNumber].messages, ChatNumber, true)
        end
    else
        PhoneData.Chats[ChatNumber] = {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        }
        PhoneData.Chats[ChatNumber].messages[ChatDate] = {}
        if ChatType == "message" then
            table.insert(PhoneData.Chats[ChatNumber].messages[ChatDate], {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {},
            })
        elseif ChatType == "location" then
            table.insert(PhoneData.Chats[ChatNumber].messages[ChatDate], {
                message = "Gedeelde Locatie",
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            })
        end
        TriggerServerEvent('qb-phone_new:server:UpdateMessages', PhoneData.Chats[ChatNumber].messages, ChatNumber, true)
    end
    SendNUIMessage({
        action = "UpdateChat",
        chatData = PhoneData.Chats[ChatNumber],
        chatNumber = ChatNumber,
    })
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Whatsapp",
            text = "Locatie is ingesteld!",
            icon = "fab fa-whatsapp",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)

RegisterNetEvent('qb-phone_new:client:UpdateMessages')
AddEventHandler('qb-phone_new:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local Sender = IsNumberInContacts(SenderNumber)

    if New then
        PhoneData.Chats[SenderNumber] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Nieuw bericht van "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Waarom stuur je berichtjes naar jezelf you sadfuck?",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            Wait(100)
            SendNUIMessage({
                action = "UpdateChat",
                chatData = PhoneData.Chats[SenderNumber],
                chatNumber = SenderNumber,
                Chats = PhoneData.Chats,
            })
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Whatsapp", 
                    content = "Je hebt een nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fab fa-whatsapp", 
                    timeout = 3500, 
                    color = "#25D366",
                },
            })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[SenderNumber].messages = ChatMessages

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Nieuw bericht van "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Waarom stuur je berichtjes naar jezelf you sadfuck?",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end
            
            Wait(100)
            SendNUIMessage({
                action = "UpdateChat",
                chatData = PhoneData.Chats[SenderNumber],
                chatNumber = SenderNumber,
                Chats = PhoneData.Chats,
            })
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Whatsapp", 
                    content = "Je hebt een nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fab fa-whatsapp", 
                    timeout = 3500, 
                    color = "#25D366",
                },
            })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end


    if PhoneData.Chats[SenderNumber].Unread ~= nil then
        PhoneData.Chats[SenderNumber].Unread = PhoneData.Chats[SenderNumber].Unread + 1
    else
        PhoneData.Chats[SenderNumber].Unread = 1
    end

    SendNUIMessage({
        action = "RefreshWhatsappAlerts",
        Chats = PhoneData.Chats,
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number

    if PhoneData.Chats[chat].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[chat].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "whatsapp", newAlerts)

        PhoneData.Chats[chat].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    QBCore.Functions.TriggerCallback('qb-phone_new:server:PayInvoice', function(CanPay, Invoices)
        if CanPay then PhoneData.Invoices = Invoices end
        cb(CanPay)
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    QBCore.Functions.TriggerCallback('qb-phone_new:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('qb-phone_new:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

local function escape_str(s)
	local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
	local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
	for i, c in ipairs(in_char) do
	  s = s:gsub(c, '\\' .. out_char[i])
	end
	return s
end

function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('qb-phone_new:client:UpdateHashtags')
AddEventHandler('qb-phone_new:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

RegisterNUICallback('PostNewTweet', function(data, cb)
    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId()
    }
    table.insert(PhoneData.Tweets, TweetMessage)
    Citizen.Wait(100)
    cb(PhoneData.Tweets)

    TriggerServerEvent('qb-phone_new:server:UpdateTweets', PhoneData.Tweets, TweetMessage)

    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    for i = 2, #Hashtag, 1 do
        local Handle = Hashtag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            print(Handle)
            TriggerServerEvent('qb-phone_new:server:UpdateHashtags', Handle, TweetMessage)
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                -- if Fullname[1] ~= PhoneData.PlayerData.charinfo.firstname and Fullname[2] ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('qb-phone_new:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                -- end
            end
        end
    end
end)

RegisterNetEvent('qb-phone_new:server:TransferMoney')
AddEventHandler('qb-phone_new:server:TransferMoney', function(amount, senderIban)
    if PhoneData.isOpen then
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "QBank", text = "Er is &euro;"..amount.." bijgeschreven!", icon = "fas fa-university", color = "#8c7ae6", }, })
        SendNUIMessage({ action = "UpdateBank", NewBalance = PhoneData.PlayerData.money.bank })
    else
        SendNUIMessage({ action = "Notification", NotifyData = { title = "QBank", content = "Er is &euro;"..amount.." bijgeschreven!", icon = "fas fa-university", timeout = 2500, color = nil, }, })
    end
end)

RegisterNetEvent('qb-phone_new:client:UpdateTweets')
AddEventHandler('qb-phone_new:client:UpdateTweets', function(src, Tweets, NewTweetData)
    PhoneData.Tweets = Tweets
    local MyPlayerId = PhoneData.PlayerData.source

    if src ~= MyPlayerId then
        if not PhoneData.isOpen then
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Nieuwe Tweet (<strong>@"..NewTweetData.firstName.." "..NewTweetData.lastName..")</strong>", 
                    content = NewTweetData.message, 
                    icon = "fab fa-twitter", 
                    timeout = 3500, 
                    color = nil,
                },
            })
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Nieuwe Tweet (<strong>@"..NewTweetData.firstName.." "..NewTweetData.lastName..")</strong>", 
                    text = NewTweetData.message, 
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                },
            })
        end
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Twitter", 
                text = "De tweet is geplaatst!", 
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('qb-phone_new:client:GetMentioned')
AddEventHandler('qb-phone_new:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen then
        SendNUIMessage({ action = "Notification", NotifyData = { title = "Je bent gementioned in een Tweet!", content = TweetMessage.message, icon = "fab fa-twitter", timeout = 3500, color = nil, }, })
    else
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Je bent gementioned in een Tweet!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = escape_str(TweetMessage.message), time = TweetMessage.time}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('TransferMoney', function(data, cb)
    data.amount = tonumber(data.amount)
    if tonumber(PhoneData.PlayerData.money.bank) >= data.amount then
        TriggerServerEvent('qb-phone_new:server:TransferMoney', data.iban, data.amount)
        cb(true, (tonumber(PhoneData.PlayerData.money.bank) - data.amount))
    else
        cb(false, nil)
    end
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    cb(PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetCallState', function(CanCall, IsOnline)
        local status = { 
            cc = CanCall, 
            io = IsOnline,
            ic = PhoneData.CallData.InCall,
        }
        cb(status)
        -- if CanCall and not status.ic and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData)
        -- end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    TriggerServerEvent('qb-phone_new:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId)
    TriggerServerEvent('qb-phone_new:server:SetCallState', true)
    
    PhonePlayAnim('call')

    Citizen.CreateThread(function()
        while PhoneData.CallData.InCall do 
            if PhoneData.CallData.InCall then 
                if not (IsEntityPlayingAnim(GetPlayerPed(-1), "cellphone@", "cellphone_call_listen_base", 3)) then 
                    PhonePlayAnim('call', false, true)
                    if phoneProp == 0 then
                        newPhoneProp()
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end)

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                Citizen.Wait(Config.RepeatTimeout)
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                else
                    if PhoneData.isOpen then
                        PhoneCallToText()
                    else
                        PhonePlayOut()
                    end
                    break
                end
            else
                if PhoneData.isOpen then
                    PhoneCallToText()
                else
                    PhonePlayOut()
                end
                TriggerServerEvent('qb-phone_new:server:AddRecentCall', "outgoing", PhoneData.CallData)
                CancelCall()
                break
            end
        else
            if PhoneData.isOpen then
                PhoneCallToText()
            else
                PhonePlayOut()
            end
            TriggerServerEvent('qb-phone_new:server:AddRecentCall', "outgoing", PhoneData.CallData)
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('qb-phone_new:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if PhoneData.isOpen then
        PhoneCallToText()
    end

    TriggerServerEvent('qb-phone_new:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "Notification", 
            NotifyData = { 
                title = "Telefoon",
                content = "De oproep is beëindigd", 
                icon = "fas fa-phone", 
                timeout = 3500, 
                color = "#e84118",
            }, 
        })            
    else
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "De oproep is beëindigd", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('qb-phone_new:client:CancelCall')
AddEventHandler('qb-phone_new:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if PhoneData.isOpen then
        PhoneCallToText()
    end

    TriggerServerEvent('qb-phone_new:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "Notification", 
            NotifyData = { 
                title = "Telefoon",
                content = "De oproep is beëindigd", 
                icon = "fas fa-phone", 
                timeout = 3500, 
                color = "#e84118",
            }, 
        })            
    else
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "De oproep is beëindigd", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('qb-phone_new:client:GetCalled')
AddEventHandler('qb-phone_new:client:GetCalled', function(CallerNumber, CallId)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
    }

    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('qb-phone_new:server:SetCallState', true)

    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                Citizen.Wait(Config.RepeatTimeout)
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                    
                    if not PhoneData.CallData.isOpen then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                        })
                    end
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                    })
                    break
                end
            else
                TriggerServerEvent('qb-phone_new:server:AddRecentCall', "missed", PhoneData.CallData)
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                })
                CancelOutgoingCall()
                break
            end
        else
            break
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    TriggerServerEvent('qb-phone_new:server:AddRecentCall', "outgoing", PhoneData.CallData)
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    TriggerServerEvent('qb-phone_new:server:AddRecentCall', "outgoing", PhoneData.CallData)
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    TriggerServerEvent('qb-phone_new:server:AddRecentCall', "outgoing", PhoneData.CallData)
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('qb-phone_new:server:SetCallState', true)

        PhonePlayAnim('call')

        Citizen.CreateThread(function()
            while true do
                print(PhoneData.CallData.AnsweredCall)
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('qb-phone_new:server:AnswerCall', PhoneData.CallData)

        exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Telefoon')
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "Je hebt geen inkomende oproep...", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end

RegisterNetEvent('qb-phone_new:client:AnswerCall')
AddEventHandler('qb-phone_new:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('qb-phone_new:server:SetCallState', true)

        PhonePlayAnim('call')

        Citizen.CreateThread(function()
            while PhoneData.CallData.InCall do 
                if callData.inCall then 
                    if not (IsEntityPlayingAnim(GetPlayerPed(-1), "cellphone@", "cellphone_call_listen_base", 3)) then 
                        PhonePlayAnim('call', false, true)
                        if phoneProp == 0 then
                            newPhoneProp()
                        end
                    end
                end
                Citizen.Wait(1000)
            end
        end)

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Telefoon')
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "Je hebt geen inkomende oproep...", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)