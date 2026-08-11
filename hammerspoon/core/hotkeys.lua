local M = {}

local bootstrap = require('bootstrap')
local win       = require('windows')
local qt        = require('quit_timer')
local wk        = require('which_key')

local keys = {
    {
        -- Hot reload hammerspoon
        key       = 'r', mods = { 'ctrl', 'shift' },
        action    = function()
            hs.reload()
        end,
    },
    {
        -- Quit app timer
        key       = 'q', mods = { 'cmd' },
        action    = qt.start_cmd_q,
        on_key_up = qt.stop_cmd_q,
    },
    {
        -- Which key launcher
        key    = 'space', mods = { 'cmd', 'ctrl', 'alt', 'shift' },
        action = function()
            bootstrap.init()
            win.init()
            wk.launch()
        end,
    },
}


-- Init
--------------------------------------------------------------------------------
function M.init()
    for _, v in ipairs(keys) do
        local key_up = v.on_key_up or nil

        hs.hotkey.bind(v.mods, v.key, v.action, key_up)
    end
end

return M
