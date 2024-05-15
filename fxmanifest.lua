fx_version 'adamant'
game 'gta5'
author 'Gaspar Pereira - Discord: gasparmpereira'
description 'Image Hosting Resource'
version '1.0.1'

shared_scripts{
    'config.lua'
}
client_scripts{
    'client.lua'
}
server_scripts{
	'@mysql-async/lib/MySQL.lua',
    'server.lua'
}
