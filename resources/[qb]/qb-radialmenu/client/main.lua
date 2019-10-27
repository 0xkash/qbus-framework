QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local inRadialMenu = false

function openRadial(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = Config.MenuItems
    })
    inRadialMenu = bool
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        if IsControlJustPressed(0, 19) then
            openRadial(true)
            SetCursorLocation(0.5, 0.5)
        end
    end
end)

RegisterNUICallback('closeRadial', function()
    openRadial(false)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    else
        TriggerServerEvent(itemData.event, itemData)
    end
end)

RegisterNetEvent('qb-radialmenu:client:giveidkaart')
AddEventHandler('qb-radialmenu:client:giveidkaart', function(data)
    print('Ik ben een getriggered event :)')
end)

RegisterNetEvent('qb-radialmenu:client:openDoor')
AddEventHandler('qb-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)

    if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= 1 then
        if GetVehicleDoorAngleRatio(GetVehiclePedIsIn(GetPlayerPed(-1), false), door) > 0 then
            SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), door, false)
        else
            SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), door, false, false)
        end
    end
end)