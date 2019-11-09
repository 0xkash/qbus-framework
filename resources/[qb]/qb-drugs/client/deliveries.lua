currentDealer = nil
knockingDoor = false

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        nearDealer = false

        for id, dealer in pairs(Config.Dealers) do
            local dealerDist = GetDistanceBetweenCoords(pos, dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"])

            if dealerDist <= 10 then
                nearDealer = true

                if dealerDist <= 1.5 then
                    DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '[E] Om te kloppen')

                    if IsControlJustPressed(0, Keys["E"]) then
                        currentDealer = id
                        knockDealerDoor()
                    end
                end
            end
        end

        if not nearDealer then
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

knockDealerDoor = function()
    local hours = GetClockHours()

    knockDoorAnim(true)

    -- if hours > Config.Dealers[currentDealer]["time"]["min"] and hours < 24 or hours < Config.Dealers[currentDealer]["time"]["max"] and hours > 0 then
    --     knockDoorAnim(true)
    -- else
    --     knockDoorAnim(false)
    -- end
end

function knockDoorAnim(home)
    local knockAnimLib = "timetable@jimmy@doorknock@"
    local knockAnim = "knockdoor_idle"
    local PlayerPed = GetPlayerPed(-1)

    if home then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        local repItems = {}
        repItems.label = Config.Dealers[currentDealer]["name"]
        repItems.items = {}

        for k, v in pairs(Config.Dealers[currentDealer]["products"]) do
            if QBCore.Functions.GetPlayerData().metadata["dealerrep"] >= Config.Dealers[currentDealer]["products"][k].minrep then
                repItems.items[k] = Config.Dealers[currentDealer]["products"][k]
            end
        end

        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Dealer_"..Config.Dealers[currentDealer]["name"], repItems)
    else
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        QBCore.Functions.Notify('Het lijkt erop dat er niemand thuis is..', 'error', 3500)
    end
end

RegisterNetEvent('qb-drugs:client:updateDealerItems')
AddEventHandler('qb-drugs:client:updateDealerItems', function(itemData, amount)
    TriggerServerEvent('qb-drugs:server:updateDealerItems', itemData, amount, currentDealer)
end)

RegisterNetEvent('qb-drugs:client:setDealerItems')
AddEventHandler('qb-drugs:client:setDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
end)