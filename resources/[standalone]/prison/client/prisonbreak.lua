prisonBreak = false
currentGate = 0

local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local Gates = {
    [1] = {
        gatekey = 17,
        coords = {x = 1845.99, y = 2604.7, z = 45.58, h = 94.5},  
    },
    [2] = {
        gatekey = 18,
        coords = {x = 1819.47, y = 2604.67, z = 45.56, h = 98.5},
    }
}

Citizen.CreateThread(function()
    Citizen.Wait(500)
    requiredItems = {
        [1] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = QBCore.Shared.Items["gatecrack"]["name"], image = QBCore.Shared.Items["gatecrack"]["image"]},
    }
    while true do 
        Citizen.Wait(5)
        inRange = false
        currentGate = 0
        if isLoggedIn then
            if QBCore.Functions.GetPlayerData().job.name ~= "police" then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                for k, v in pairs(Gates) do
                    local dist = GetDistanceBetweenCoords(pos, Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, true)
                    if (dist < 1.5) then
                        currentGate = k
                        inRange = true
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if not inRange then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    if currentGate ~= 0 then 
        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
            if result then 
                TriggerEvent("mhacking:show")
                TriggerEvent("mhacking:start", math.random(5, 9), math.random(15, 20), OnHackDone)
            else
                QBCore.Functions.Notify("Je mist een item..", "error")
            end
        end, "gatecrack")
    end
end)

function OnHackDone(success, timeremaining)
	if success then
		TriggerServerEvent('qb-doorlock:server:updateState', Gates[currentGate].gatekey, false)
		TriggerEvent('mhacking:hide')
	else
		TriggerEvent('mhacking:hide')
	end
end