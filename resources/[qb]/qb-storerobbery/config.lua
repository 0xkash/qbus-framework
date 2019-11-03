Config = {}

Config.minEarn = 100
Config.maxEarn = 600
Config.RegisterEarnings = math.random(Config.minEarn, Config.maxEarn)

Config.Registers = {
    [1] = {x = -47.24, y = -1757.65, z = 29.53, robbed = false, time = 0},
    [2] = {x = -48.58, y = -1759.21, z = 29.59, robbed = false, time = 0},
}

Config.resetTime = (60 * 1000) * 30
Config.tickInterval = 1000