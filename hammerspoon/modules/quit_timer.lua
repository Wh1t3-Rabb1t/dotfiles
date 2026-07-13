local M = {}

local cmd_q_delay = 0.75
local cmd_q_timer = false
local cmd_q_alert = false

local function cmd_q_cleanup()
    hs.alert.closeSpecific(cmd_q_alert)
    cmd_q_timer = false
    cmd_q_alert = false
end


-- Stop quit timer
--------------------------------------------------------------------------------
function M.stop_cmd_q()
    if cmd_q_timer then
        cmd_q_timer:stop()
        cmd_q_cleanup()
        hs.alert('Cancelled', 0.5)
    end
end


-- Start quit timer
--------------------------------------------------------------------------------
function M.start_cmd_q()
    local app = hs.application.frontmostApplication()
    cmd_q_timer = hs.timer.doAfter(
        cmd_q_delay,
        function()
            app:kill()
            cmd_q_cleanup()
        end
    )
    cmd_q_alert = hs.alert('Hold to Quit: ' .. app:name(), true)
end


-- Init
--------------------------------------------------------------------------------
function M.init()
    hs.hotkey.bind({ 'cmd' }, 'q', M.start_cmd_q, M.stop_cmd_q)
end

return M
