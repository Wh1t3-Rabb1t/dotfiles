local M = {}

local cache       = require('cache')
local wifi        = require('wifi')
local screenshots = require('screenshots')


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    local watchers = cache.watchers

    -- Wifi toggling on screen lock/unlock
    watchers.wifi = hs.caffeinate.watcher.new(
        wifi.toggle_wifi_on_screenlock
    )

    -- Move screenshots automatically when taken
    watchers.screenshots = hs.pathwatcher.new(
        os.getenv('HOME') .. '/Desktop/',
        screenshots.move_screenshots
    )

    -- Start watchers
    for _, watcher in pairs(watchers) do
        watcher:start()
    end
end

return M
