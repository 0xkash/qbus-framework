QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local tunedVehicles = {}

QBCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local src = source

    TriggerClientEvent('qb-tunerchip:client:openChip', src)
end)

RegisterServerEvent('qb-tunerchip:server:TuneStatus')
AddEventHandler('qb-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

QBCore.Functions.CreateCallback('qb-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)