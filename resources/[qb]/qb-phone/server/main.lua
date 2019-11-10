QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

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

function GenerateMailId()
    return math.random(111111, 999999)
end

function convertDate(vardate)
    local y,m,d,h,i,s = string.match(vardate, '(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)')
    return string.format('%s/%s/%s %s:%s:%s', d,m,y,h,i,s)
end