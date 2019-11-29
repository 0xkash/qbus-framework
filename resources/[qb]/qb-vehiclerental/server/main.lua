QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local RentedVehicles = {}

RegisterServerEvent('qb-vehiclerental:server:SetVehicleRented')
AddEventHandler('qb-vehiclerental:server:SetVehicleRented', function(plate, bool, vehicleData)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local plyCid = ply.PlayerData.citizenid

    if bool then
        if ply.Functions.RemoveMoney('cash', vehicleData.price) then
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt de borg van €'..vehicleData.price..' betaald.', 'success', 3500)
            TriggerClientEvent('qb-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet genoeg geld.', 'error', 3500)
        end
        return
    end
    TriggerClientEvent('QBCore:Notify', src, 'Je hebt je borg van €'..vehicleData.price..' terug gekregen.', 'success', 3500)
    ply.Functions.AddMoney('cash', vehicleData.price)
    print(vehicleData.price)
    RentedVehicles[plyCid] = nil
end)