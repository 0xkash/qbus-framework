QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

RegisterServerEvent('qb-phone:server:setPhoneMeta')
AddEventHandler('qb-phone:server:setPhoneMeta', function(phoneMeta)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.SetMetaData("phone", phoneMeta)
end)