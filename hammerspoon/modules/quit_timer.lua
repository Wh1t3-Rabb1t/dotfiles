local M = {}

local cmdQDelay = 0.75
local cmdQTimer = nil
local cmdQAlert = nil

local function cmdQCleanup()
    hs.alert.closeSpecific(cmdQAlert)
    cmdQTimer = nil
    cmdQAlert = nil
end

function M.stopCmdQ()
    if cmdQTimer then
        cmdQTimer:stop()
        cmdQCleanup()
        hs.alert('Cancelled', 0.5)
    end
end

function M.startCmdQ()
    local app = hs.application.frontmostApplication()
    cmdQTimer = hs.timer.doAfter(cmdQDelay, function() app:kill(); cmdQCleanup() end)
    cmdQAlert = hs.alert('Hold to Quit: ' .. app:name(), true)
end

return M
