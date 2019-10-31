QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('apartments:IsOwner', function(source, cb, apartment)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("SELECT * FROM `apartments` WHERE `name` = '"..apartment.."'", function(result)
        if result[1] ~= nil then 
            if result[1].citizenid == Player.PlayerData.citizenid then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)