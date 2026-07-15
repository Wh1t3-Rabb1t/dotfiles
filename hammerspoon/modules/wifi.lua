local M = {}

local cache = require('cache')

-- Toggle wifi on/off on screen lock/unlock
--------------------------------------------------------------------------------
function M.toggle_wifi(event)
    if event == hs.caffeinate.watcher.screensDidLock then
        hs.wifi.setPower(false)
    elseif event == hs.caffeinate.watcher.screensDidUnlock then
        hs.wifi.setPower(true)
    end
end

-- Init
--------------------------------------------------------------------------------
function M.init()
    cache.watchers.wifi = hs.caffeinate.watcher.new(M.toggle_wifi)
    cache.watchers.wifi:start()
end

return M
