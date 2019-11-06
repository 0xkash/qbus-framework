local isLoggedIn = true
local housePlants = {}
local insideHouse = false
local currentHouse = nil

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

QBWeed.DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('qb-weed:client:getHousePlants')
AddEventHandler('qb-weed:client:getHousePlants', function(house)    
    print('yeet?') 
    QBCore.Functions.TriggerCallback('qb-weed:server:getBuildingPlants', function(plants)
        currentHouse = house
        housePlants[currentHouse] = plants
        insideHouse = true
        spawnHousePlants()
    end, house)
end)

function spawnHousePlants()
    Citizen.CreateThread(function()
        if not plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                }

                plantProp = CreateObject(plantData["plantProp"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                FreezeEntityPosition(plantProp, true)
                SetEntityAsMissionEntity(plantProp, false, false)
                PlaceObjectOnGroundProperly(plantProp)
            end
            plantSpawned = true
        end
    end)
end

function despawnHousePlants()
    Citizen.CreateThread(function()
        if plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                }

                local closestPlant = GetClosestObjectOfType(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 1.0, plantData["plantProp"], false, false, false)
                DeleteObject(closestPlant)
            end
            plantSpawned = false
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if insideHouse then
            if plantSpawned then
                local ped = GetPlayerPed(-1)
                for k, v in pairs(housePlants[currentHouse]) do
                    local gender = "M"
                    if housePlants[currentHouse][k].gender == "woman" then gender = "V" end

                    local plantData = {
                        ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                        ["plantStage"] = housePlants[currentHouse][k].stage,
                        ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                        ["plantSort"] = {
                            ["name"] = housePlants[currentHouse][k].sort,
                            ["label"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["label"],
                        },
                        ["plantStats"] = {
                            ["food"] = housePlants[currentHouse][k].food,
                            ["health"] = housePlants[currentHouse][k].health,
                            ["progress"] = housePlants[currentHouse][k].progress,
                            ["stage"] = housePlants[currentHouse][k].stage,
                            ["highestStage"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["highestStage"],
                            ["gender"] = gender,
                            ["plantId"] = housePlants[currentHouse][k].plantid,
                        }
                    }

                    local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

                    if plyDistance < 1.0 then
                        if plantData["plantStats"]["health"] > 0 then
                            if plantData["plantStage"] ~= plantData["plantStats"]["highestStage"] then
                                QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Soort: '..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | Voeding: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Gezondheid: ~b~'..plantData["plantStats"]["health"]..'%')
                            else
                                QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"] + 0.2, 'De plant is volgroeid ~g~E~w~ om te oogsten..')
                                QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Soort: ~g~'..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | Voeding: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Gezondheid: ~b~'..plantData["plantStats"]["health"]..'%')
                                if IsControlJustPressed(0, QBWeed.Keys["E"]) then
                                    QBCore.Functions.Progressbar("remove_weed_plant", "Plant aan het oogsten..", 8000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "amb@world_human_gardener_plant@male@base",
                                        anim = "base",
                                        flags = 16,
                                    }, {}, {}, function() -- Done
                                        ClearPedTasks(ped)
                                        if plantData["plantStats"]["gender"] == "M" then
                                            amount = math.random(1, 5)
                                        else
                                            amount = math.random(3, 8)
                                        end
                                        TriggerServerEvent('qb-weed:server:harvestPlant', currentHouse, amount, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                                    end, function() -- Cancel
                                        ClearPedTasks(ped)
                                        QBCore.Functions.Notify("Proces geannuleerd..", "error")
                                    end)
                                end
                            end
                        elseif plantData["plantStats"]["health"] == 0 then
                            QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'De plant is dood, ~r~E~w~ - Om plant weg te halen..')
                            if IsControlJustPressed(0, QBWeed.Keys["E"]) then
                                QBCore.Functions.Progressbar("remove_weed_plant", "Plant aan het weghalen..", 8000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "amb@world_human_gardener_plant@male@base",
                                    anim = "base",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('qb-weed:server:removeDeathPlant', currentHouse, plantData["plantStats"]["plantId"])
                                end, function() -- Cancel
                                    ClearPedTasks(ped)
                                    QBCore.Functions.Notify("Proces geannuleerd..", "error")
                                end)
                            end
                        end
                    end
                end
            end
        end

        if not insideHouse then
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('qb-weed:client:leaveHouse')
AddEventHandler('qb-weed:client:leaveHouse', function()
    despawnHousePlants()
    SetTimeout(1000, function()
        insideHouse = false
        housePlants[currentHouse] = nil
        currentHouse = nil
    end)
end)


