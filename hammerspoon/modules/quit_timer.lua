local M = {}

local cmd_q_delay = 0.75
local cmd_q_timer = false
local cmd_q_alert = false


-- Cleanup
--------------------------------------------------------------------------------
local function cmd_q_cleanup()
    hs.alert.closeSpecific(cmd_q_alert)
    cmd_q_timer = false
    cmd_q_alert = false
end


-- Stop quit timer
--------------------------------------------------------------------------------
local function stop_cmd_q()
    if cmd_q_timer then
        cmd_q_timer:stop()
        cmd_q_cleanup()
        hs.alert('Cancelled', 0.5)
    end
end


-- Start quit timer
--------------------------------------------------------------------------------
local function start_cmd_q()
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
    hs.hotkey.bind({'cmd'}, 'q',
        start_cmd_q,
        stop_cmd_q
    )
end

return M
