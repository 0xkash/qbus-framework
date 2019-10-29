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

    -- {
    --     id    = 'givekey',
    --     title = 'Conny Links',
    --     icon = '#citizen',
    --     type = 'client',
    --     event = 'qb-houses:client:giveHouseKey',
    --     shouldClose = true,
    -- },

local inRadialMenu = false

function setupSubItems()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestHousePlayers = {}
    local closestVehiclePlayers = {}

    for k, v in pairs(closestPlayers) do
        if v ~= 0 then
            table.insert(closestHousePlayers, {
                id = GetPlayerServerId(v),
                title = GetPlayerName(PlayerId(v)),
                icon = '#citizen',
                type = 'client',
                event = 'qb-houses:client:giveHouseKey',
                shouldClose = true,
            })

            table.insert(closestVehiclePlayers, {
                id = GetPlayerServerId(v),
                title = GetPlayerName(PlayerId(v)),
                icon = '#citizen',
                type = 'client',
                event = 'qb-houses:client:giveVehicleKey',
                shouldClose = true,
            })
            print('inserted')
        end
    end

    if next(closestVehiclePlayers) ~= nil then
        Config.MenuItems[3].items[1].items = closestVehiclePlayers
    else
        Config.MenuItems[3].items[1] = 
        {
            id    = 'givekey',
            title = 'Geef Voertuig Sleutel',
            icon = '#vehiclekey',
            type = 'client',
            event = 'qb-radialmenu:client:noPlayers',
            shouldClose = true,
        }
    end

    if next(closestHousePlayers) ~= nil then
        Config.MenuItems[2].items[1].items[1].items = closestHousePlayers
    else
        Config.MenuItems[2].items[1].items[1] = 
        {
            id    = 'givehousekey',
            title = 'Geef Huis Sleutel',
            icon = '#vehiclekey',
            type = 'client',
            event = 'qb-radialmenu:client:noPlayers',
            shouldClose = true,
        }
    end
end

function openRadial(bool)    
    setupSubItems()

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

        if IsControlJustPressed(0, Keys["F1"]) then
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

RegisterNetEvent('qb-radialmenu:client:noPlayers')
AddEventHandler('qb-radialmenu:client:noPlayers', function(data)
    QBCore.Functions.Notify('Er zijn geen personen in de buurt', 'error', 2500)
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