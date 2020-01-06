QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local bankamount = ply.PlayerData.money["bank"]
    local amount = tonumber(amount)
    if bankamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('bank', amount, "Bank withdraw")
      TriggerEvent("qb-log:server:CreateLog", "banking", "Withdraw", "red", "**"..GetPlayerName(src) .. "** heeft €"..amount.." opgenomen van zijn bank.")
      ply.Functions.AddMoney('cash', amount, "Bank withdraw")
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld op je bank..', 'error')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local cashamount = ply.PlayerData.money["cash"]
    local amount = tonumber(amount)
    if cashamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('cash', amount, "Bank depost")
      TriggerEvent("qb-log:server:CreateLog", "banking", "Deposit", "green", "**"..GetPlayerName(src) .. "** heeft €"..amount.." op zijn bank gezet.")
      ply.Functions.AddMoney('bank', amount, "Bank depost")
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
        if Player.PlayerData.money.cash >= amount and amount > 0 then
          if TargetId ~= source then
            TriggerClientEvent('banking:client:CheckDistance', source, TargetId, amount)
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

RegisterServerEvent('banking:server:giveCash')
AddEventHandler('banking:server:giveCash', function(trgtId, amount)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local Target = QBCore.Functions.GetPlayer(trgtId)

  Player.Functions.RemoveMoney('cash', amount, "Cash given to "..Player.PlayerData.citizenid)
  Target.Functions.AddMoney('cash', amount, "Cash received from "..Target.PlayerData.citizenid)

  TriggerEvent("qb-log:server:CreateLog", "banking", "Geef contant", "blue", "**"..GetPlayerName(src) .. "** heeft €"..amount.." gegeven aan **" .. GetPlayerName(trgtId) .. "**")
  
  TriggerClientEvent('QBCore:Notify', trgtId, "Je hebt €"..amount.." gekregen van "..Player.PlayerData.charinfo.firstname.."!", 'success')
  TriggerClientEvent('QBCore:Notify', src, "Je hebt €"..amount.." gegeven aan "..Target.PlayerData.charinfo.firstname.."!", 'success')
end)