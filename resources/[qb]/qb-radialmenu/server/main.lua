RegisterServerEvent('json:dataStructure')
AddEventHandler('json:dataStructure', function(data)
    print(json.encode(data))
end)

