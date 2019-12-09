QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local radioMenu = false

function enableRadio(enable)
  SetNuiFocus(true, true)
  radioMenu = enable
  SendNUIMessage({
    type = "enableui",
    enable = enable
  })

  if enable then
    PhonePlayIn()
  else
    PhonePlayOut()
  end
end

RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = QBCore.Functions.GetPlayerData()
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  if tonumber(data.channel) <= Config.MaxFrequency then
    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
      if tonumber(data.channel) <= Config.RestrictedChannels then
        if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'doctor') then
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
          exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel), "Radio", "radio")
          if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
            QBCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>', 'success')
          else
            QBCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>', 'success')
          end
        else
          QBCore.Functions.Notify(Config.messages['restricted_channel_error'], 'error')
        end
      end

      if tonumber(data.channel) > Config.RestrictedChannels then
        exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
        exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
        exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel), "Radio", "radio")
        if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
          QBCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>', 'success')
        else
          QBCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>', 'success')
        end
      end
    else
      if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
        QBCore.Functions.Notify(Config.messages['you_on_radio'] .. data.channel .. ' MHz </b>', 'error')
      else
        QBCore.Functions.Notify(Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>', 'error')
      end
    end
  else
    QBCore.Functions.Notify('Deze frequentie is niet beschikbaar.', 'error')
  end
  cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")
  if getPlayerRadioChannel == "nil" then
    QBCore.Functions.Notify(Config.messages['not_on_radio'], 'error')
  else
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    if SplitStr(getPlayerRadioChannel, ".")[2] ~= nil and SplitStr(getPlayerRadioChannel, ".")[2] ~= "" then 
      QBCore.Functions.Notify(Config.messages['you_leave'] .. getPlayerRadioChannel .. ' MHz </b>', 'error')
    else
      QBCore.Functions.Notify(Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>', 'error')
    end
    
  end
  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
  enableRadio(false)
  SetNuiFocus(false, false)
  cb('ok')
end)

RegisterNetEvent('qb-radio:use')
AddEventHandler('qb-radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('qb-radio:onRadioDrop')
AddEventHandler('qb-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  if getPlayerRadioChannel ~= "nil" then
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    QBCore.Functions.Notify(Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>', 'error')
  end
end)

function SplitStr(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end