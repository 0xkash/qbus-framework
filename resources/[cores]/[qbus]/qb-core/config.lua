QBConfig = {}

QBConfig.MaxPlayers = GetConvarInt('sv_maxclients', 32) -- Gets max players from config file, default 32
QBConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)

QBConfig.Money = {}
QBConfig.Money.Prefix = "€"
QBConfig.Money.MoneyTypes = {['cash']=500, ['bank']=10000} -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
QBConfig.Money.HUDEnable = true -- show moneyhud
QBConfig.Money.HUDOn = true
QBConfig.Money.DrawLocations = {['cash'] = {x = 1.422, y = 0.5822, prefix = "~g~"..QBConfig.Money.Prefix.." ~w~", alpha = 250, show = true}, ['bank'] = {x = 1.422, y = 0.6122, prefix = "~b~"..QBConfig.Money.Prefix.." ~w~", alpha = 250, show = true}} -- Draw locations for money, is HUDEnable is false it doesn't matter, add only the moneytypes you want to show and make sure they are in the MoneyTypes table, set show to false if you want to disable it for showing in commands (/cash /bank etc.)
QBConfig.Money.MoneyTimeOut = 5 -- amount much time money hud disapear after a change (in seconds), set to -1 to keep on