RegisterNetEvent('qb-weed:client:refreshHousePlants')
AddEventHandler('qb-weed:client:refreshHousePlants', function(house)
    if currentHouse ~= nil and currentHouse == house then
        despawnHousePlants()
        QBCore.Functions.TriggerCallback('qb-weed:server:getBuildingPlants', function(plants)
            currentHouse = house
            housePlants[currentHouse] = plants
            spawnHousePlants()
        end, house)
    end
end)

RegisterNetEvent('qb-weed:client:refreshPlantStats')
AddEventHandler('qb-weed:client:refreshPlantStats', function()
    if insideHouse then
        despawnHousePlants()
        QBCore.Functions.TriggerCallback('qb-weed:server:getBuildingPlants', function(plants)
            housePlants[currentHouse] = plants
            spawnHousePlants()
        end, currentHouse)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

RegisterNetEvent('qb-weed:client:placePlant')
AddEventHandler('qb-weed:client:placePlant', function(type, item)
    local ped = GetPlayerPed(-1)
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, 0)
    local plantData = {
        ["plantCoords"] = {["x"] = plyCoords.x, ["y"] = plyCoords.y, ["z"] = plyCoords.z},
        ["plantModel"] = QBWeed.Plants[type]["stages"]["stage-a"],
        ["plantLabel"] = QBWeed.Plants[type]["label"]
    }

    if currentHouse ~= nil then
        QBCore.Functions.Progressbar("plant_weed_plant", "Bezig met planten..", 8000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_gardener_plant@male@base",
            anim = "base",
            flags = 16,
        }, {}, {}, function() -- Done
            ClearPedTasks(ped)
            plantObject = CreateObject(plantData["plantModel"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
            FreezeEntityPosition(plantObject, true)
            SetEntityAsMissionEntity(plantObject, false, false)
            PlaceObjectOnGroundProperly(plantObject)
        
            TriggerServerEvent('qb-weed:server:placePlant', currentHouse, json.encode(plantData["plantCoords"]), type)
            TriggerServerEvent('qb-weed:server:removeSeed', item.slot, type)
        end, function() -- Cancel
            ClearPedTasks(ped)
            QBCore.Functions.Notify("Proces geannuleerd..", "error")
        end)
    else
        QBCore.Functions.Notify('Het is hier niet veilig..', 'error', 3500)
    end
end)

RegisterNetEvent('qb-weed:client:foodPlant')
AddEventHandler('qb-weed:client:foodPlant', function(item)
    if currentHouse ~= nil then
        for k, v in pairs(housePlants[currentHouse]) do
            local ped = GetPlayerPed(-1)
            local gender = "M"
            if housePlants[currentHouse][k].gender == "woman" then gender = "V" end
            local plantData = {
                ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                ["plantStage"] = housePlants[currentHouse][k].stage,
                ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                ["plantSort"] = {
                    ["name"] = housePlants[currentHouse][k].sort,
                    ["label"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["label"],
                },
                ["plantStats"] = {
                    ["food"] = housePlants[currentHouse][k].food,
                    ["health"] = housePlants[currentHouse][k].health,
                    ["progress"] = housePlants[currentHouse][k].progress,
                    ["stage"] = housePlants[currentHouse][k].stage,
                    ["highestStage"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["highestStage"],
                    ["gender"] = gender,
                    ["plantId"] = housePlants[currentHouse][k].plantid,
                }
            }

            local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

            if plyDistance < 1.2 then
                if plantData["plantStats"]["food"] == 100 then
                    QBCore.Functions.Notify('De plant heeft geen voeding nodig..', 'error', 3500)
                else
                    QBCore.Functions.Progressbar("plant_weed_plant", "Plant aan het voeden..", 8000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "timetable@gardener@filling_can",
                        anim = "gar_ig_5_filling_can",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(ped)
                        local newFood = math.random(10, 25)
                        TriggerServerEvent('qb-weed:server:foodPlant', currentHouse, newFood, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                    end, function() -- Cancel
                        ClearPedTasks(ped)
                        QBCore.Functions.Notify("Proces geannuleerd..", "error")
                    end)
                end
            else    
                QBCore.Functions.Notify('Er is geen plant in de buurt..', 'error', 3500)
            end
        end
    end
end)