QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

local callId = 501

local Adverts = {}

Citizen.CreateThread(function()
    QBCore.Functions.ExecuteSql('DELETE FROM `phone_tweets`')
    print('Tweets have been cleared')
end)

RegisterServerEvent('qb-phone:server:setPhoneMeta')
AddEventHandler('qb-phone:server:setPhoneMeta', function(phoneMeta)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.SetMetaData("phone", phoneMeta)
end)

RegisterServerEvent('qb-phone:server:transferBank')
AddEventHandler('qb-phone:server:transferBank', function(amount, iban)
    local src = source
    local sender = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        local recieverSteam = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

        if recieverSteam then
            recieverSteam.Functions.AddMoney('bank', amount)
            sender.Functions.RemoveMoney('bank', amount)
        else
            local moneyInfo = json.decode(result[1].money)
            moneyInfo.bank = round((moneyInfo.bank + amount))
            QBCore.Functions.ExecuteSql("UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
            sender.Functions.RemoveMoney('bank', amount)
        end
    end)
end)

function round(number)
    return number - (number % 1)
end

QBCore.Functions.CreateCallback('qb-phone:server:getUserContacts', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerContacts = {}

    QBCore.Functions.ExecuteSql("SELECT * FROM `player_contacts` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        for i = 1, (#result), 1 do
            local status = false
            QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..result[i].number.."%'", function(player)
                for i=1, (#player), 1 do
                    local ply = QBCore.Functions.GetPlayerByCitizenId(player[i].citizenid)
                    if ply then
                        status = true
                        print(result[i].number..' is online')
                    end
                end
                table.insert(playerContacts, {
                    name = result[i].name,
                    number = result[i].number,
                    status = status,
                })
            end)
        end
        cb(playerContacts)
    end)
end)

RegisterServerEvent('qb-phone:server:addContact')
AddEventHandler('qb-phone:server:addContact', function(name, number)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("INSERT INTO `player_contacts` (`citizenid`, `name`, `number`) VALUES ('"..Player.PlayerData.citizenid.."', '"..name.."', '"..number.."')")
end)

RegisterServerEvent('qb-phone:server:editContact')
AddEventHandler('qb-phone:server:editContact', function(oName, oNum, nName, nNum)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("UPDATE `player_contacts` SET `name` = '"..nName.."', `number` = '"..nNum.."' WHERE `name` = '"..oName.."' AND `number` = '"..oNum.."'")
end)

