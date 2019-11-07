QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

--- CODE

AvailableWeatherTypes = {
    {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
    {label = "Clear",               weather = 'CLEAR',}, 
    {label = "Neutral",             weather = 'NEUTRAL',}, 
    {label = "Smog",                weather = 'SMOG',}, 
    {label = "Foggy",               weather = 'FOGGY',}, 
    {label = "Overcast",            weather = 'OVERCAST',}, 
    {label = "Clouds",              weather = 'CLOUDS',}, 
    {label = "Clearing",            weather = 'CLEARING',}, 
    {label = "Rain",                weather = 'RAIN',}, 
    {label = "Thunder",             weather = 'THUNDER',}, 
    {label = "Snow",                weather = 'SNOW',}, 
    {label = "Blizzard",            weather = 'BLIZZARD',}, 
    {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
    {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
    {label = "Halloween (Scarry)",  weather = 'HALLOWEEN',},
}

function getPlayers()
    for i = 1, 1 do
        players = {}
        local localplayers = {}
        for i = 0, 255 do
            if NetworkIsPlayerActive( i ) then
                table.insert( localplayers, GetPlayerServerId(i) )
            end
        end
        
        table.sort(localplayers)
        for i,thePlayer in ipairs(localplayers) do
            table.insert(players, GetPlayerFromServerId(thePlayer))
        end
        return players
    end
end

RegisterNetEvent('qb-admin:client:openMenu')
AddEventHandler('qb-admin:client:openMenu', function()
    WarMenu.OpenMenu('admin')
end)

local currentPlayer = 0

Citizen.CreateThread(function()
    local players = getPlayers()
    local menus = {
        "admin",
        "playerMan",
        "serverMan",
        currentPlayer,
        "playerOptions",
        "teleportOptions",
        "weatherOptions",
    }

    WarMenu.CreateMenu('admin', 'QBus Admin')
    WarMenu.CreateSubMenu('playerMan', 'admin')
    WarMenu.CreateSubMenu('serverMan', 'admin')
    
    for k, v in pairs(players) do
        WarMenu.CreateSubMenu(v, 'playerMan', GetPlayerServerId(v).." | "..GetPlayerName(v))
    end

    WarMenu.CreateSubMenu('playerOptions', currentPlayer)
    WarMenu.CreateSubMenu('teleportOptions', currentPlayer)

    WarMenu.CreateSubMenu('weatherOptions', currentPlayer)

    for i = 1, (#menus), 1 do
        WarMenu.SetMenuX(menus[i], 0.71)
        WarMenu.SetMenuY(menus[i], 0.15)
        WarMenu.SetMenuWidth(menus[i], 0.23)
        WarMenu.SetTitleColor(menus[i], 255, 255, 255, 255)
        WarMenu.SetTitleBackgroundColor(menus[i], 0, 0, 0, 111)
    end

    while true do
        if WarMenu.IsMenuOpened('admin') then
            WarMenu.MenuButton('Player Management', 'playerMan')
            WarMenu.MenuButton('Server Management', 'serverMan')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerMan') then
            for k, v in pairs(players) do
                if WarMenu.MenuButton('#'..GetPlayerServerId(v).." | "..GetPlayerName(v), v) then
                    currentPlayer = v
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('serverMan') then
            WarMenu.MenuButton('Weather Options', 'weatherOptions')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened(currentPlayer) then
            WarMenu.MenuButton('Player Options', 'playerOptions')
            WarMenu.MenuButton('Teleport Options', 'teleportOptions')
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerOptions') then
            if WarMenu.MenuButton('Slay', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)
                SetEntityHealth(target, 0)
            end
            if WarMenu.MenuButton('Revive', currentPlayer) then
                local target = GetPlayerServerId(currentPlayer)
                TriggerServerEvent('qb-admin:server:revivePlayer', target)
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('teleportOptions') then
            if WarMenu.MenuButton('Goto', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)
                SetEntityCoords(ply, GetEntityCoords(target))
            end
            if WarMenu.MenuButton('Bring', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)

                SetEntityCoords(target, GetEntityCoords(ply))
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('weatherOptions') then
            for k, v in pairs(AvailableWeatherTypes) do
                if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                    TriggerServerEvent('qb-weathersync:server:setWeather', AvailableWeatherTypes[k].weather)
                    QBCore.Functions.Notify('Weer is veranderd naar: '..AvailableWeatherTypes[k].label)
                end
            end
            
            WarMenu.Display()
        end

        Citizen.Wait(0)
    end
end)


-- if WarMenu.MenuButton('Slay', currentPlayer) then
--     local target = GetPlayerPed(currentPlayer)
--     local ply = GetPlayerPed(-1)
--     SetEntityHealth(target, 0)
-- end
-- if WarMenu.MenuButton('Goto', currentPlayer) then
--     local target = GetPlayerPed(currentPlayer)
--     local ply = GetPlayerPed(-1)
--     SetEntityCoords(ply, GetEntityCoords(target))
-- end
-- if WarMenu.MenuButton('Bring', currentPlayer) then
--     local target = GetPlayerPed(currentPlayer)
--     local ply = GetPlayerPed(-1)

--     SetEntityCoords(target, GetEntityCoords(ply))
-- end