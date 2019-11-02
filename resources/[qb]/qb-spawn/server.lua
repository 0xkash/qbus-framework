QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('qb-spawn:server:getOwnedHouses', function(source, cb, cid)
    QBCore.Functions.ExecuteSql('SELECT * FROM `player_houses` WHERE `citizenid` = "'..cid..'"', function(houses)
        if houses[1] ~= nil then
            cb(houses)
        else
            cb(nil)
        end
    end)
end)