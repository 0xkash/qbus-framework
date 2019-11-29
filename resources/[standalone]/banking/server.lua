QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if ply.Functions.RemoveMoney('bank', amount) then
        ply.Functions.AddMoney('cash', amount)
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld op je bank..', 'error')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if ply.Functions.RemoveMoney('cash', amount) then
        ply.Functions.AddMoney('bank', amount)
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld op zak..', 'error')
    end
end)

QBCore.Commands.Add("geefcontant", "Geef contant geld aan een persoon", {{name="id", help="Speler ID"},{name="bedrag", help="Hoeveelheid geld"}}, true, function(source, args)
  local Player = QBCore.Functions.GetPlayer(source)
  local TargetId = tonumber(args[1])
  local Target = QBCore.Functions.GetPlayer(TargetId)
  local amount = tonumber(args[2])
  
  if Target ~= nil then
    if amount ~= nil then
      if amount > 0 then
        if Player.PlayerData.money.cash >= amount then
          if TargetId ~= source then
            Player.Functions.RemoveMoney('cash', amount)
            Target.Functions.AddMoney('cash', amount)
            TriggerClientEvent('chatMessage', TargetId, "SYSTEM", "success", "Je hebt €"..amount.." gekregen van "..Player.PlayerData.charinfo.firstname.."!")
            TriggerClientEvent('chatMessage', source, "SYSTEM", "success", "Je hebt €"..amount.." gegeven aan "..Target.PlayerData.charinfo.firstname.."!")
          else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je kunt geen geld aan jezelf geven.")
          end
        else
          TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt niet genoeg geld.")
        end
      else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "De hoeveelheid moet hoger zijn dan 0.")
      end
    else
      TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Vul een hoeveelheid in.")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet in de stad.")
  end    
end)