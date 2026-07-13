local M = {}

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
    local wifi_watcher = hs.caffeinate.watcher.new(M.toggle_wifi)
    wifi_watcher:start()
end

return M
