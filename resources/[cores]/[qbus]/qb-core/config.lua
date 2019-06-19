QBConfig = {}

QBConfig.MaxPlayers = GetConvarInt('sv_maxclients', 32) -- Gets max players from config file, default 32
QBConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)

QBConfig.Money = {}
QBConfig.Money.MoneyTypes = {['cash']=500, ['bank']=10000, ['crypto']=0} -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
