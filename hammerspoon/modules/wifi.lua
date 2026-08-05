local M = {}

local cache = require('cache')
local state = require('state')


-- Set wifi status (on/off)
--------------------------------------------------------------------------------
function M.toggle_wifi()
    return function(done)
        local power  = (state.system.wifi == false) and true or false
        local status = (power == false) and 'off' or 'on'

        hs.wifi.setPower(power)
        state.system.wifi = power

        hs.alert.show('Turning wifi: ' .. status)

        done()
    end
end


-- Toggle wifi on/off on screen lock/unlock
--------------------------------------------------------------------------------
function M.toggle_wifi_on_screenlock(event)
    if event == hs.caffeinate.watcher.screensDidLock then
        hs.wifi.setPower(false)
        state.system.wifi = false
    elseif event == hs.caffeinate.watcher.screensDidUnlock then
        hs.wifi.setPower(true)
        state.system.wifi = true
    end
end

-- Init
--------------------------------------------------------------------------------
function M.init()
    cache.watchers.wifi = hs.caffeinate.watcher.new(
        M.toggle_wifi_on_screenlock
    )
    cache.watchers.wifi:start()
end

return M
