local M = {}

local wifi        = require('wifi')
local screenshots = require('screenshots')

M.watchers = {}


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    local watchers = M.watchers

    -- Wifi toggling on screen lock/unlock
    watchers.wifi = hs.caffeinate.watcher.new(
        wifi.toggle_wifi_on_screenlock
    )

    -- Move screenshots automatically when taken
    watchers.screenshots = hs.pathwatcher.new(
        os.getenv('HOME') .. '/Desktop/',
        screenshots.move_screenshots
    )

    -- Move screenshots automatically when taken
    watchers.apps = hs.pathwatcher.new(
        os.getenv('HOME') .. '/Desktop/',
        screenshots.move_screenshots
    )

    for _, watcher in pairs(watchers) do
        watcher:start()
    end
end

return M
