QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateUseableItem("radio", function(source, item)
  local Player = QBCore.Functions.GetPlayer(source)
  
  TriggerClientEvent('qb-radio:use', source)
end)