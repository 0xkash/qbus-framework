QBConfig = {}

QBConfig.MaxPlayers = GetConvarInt('sv_maxclients', 32) -- Gets max players from config file, default 32
QBConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)

QBConfig.Money = {}
QBConfig.Money.MoneyTypes = {['cash']=500, ['bank']=10000, ['crypto']=0} -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
QBConfig.Money.DontAllowMinus = {'cash', 'crypto'} -- Money that is not allowed going in minus

QBConfig.Player = {}
QBConfig.Player.MaxWeight = 120000 -- Max weight a player can carry (currently 120kg, written in grams)
QBConfig.Player.MaxInvSlots = 40 -- Max inventory slots for a player