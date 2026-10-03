local M = {}

local screens   = require('screens')
local apps      = require('apps')
local windows   = require('windows')
local wk_assets = require('which_key_assets')
local wk        = require('which_key')
local qt        = require('quit_timer')

local keys = {
    {
        -- Hot reload hammerspoon
        key    = 'r', mods = { 'ctrl', 'shift' },
        action = function()
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
            -- Init fns must be called in the following order:
            screens.init()
            apps.init()
            windows.init()
            wk_assets.init()
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
