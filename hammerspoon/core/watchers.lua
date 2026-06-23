local auto_reload = require('auto_reload')
local wifi = require('wifi')

local hs_dir = os.getenv('HOME') .. '/.local/dotfiles/hammerspoon/'

-- Auto reloads HS configuration on document save
local conf_watcher = hs.pathwatcher.new(hs_dir, auto_reload.hs_config)

-- Toggle wifi on/off when locking screen
local wifi_watcher= hs.caffeinate.watcher.new(wifi.toggle)

-- Start watchers
conf_watcher:start()
wifi_watcher:start()
