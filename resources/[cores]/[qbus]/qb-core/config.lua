QBConfig = {}

QBConfig.MaxPlayers = GetConvarInt('sv_maxclients', 32) -- Gets max players from config file, default 32
QBConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)
QBConfig.DefaultSpawn = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}

QBConfig.Money = {}
QBConfig.Money.MoneyTypes = {['cash']=500, ['bank']=10000, ['crypto']=0} -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
QBConfig.Money.DontAllowMinus = {'cash', 'crypto'} -- Money that is not allowed going in minus

QBConfig.Player = {}
QBConfig.Player.MaxWeight = 120000 -- Max weight a player can carry (currently 120kg, written in grams)
QBConfig.Player.MaxInvSlots = 40 -- Max inventory slots for a player

QBConfig.Server = {} -- General server config
QBConfig.Server.closed = true -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
QBConfig.Server.reason = "Test reden dat de server op slot zit." -- Reason message to display when people can't join the server
QBConfig.Server.uptime = 0 -- Time the server has been up.
QBConfig.Server.whitelist = true -- Enable or disable whitelist on the server
QBConfig.Server.discord = "https://discord.gg/Ttr6fY6" -- Discord invite link