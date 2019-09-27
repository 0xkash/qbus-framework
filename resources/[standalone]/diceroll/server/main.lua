QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end) -- Getest op mn eigen framework dus moet je ff verandere naar t inladen van ESX

QBCore.Commands.Add("roll", "Rol een aantal dobbelsteentjes :)", {{name="aantal", help="Aantal dobbelsteentjes"}, {name="zijdes", help="Aantal zijdes van dobbelsteentje"}}, true, function(source, args) -- Eigen add command functie mot je vervangen naar esx versie
    local amount = tonumber(args[1])
    local sides = tonumber(args[2])
    if (sides > 0 and sides <= DiceRoll.maxsides) and (amount > 0 and amount <= DiceRoll.maxamount) then 
        local result = {}
        for i=1, amount do 
            table.insert(result, math.random(1, sides))
        end
        TriggerClientEvent("diceroll:client:roll", -1, source, DiceRoll.maxdistance, result, sides)
    else
        TriggerClientEvent('QBCore:Notify', source, "Teveel aantal kanten of 0 (max: "..DiceRoll.maxsides..") of aantal dobbelstenen of 0 (max: "..DiceRoll.maxamount..")", "error") -- Hier moet je ff esx melding neerzetten
    end
end)