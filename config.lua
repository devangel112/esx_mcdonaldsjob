Config = {}

Config.Locale = 'es'

Config.ScriptName = 'esx_bola8job'
Config.JobName = 'bola8'
Config.BossGradeLabel = 'boss'

Config.Locations = {
    ['garage']          = { pos = {x = -1586.68, y = -1001.04, z = 13.04} },
    ['garage_dv']       = { pos = {x = -1586.68, y = -1001.04, z = 13.04} },
    ['garage_spawn']    = { pos = {x = -1586.68, y = -1001.04, z = 13.04}, heading = 138.8 },
    ['boss']            = { pos = {x = -1576.56, y = -983.44, z = 13.12} },
    ['shop']            = { pos = { x = -176.797, y = 302.0845, z = 97.460 } },
    ['cloakroom']       = { pos = {x = 0.0, y = 0.0, z = 0.0} },
    ['armory']          = { pos = {x = 890.96, y = -184.64, z = 73.6} },
}

Config.GarageCars = {
    {label = 'Burrito', model = 'burrito3'}
}

Config.ShopItems = {
    -- {label = 'Gyozas', value = 'water_1', item = 'gyozas', price = 10, value = 1, type = 'slider', min = 1, max = 100}
    {label = 'Agua', item = 'water', price = 10, value = 1, type = 'slider', min = 1, max = 100},
}