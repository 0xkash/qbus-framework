QBConfig = {}
QBConfig.MaxPlayers = GetConvarInt('sv_maxclients', 32) -- Gets max players from config file, default 32
QBConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license or qbus)
