QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

QBCore.Functions.CreateCallback('qb-weed:server:getBuildingPlants', function(source, cb, building)
    local buildingPlants = {}

    exports['ghmattimysql']:execute('SELECT * FROM house_plants WHERE building = @building', {['@building'] = building}, function(plants)
        for i = 1, #plants, 1 do
            table.insert(buildingPlants, plants[i])
        end

        if buildingPlants ~= nil then
            cb(buildingPlants)
        else    
            cb(nil)
        end
    end)
end)

QBCore.Commands.Add("plaatsplant", "", {}, false, function(source, args)
    local src           = source
    local player        = QBCore.Functions.GetPlayer(src)
    local type          = args[1]

    if QBWeed.Plants[type] ~= nil then
        TriggerClientEvent('qb-weed:client:placePlant', src, type)
    else
        print('Is geen plant man')
    end
end)

RegisterServerEvent('qb-weed:server:placePlant')
AddEventHandler('qb-weed:server:placePlant', function(currentHouse, coords, sort)
    QBCore.Functions.ExecuteSql("INSERT INTO `house_plants` (`building`, `coords`, `sort`, `plantid`) VALUES ('"..currentHouse.."', '"..coords.."', '"..sort.."', '"..math.random(111111,999999).."')")
    TriggerClientEvent('qb-weed:client:refreshHousePlants', -1, currentHouse)
end)

RegisterServerEvent('qb-weed:server:removeDeathPlant')
AddEventHandler('qb-weed:server:removeDeathPlant', function(building, plantId)
    QBCore.Functions.ExecuteSql("DELETE FROM `house_plants` WHERE plantid = '"..plantid.."' AND building = '"..building.."'")
    TriggerClientEvent('qb-weed:client:refreshHousePlants', -1, building)
end)

Citizen.CreateThread(function()
    while true do
        QBCore.Functions.ExecuteSql("SELECT * FROM `house_plants`", function(housePlants)
            for k, v in pairs(housePlants) do

                if housePlants[k].food >= 50 then
                    QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `food` = '"..(housePlants[k].food - 1).."'")
                    if housePlants[k].health + 1 < 100 then
                        QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `health` = '"..(housePlants[k].health + 1).."'")
                    end
                end

                if housePlants[k].food < 50 then
                    if housePlants[k].food - 1 >= 0 then
                        QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `food` = '"..(housePlants[k].food - 1).."'")
                    end
                    if housePlants[k].health - 1 >= 0 then
                        QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `health` = '"..(housePlants[k].health - 1).."'")
                    end
                end

                if housePlants[k].health > 50 then
                    if housePlants[k].progress + 1 < 100 then
                        QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `progress` = '"..(housePlants[k].progress + 1).."'")
                    elseif housePlants[k].progress + 1 == 100 then
                        if housePlants[k].stage ~= QBWeed.Plants[housePlants[k].sort]["highestStage"] then
                            if housePlants[k].stage == "stage-a" then
                                QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `stage` = 'stage-b'")
                            elseif housePlants[k].stage == "stage-b" then
                                QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `stage` = 'stage-c'")
                            elseif housePlants[k].stage == "stage-c" then
                                QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `stage` = 'stage-d'")
                            elseif housePlants[k].stage == "stage-d" then
                                QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `stage` = 'stage-e'")
                            elseif housePlants[k].stage == "stage-e" then
                                QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `stage` = 'stage-f'")
                            elseif housePlants[k].stage == "stage-f" then
                                QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `stage` = 'stage-g'")
                            end
                            QBCore.Functions.ExecuteSql("UPDATE `house_plants` SET `progress` = '0'")
                        end
                    end
                end

                TriggerClientEvent('qb-weed:client:refreshPlantStats', -1)
            end
        end)

        Citizen.Wait(10 * 1000)
    end
end)

QBCore.Functions.CreateUseableItem("weed_whitewidow_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

end)

QBCore.Functions.CreateUseableItem("weed_skunk_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

end)

QBCore.Functions.CreateUseableItem("weed_purplehaze_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

end)

QBCore.Functions.CreateUseableItem("weed_ogkush_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

end)

QBCore.Functions.CreateUseableItem("weed_amnesia_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

end)

QBCore.Functions.CreateUseableItem("weed_ak47_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    
end)