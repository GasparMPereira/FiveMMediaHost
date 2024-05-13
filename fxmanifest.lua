fx_version 'adamant'
game 'gta5'
author 'Gaspar Pereira - Discord: gasparmpereira'
description 'Image Hosting Resource'
version '1.0.0'

files{
    'images/*.*'
}

shared_scripts{
    'config.lua'
}
server_scripts{
	'@mysql-async/lib/MySQL.lua',
    'server.lua'
}