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