QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehicletuning:client:RepairVehicle", source)
    end
end)