QBCore.Functions.CreateCallback("qb-phone:server:GetAllUserVehicles", function(source, cb, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid', {['@citizenid'] = pData.PlayerData.citizenid}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-phone:server:GetUserMails", function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql('SELECT * FROM `player_mails` WHERE `citizenid` = "'..pData.PlayerData.citizenid..'" ORDER BY `date` DESC', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if result[k].button ~= nil then
                    result[k].button = json.decode(result[k].button)
                end
            end
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-phone:server:getPhoneAds", function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    if Adverts ~= nil and next(Adverts) then
        cb(Adverts)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback("qb-phone:server:getPhoneTweets", function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql('SELECT * FROM `phone_tweets` ORDER BY `date` DESC', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('qb-phone:server:setEmailRead')
AddEventHandler('qb-phone:server:setEmailRead', function(mailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    print(mailId)

    QBCore.Functions.ExecuteSql('UPDATE `player_mails` SET `read` = "1" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
end)

RegisterServerEvent('qb-phone:server:clearButtonData')
AddEventHandler('qb-phone:server:clearButtonData', function(mailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql('UPDATE `player_mails` SET `button` = "" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
end)

RegisterServerEvent('qb-phone:server:removeMail')
AddEventHandler('qb-phone:server:removeMail', function(mailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql('DELETE FROM `player_mails` WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
end)

RegisterServerEvent('qb-phone:server:sendNewMail')
AddEventHandler('qb-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    print('snorlex')

    if mailData.button == nil then
        QBCore.Functions.ExecuteSql("INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        TriggerClientEvent('qb-phone:client:newMailNotify', src)
    else
        QBCore.Functions.ExecuteSql("INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        TriggerClientEvent('qb-phone:client:newMailNotify', src)
    end
end)

RegisterServerEvent('qb-phone:server:postTweet')
AddEventHandler('qb-phone:server:postTweet', function(message)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    QBCore.Functions.ExecuteSql("INSERT INTO `phone_tweets` (`citizenid`, `sender`, `message`) VALUES ('"..Player.PlayerData.citizenid.."', '"..Player.PlayerData.charinfo.firstname.." "..string.sub(Player.PlayerData.charinfo.lastname, 1, 1):upper()..".', '"..message.."')")
    TriggerClientEvent('qb-phone:client:newTweet', -1, Player.PlayerData.charinfo.firstname.." "..string.sub(Player.PlayerData.charinfo.lastname, 1, 1):upper()..".")
end)

RegisterServerEvent('qb-phone:server:postAdvert')
AddEventHandler('qb-phone:server:postAdvert', function(message)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Adverts[Player.PlayerData.citizenid] = {
        message = message,
        phone = Player.PlayerData.charinfo.phone,
        name = Player.PlayerData.charinfo.firstname .." "..Player.PlayerData.charinfo.lastname,
    }
    TriggerClientEvent('qb-phone:client:newAd', -1, Player.PlayerData.charinfo.firstname .." "..Player.PlayerData.charinfo.lastname)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

function convertDate(vardate)
    local y,m,d,h,i,s = string.match(vardate, '(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)')
    return string.format('%s/%s/%s %s:%s:%s', d,m,y,h,i,s)
end

QBCore.Functions.CreateCallback('qb-phone:server:getContactName', function(source, cb, number)
    local src = source
    local plyCid = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql('SELECT `name` FROM `player_contacts` WHERE `citizenid` = "'..plyCid.PlayerData.citizenid..'" AND `number` = "'..number..'"', function(result)
        if result[1] ~= nil then
            cb(result[1].name)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-phone:server:getContactStatus', function(source, cb, number)
    local src = source
    local plyCid = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql('SELECT * FROM `players` WHERE `charinfo` LIKE "%'..number..'%"', function(result)
        local target = result[1]

        if target ~= nil then
            local trgt = QBCore.Functions.GetPlayerByCitizenId(target.citizenid)
            if trgt ~= nil then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('qb-phone:server:createChat')
AddEventHandler('qb-phone:server:createChat', function(messages)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..ply.PlayerData.citizenid.."', '"..messages.number.."', '"..json.encode(messages.messages).."')")

    if messages.number ~= ply.PlayerData.charinfo.phone then
        QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..messages.number.."%'", function(target)
            local target = QBCore.Functions.GetPlayerByCitizenId(target[1].citizenid)

            TriggerClientEvent('qb-phone:client:createChatOther', target.PlayerData.source, messages, ply.PlayerData.charinfo.phone)
        end)
    end
end)


RegisterServerEvent('qb-phone:server:giveNumber')
AddEventHandler('qb-phone:server:giveNumber', function(targetId, playerData)
    TriggerClientEvent('qb-phone:server:newContactNotify', targetId, playerData.charinfo.phone)
end)

RegisterServerEvent('qb-phone:server:createChatOther')
AddEventHandler('qb-phone:server:createChatOther', function(chatData, senderPhone)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..ply.PlayerData.citizenid.."', '"..senderPhone.."', '"..json.encode(chatData.messages).."')")
    
    QBCore.Functions.ExecuteSql("SELECT * FROM `player_contacts` WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..senderPhone.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('qb-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..result[1].name, result[1].name)
        else
            TriggerClientEvent('qb-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..senderPhone, senderPhone)
        end
    end)
end)

RegisterServerEvent('qb-phone:server:sendMessage')
AddEventHandler('qb-phone:server:sendMessage', function(chatData)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("UPDATE `phone_messages` SET `messages` = '"..json.encode(chatData.messages).."' WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..chatData.number.."'")
    
    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..chatData.number.."%'", function(target)
        local target = QBCore.Functions.GetPlayerByCitizenId(target[1].citizenid)

        TriggerClientEvent('qb-phone:client:recieveMessage', target.PlayerData.source, chatData, ply.PlayerData.charinfo.phone)
    end)
end)

RegisterServerEvent('qb-phone:server:recieveMessage')
AddEventHandler('qb-phone:server:recieveMessage', function(chatData, senderPhone)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("UPDATE `phone_messages` SET `messages` = '"..json.encode(chatData.messages).."' WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..senderPhone.."'")

    QBCore.Functions.ExecuteSql("SELECT * FROM `player_contacts` WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..senderPhone.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('qb-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..result[1].name, result[1].name)
        else
            TriggerClientEvent('qb-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..senderPhone, senderPhone)
        end
    end)
end)

RegisterServerEvent('qb-phone:server:removeContact')
AddEventHandler('qb-phone:server:removeContact', function(name, number)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("DELETE FROM `player_contacts` WHERE `name` = '"..name.."' AND `number` = '"..number.."'")
end)

QBCore.Functions.CreateCallback('qb-phone:server:getPlayerMessages', function(source, cb)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `phone_messages` WHERE `citizenid` = '"..ply.PlayerData.citizenid.."'", function(result)
        for k, v in pairs(result) do
            result[k].messages = json.decode(result[k].messages)
        end
        cb(result)
    end)
end)

RegisterServerEvent('qb-phone:server:CallContact')
AddEventHandler('qb-phone:server:CallContact', function(callData, caller)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..callData.number.."%'", function(result)
        if result[1] ~= nil then
            local target = result[1]
            local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(target.citizenid)

            if targetPlayer ~= nil then
                TriggerClientEvent('qb-phone:client:IncomingCall', targetPlayer.PlayerData.source, callData, caller)
            end
        end
    end)
end)

QBCore.Commands.Add("opnemen", "Inkomend oproep beantwoorden", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent('qb-phone:client:AnswerCall', source)
end)

RegisterServerEvent('qb-phone:server:AnswerCall')
AddEventHandler('qb-phone:server:AnswerCall', function(callData)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..callData.number.."%'", function(result)
        if result[1] ~= nil then
            local target = result[1]
            local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(target.citizenid)

            print(targetPlayer.PlayerData.source)

            if targetPlayer ~= nil then
                TriggerClientEvent('qb-phone:client:AnswerCallOther', targetPlayer.PlayerData.source)
            end
        end
    end)
end)

RegisterServerEvent('qb-phone:server:HangupCall')
AddEventHandler('qb-phone:server:HangupCall', function(callData)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `charinfo` LIKE '%"..callData.number.."%'", function(result)
        if result[1] ~= nil then
            local target = result[1]
            local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(target.citizenid)

            if targetPlayer ~= nil then
                TriggerClientEvent('qb-phone:client:HangupCallOther', targetPlayer.PlayerData.source, callData)
            end
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-phone:server:doesChatExists', function(source, cb, number)
    local ply = QBCore.Functions.GetPlayer(source)
    QBCore.Functions.ExecuteSql('SELECT * FROM `phone_messages` WHERE `citizenid` = "'..ply.PlayerData.citizenid..'" AND `number` = "'..number..'"', function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

QBCore.Commands.Add("ophangen", "Oproep beeindigen", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent('qb-phone:client:HangupCall', source)
end)

QBCore.Commands.Add("bel", "Oproep beeindigen", {}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        TriggerClientEvent('qb-phone:client:CallNumber', source, args[1])
    end
end)