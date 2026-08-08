local M = {}

local state = require('state')


--------------------------------------------------------------------------------
-- Toggle wifi (on/off)
--------------------------------------------------------------------------------
function M.toggle_wifi()
    return function(done)
        local details = hs.wifi.interfaceDetails().power
        local power   = (details == false) and true  or false
        local status  = (power == false)   and 'off' or 'on'

        -- Toggle wifi and show alert
        hs.wifi.setPower(power)
        hs.alert.show('Turning wifi ' .. status)

        done()
    end
end


--------------------------------------------------------------------------------
-- Turn wifi on/off on screen lock/unlock
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

return M
