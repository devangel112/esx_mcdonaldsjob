fx_version 'cerulean'
games {'gta5'}

author 'Angel112 <dev.angel.perez@gmail.com>'
description 'ESX Job example script'
version '1.0.0'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua'
}