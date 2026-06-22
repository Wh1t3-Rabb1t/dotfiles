local M = {}

function M.toggle(event)
    if event == hs.caffeinate.watcher.screensDidLock then
        hs.wifi.setPower(false)
    elseif event == hs.caffeinate.watcher.screensDidUnlock then
        hs.wifi.setPower(true)
    end
end

return M
