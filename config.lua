Config = {}

Config.Locale = 'es'

Config.ScriptName = 'esx_mcdonaldsjob'
Config.JobName = 'mcdonalds'
Config.BossGradeLabel = 'boss'

Config.Locations = {
    ['garage']          = { pos = {x = 115.6, y = 279.2, z = 109.96} },
    ['garage_spawn']    = { pos = {x = 115.6, y = 279.2, z = 109.96}, heading = 341.68 },
    ['garage_dv']       = { pos = {x = 106.56, y = 282.4, z = 109.96} },
    ['boss']            = { pos = {x = 84.08, y = 293.48, z = 110.2} },
    ['shop']            = { pos = {x = 111.76, y = 302.28, z = 109.96} },
    ['cloakroom']       = { pos = {x = 0.0, y = 0.0, z = 0.0} },
    ['armory']          = { pos = {x = 95.08, y = 289.96, z = 110.2} },
}

Config.GarageCars = {
    {label = 'Burrito', model = 'burrito3'}
}

Config.ShopItems = {
    -- {label = 'Gyozas', value = 'water_1', item = 'gyozas', price = 10, value = 1, type = 'slider', min = 1, max = 100}
    {label = 'Agua', item = 'water', price = 10, value = 1, type = 'slider', min = 1, max = 100},
}