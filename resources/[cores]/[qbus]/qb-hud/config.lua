Config = {}

Config.Money = {}
Config.Money.Prefix = "€"
Config.Money.HUDEnable = true -- show moneyhud
Config.Money.HUDOn = true
Config.Money.DrawLocations = {['cash'] = {x = 1.422, y = 0.5822, prefix = "~g~"..Config.Money.Prefix.." ~w~", alpha = 250, show = true}, ['bank'] = {x = 1.422, y = 0.6122, prefix = "~b~"..Config.Money.Prefix.." ~w~", alpha = 250, show = true}} -- Draw locations for money, is HUDEnable is false it doesn't matter, add only the moneytypes you want to show and make sure they are in the MoneyTypes table, set show to false if you want to disable it for showing in commands (/cash /bank etc.)
Config.Money.MoneyTimeOut = 5 -- amount much time money hud disapear after a change (in seconds), set to -1 to keep on