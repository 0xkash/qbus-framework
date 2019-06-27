QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(core) QBCore = core end)
        Citizen.Wait(200)
    end
end)
--[[
RegisterNetEvent('QBCore:TestMenu')
AddEventHandler('QBCore:TestMenu', function()
	local elms = {}
	table.insert(elms, {label = "Test 1", onclick = function()
			print("TEST 1 TRIGGERED")
		end, onchange = function()
			print("CHANGED TO TEST 1")
		end
	})
	table.insert(elms, {label = "Test 2", onclick = function()
			print("TEST 2 TRIGGERED")
		end, onchange = function()
			print("CHANGED TO TEST 2")
		end
	})
	QBCore.Functions.OpenMenu("Title", "Subtitle", elms)
end)
]]

