QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local QBPhone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}

function GetOnlineStatus(number)
    local Target = QBCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

QBCore.Functions.CreateCallback('qb-phone_new:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PhoneData = {
        Applications = {},
        PlayerContacts = {},
        MentionedTweets = {},
        Chats = {},
        Hashtags = {},
        Invoices = {},
    }

    QBCore.Functions.ExecuteSql("SELECT * FROM player_contacts WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        local Contacts = {}
        if result[1] ~= nil then
            for k, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end
            
            PhoneData.PlayerContacts = result
        end        
    end)

    QBCore.Functions.ExecuteSql("SELECT * FROM phone_invoices WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Ply = QBCore.Functions.GetPlayerByCitizenId(v.sender)
                if Ply ~= nil then
                    v.number = Ply.PlayerData.charinfo.phone
                else
                    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            PhoneData.Invoices = invoices
        end
    end)

    QBCore.Functions.ExecuteSql("SELECT * FROM phone_messages WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(messages)
        if messages ~= nil and next(messages) ~= nil then 
            PhoneData.Chats = messages
        end        
    end)

    if AppAlerts[Player.PlayerData.citizenid] ~= nil then 
        PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
    end

    if MentionedTweets[Player.PlayerData.citizenid] ~= nil then 
        PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
    end

    if Hashtags ~= nil and next(Hashtags) ~= nil then
        PhoneData.Hashtags = Hashtags
    end
    
    cb(PhoneData)
end)

RegisterServerEvent('qb-phone_new:server:MentionedPlayer')
AddEventHandler('qb-phone_new:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            print(firstName)
            print(lastName)
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                QBPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                QBPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('qb-phone_new:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..firstName.."%' AND `charinfo` LIKE '%"..lastName.."%'", function(result)
                    if result[1] ~= nil then
                        local MentionedTarget = result[1].citizenid
                        QBPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                        QBPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                        Wait(200)
                        print(AppAlerts[MentionedTarget]["twitter"])
                    end
                end)
            end
        end
	end
end)

RegisterServerEvent('qb-phone_new:server:UpdateHashtags')
AddEventHandler('qb-phone_new:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('qb-phone_new:client:UpdateHashtags', -1, Handle, messageData)
end)

QBPhone.AddMentionedTweet = function(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then MentionedTweets[citizenid] = {} end
    table.insert(MentionedTweets[citizenid], TweetData)
end

QBPhone.SetPhoneAlerts = function(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

RegisterServerEvent('qb-phone:server:SetPhoneAlerts')
AddEventHandler('qb-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = QBCore.Functions.GetPlayer(src).citizenid
    QBPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterServerEvent('qb-phone_new:server:UpdateTweets')
AddEventHandler('qb-phone_new:server:UpdateTweets', function(NewTweets, TweetData)
    Tweets = NewTweets
    local TwtData = TweetData
    local src = source
    TriggerClientEvent('qb-phone_new:client:UpdateTweets', -1, src, Tweets, TwtData)
end)

RegisterServerEvent('qb-phone_new:server:TransferMoney')
AddEventHandler('qb-phone_new:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        if result[1] ~= nil then
            local recieverSteam = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

            if recieverSteam then
                local PhoneItem = recieverSteam.Functions.GetItemByName("phone")
                recieverSteam.Functions.AddMoney('bank', amount)
                sender.Functions.RemoveMoney('bank', amount)

                if PhoneItem ~= nil then
                    TriggerClientEvent('qb-phone_new:server:TransferMoney', recieverSteam.PlayerData.source, amount)
                end
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = round((moneyInfo.bank + amount))
                QBCore.Functions.ExecuteSql("UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                sender.Functions.RemoveMoney('bank', amount)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Dit rekeningnummer bestaat niet!", "error")
        end
    end)
end)

RegisterServerEvent('qb-phone_new:server:EditContact')
AddEventHandler('qb-phone_new:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("UPDATE `player_contacts` SET `name` = '"..newName.."', `number` = '"..newNumber.."', `iban` = '"..newIban.."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `name` = '"..oldName.."' AND `number` = '"..oldNumber.."'")
end)

RegisterServerEvent('qb-phone_new:server:AddNewContact')
AddEventHandler('qb-phone_new:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("INSERT INTO `player_contacts` (`citizenid`, `name`, `number`, `iban`) VALUES ('"..Player.PlayerData.citizenid.."', '"..tostring(name).."', '"..tostring(number).."', '"..tostring(iban).."')")
end)

RegisterServerEvent('qb-phone_new:server:UpdateMessages')
AddEventHandler('qb-phone_new:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..ChatNumber.."%'", function(Player)
        if Player[1] ~= nil then
            local TargetData = QBCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)

            if TargetData ~= nil then
                if New then
                    -- Insert for target
                    QBCore.Functions.ExecuteSql("INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..TargetData.PlayerData.citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                    
                    -- Insert for sender
                    QBCore.Functions.ExecuteSql("INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..TargetData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                
                    -- Send notification & Update messages for target
                    TriggerClientEvent('qb-phone_new:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
                else
                    -- Update for target
                    QBCore.Functions.ExecuteSql("UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..TargetData.PlayerData.citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                            
                    -- Update for sender
                    QBCore.Functions.ExecuteSql("UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..TargetData.PlayerData.charinfo.phone.."'")
                
                    -- Send notification & Update messages for target
                    TriggerClientEvent('qb-phone_new:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
                end
            else
                if New then
                    -- Insert for target
                    QBCore.Functions.ExecuteSql("INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..Player[1].citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                    
                    -- Insert for sender
                    Player[1].charinfo = json.decode(Player[1].charinfo)
                    QBCore.Functions.ExecuteSql("INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..Player[1].charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                else
                    -- Update for target
                    QBCore.Functions.ExecuteSql("UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..Player[1].citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                            
                    -- Update for sender
                    Player[1].charinfo = json.decode(Player[1].charinfo)
                    QBCore.Functions.ExecuteSql("UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..Player[1].charinfo.phone.."'")
                end
            end
        end
    end)
end)