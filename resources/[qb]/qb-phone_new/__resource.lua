resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    'client/main.lua',
    'client/animation.lua',
    '@qb-garages/SharedConfig.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    '@qb-garages/SharedConfig.lua',
    'config.lua',
}

files {
    'html/*',
    'html/js/*',
    'html/img/*',
    'html/css/*',
    'html/fonts/*',
    'html/img/backgrounds/*',
    'html/img/apps/*',
}