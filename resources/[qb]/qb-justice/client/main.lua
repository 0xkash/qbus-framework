QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["courthouse"].enter.x, Config.Locations["courthouse"].enter.y, Config.Locations["courthouse"].enter.z, true) < 1.5 then
            DrawText3D(Config.Locations["courthouse"].enter.x, Config.Locations["courthouse"].enter.y, Config.Locations["courthouse"].enter.z, "~g~E~w~ - Om naar binnen te gaan")
            if IsControlJustReleased(0, Config.Keys["E"]) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(GetPlayerPed(-1), Config.Locations["courthouse"].exit.x, Config.Locations["courthouse"].exit.y, Config.Locations["courthouse"].exit.z)
                SetEntityHeading(GetPlayerPed(-1), Config.Locations["courthouse"].exit.h)
                DoScreenFadeIn(500)
            end
        end

        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["courthouse"].exit.x, Config.Locations["courthouse"].exit.y, Config.Locations["courthouse"].exit.z, true) < 1.5 then
            DrawText3D(Config.Locations["courthouse"].exit.x, Config.Locations["courthouse"].exit.y, Config.Locations["courthouse"].exit.z, "~g~E~w~ - Om naar binnen te gaan")
            if IsControlJustReleased(0, Config.Keys["E"]) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(GetPlayerPed(-1), Config.Locations["courthouse"].enter.x, Config.Locations["courthouse"].enter.y, Config.Locations["courthouse"].enter.z)
                SetEntityHeading(GetPlayerPed(-1), Config.Locations["courthouse"].enter.h)
                DoScreenFadeIn(500)
            end
        end
    end
end)

RegisterNetEvent("qb-justice:client:showLawyerLicense")
AddEventHandler("qb-justice:client:showLawyerLicense", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

function DrawText3D(x, y, z, text)
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