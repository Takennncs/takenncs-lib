fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'takenncs Context Menu'
version '1.0.0'

ui_page 'html/index.html'

client_scripts {
    'client/main.lua',
    'client/events.lua'
}

server_scripts {
    'server/main.lua',
    'version_check.lua'
}

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}


lua54 'yes'
