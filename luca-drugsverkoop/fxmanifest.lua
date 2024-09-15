-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }
lua54 'yes'

author 'luca2nl'
description 'Witwas, OX ESX REQUIRED. DM lucca.nl voor hulp. September 2024'
version '1.0.0'


shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}
-- What to run
client_scripts {
    'config.lua',
    'client.lua'

}
server_scripts {
    'config.lua',
    'server.lua',
    '@oxmysql/lib/MySQL.lua'

}

dependencies {
    'ox_lib',
    'es_extended'
}
