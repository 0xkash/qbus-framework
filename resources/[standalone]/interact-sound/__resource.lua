-- Manifest Version
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
files {
    'client/html/index.html',
    'client/html/sounds/demo.ogg',
    'client/html/sounds/houses_door_close.ogg',
    'client/html/sounds/houses_door_open.ogg',
    'client/html/sounds/houses_door_lock.ogg',
    'client/html/sounds/houses_door_unlock.ogg',
    'client/html/sounds/carbuckle.ogg',
    'client/html/sounds/carunbuckle.ogg',
    'client/html/sounds/lock.ogg',
    'client/html/sounds/unlock.ogg',
}
