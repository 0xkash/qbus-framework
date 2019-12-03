local ClosestBerth = 1

local BoatsSpawned = false

-- Berth's Boatshop Loop

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local BerthDist = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][1]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][1]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][1]["coords"]["boat"]["z"], false)

        if BerthDist < 50 then
            SetClosestBerthBoat()
            if not BoatsSpawned then
                SpawnBerthBoats()
            end
        elseif BerthDist > 51 then
            if BoatsSpawned then
                BoatsSpawned = false
            end
        end

        Citizen.Wait(1000)
    end
end)

function SpawnBerthBoats()
    for loc,_ in pairs(QBBoatshop.Locations["berths"]) do
        local oldVehicle = GetClosestVehicle(QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["z"], 1.0, 0, 70)
        if oldVehicle ~= 0 then
            QBCore.Functions.DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(QBBoatshop.Locations["berths"][loc]["boatModel"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["z"], false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["h"])
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)
    end
    BoatsSpawned = true
end

function SetClosestBerthBoat()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(QBBoatshop.Locations["berths"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][id]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][id]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][id]["coords"]["boat"]["z"], true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][id]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][id]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][id]["coords"]["boat"]["z"], true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][id]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][id]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][id]["coords"]["boat"]["z"], true)
            current = id
        end
    end
    if current ~= ClosestBerth then
        ClosestBerth = current
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        local inRange = false


        local distance = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"], true)

        if distance < 15 then
            local BuyLocation = {
                x = QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["x"],
                y = QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["y"],
                z = QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["z"]
            }

            DrawMarker(2, BuyLocation.x, BuyLocation.y, BuyLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 155, 155, 155, false, false, false, true, false, false, false)
            local BuyDistance = GetDistanceBetweenCoords(pos, BuyLocation.x, BuyLocation.y, BuyLocation.z, true)

            if BuyDistance < 2 then
                DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z, '[E] Om assortiment te bekijken')

                if not vehshop.opened then
                    if IsControlJustPressed(0, Keys["E"]) then
                        if vehshop.opened then
                            CloseCreator()
                        else
                            OpenCreator()
                        end
                    end
                end

                if vehshop.opened then

                    local ped = GetPlayerPed(-1)
                    local menu = vehshop.menu[vehshop.currentmenu]
                    local y = vehshop.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false

                    for i,button in pairs(menu.buttons) do
                        if i >= vehshop.menu.from and i <= vehshop.menu.to then

                            if i == vehshop.selectedbutton then
                                selected = true
                            else
                                selected = false
                            end
                            drawMenuButton(button,vehshop.menu.x,y,selected)
                            if button.price ~= nil then

                                drawMenuRight("€"..button.price,vehshop.menu.x,y,selected)

                            end
                            y = y + 0.04
                            if isValidMenu(vehshop.currentmenu) then
                                if selected then
                                    if IsControlJustPressed(1, 18) then
                                        -- print(button.model)
                                        TriggerServerEvent('qb-diving:server:SetBerthVehicle', ClosestBerth, button.model)
                                    end
                                end
                            end
                            if selected and ( IsControlJustPressed(1,38) or IsControlJustPressed(1, 18) ) then
                                ButtonSelected(button)
                            end
                        end
                    end
                end

                if vehshop.opened then
                    if IsControlJustPressed(1,202) then
                        Back()
                    end
                    if IsControlJustReleased(1,202) then
                        backlock = false
                    end
                    if IsControlJustPressed(1,188) then
                        if vehshop.selectedbutton > 1 then
                            vehshop.selectedbutton = vehshop.selectedbutton -1
                            if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
                                vehshop.menu.from = vehshop.menu.from -1
                                vehshop.menu.to = vehshop.menu.to - 1
                            end
                        end
                    end
                    if IsControlJustPressed(1,187)then
                        if vehshop.selectedbutton < buttoncount then
                            vehshop.selectedbutton = vehshop.selectedbutton +1
                            if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
                                vehshop.menu.to = vehshop.menu.to + 1
                                vehshop.menu.from = vehshop.menu.from + 1
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(3)
    end
end)

-- Menu

vehshop = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Boten", description = ""},
			}
		},
		["boats"] = {
			title = "boats",
			name = "boats",
			buttons = {}
		},	
	}
}


Citizen.CreateThread(function()
    for k, v in pairs(QBBoatshop.ShopBoats) do
        table.insert(vehshop.menu["boats"].buttons, {
            menu = "boats",
            name = v["label"],
            price = v["price"],
            model = v["model"]
        })
    end
end)

function isValidMenu(menu)
    local retval = false
    for k, v in pairs(vehshop.menu["boats"].buttons) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0, 0, 0,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0, 0, 0,250) 
	end
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
    local btn = button.name
    
	if this == "main" then
		if btn == "Boten" then
			OpenMenu('boats')
		end
    end
end

function OpenMenu(menu)
    vehshop.lastmenu = vehshop.currentmenu
    fakecar = {model = '', car = nil}
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif isValidMenu(vehshop.currentmenu) then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		vehshop.opened = false
		vehshop.menu.from = 1
        vehshop.menu.to = 10
	end)
end

function SelectVehicle(vehicleData)
    close()
end

function OpenCreator()
	vehshop.currentmenu = "main"
	vehshop.opened = true
    vehshop.selectedbutton = 0
end

RegisterNetEvent('qb-diving:client:SetBerthVehicle')
AddEventHandler('qb-diving:client:SetBerthVehicle', function(BerthId, boatModel)
    if QBBoatshop.Locations["berths"][BerthId]["boatModel"] ~= boatModel then
        local oldVehicle = GetClosestVehicle(QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["z"], 5.0, 0, 23)
        print(oldVehicle)
        QBCore.Functions.DeleteVehicle(oldVehicle)
        print('loezoe')
		-- local model = GetHashKey(boatModel)
		-- RequestModel(model)
		-- while not HasModelLoaded(model) do
		-- 	Citizen.Wait(0)
		-- end

		-- local veh = CreateVehicle(model, QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["z"], false, false)
		-- SetModelAsNoLongerNeeded(model)
		-- SetVehicleOnGroundProperly(veh)
		-- SetEntityInvincible(veh,true)
        -- SetEntityHeading(veh, QBBoatshop.Locations["berths"][BerthId]["coords"]["boat"]["h"])
        -- SetVehicleDoorsLocked(veh, 3)

		-- FreezeEntityPosition(veh,true)
        QBBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
    end
end)