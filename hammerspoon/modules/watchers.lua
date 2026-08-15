local M = {}

local cache       = require('cache')
local wifi        = require('wifi')
local screenshots = require('screenshots')


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    local home = os.getenv('HOME')

    -- Wifi toggling on screen lock/unlock
    cache.watchers.wifi = hs.caffeinate.watcher.new(
        wifi.toggle_wifi_on_screenlock
    )

    -- Move screenshots automatically when taken
    cache.watchers.screenshots = hs.pathwatcher.new(
        home .. '/Desktop/',
        screenshots.move_screenshots
    )

    -- Start watchers
    for _, watcher in pairs(cache.watchers) do
        watcher:start()
    end
end

return M
