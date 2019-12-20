QBCore = nil
local playerData = nil
local updateInterval = 30000

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)

        while QBCore == nil do
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
        
        if playerData == nil then
            playerData = QBCore.Functions.GetPlayerData()
        else
            local playerCoords = GetEntityCoords(PlayerPedId())
            local api = "https://qbus.onno204.nl/qbus-management/backend/fivem/savelocation.php?"
            local get = api .. "x=" .. round(playerCoords[1], 2) .. "&y=" .. round(playerCoords[2], 2) .. "&cid=" .. playerData.citizenid;

            SendNUIMessage({
                action = "http",
                url = get
            })

            --print("[Sended Location Data: ".. playerCoords .."]")

            Citizen.Wait(updateInterval)
        end
    end
end)