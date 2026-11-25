local M = {}

local wk = require('wk')
local qt = require('quit_timer')
local mouse = require('mouse')
local jg = require('jump_grids')

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

    -- {
    --     -- Which key launcher
    --     key       = 'a', mods = { 'ctrl' },
    --     action    = function() wk.launch() end,
    --     on_key_up = function() wk.quit()() end,
    -- },

    {
        -- Which key launcher
        key    = 'space', mods = { 'cmd', 'ctrl', 'alt', 'shift' },
        action = function()
            wk.launch()
        end,
    },

    {
        -- Which key launcher
        key    = 'a', mods = { 'ctrl' },
        action = function()
            mouse.launch()
        end,
    },


    -- ----------------------------------------------------------------------------
    -- {   -- Jump grid testing
    --     key       = 'a', mods = { 'ctrl' },
    --     action    = function() jg.show()() end,
    --     on_key_up = function() jg.hide()() end,
    -- },
    -- {   -- Jump grid testing
    --     key       = 's', mods = { 'ctrl' },
    --     action    = function() jg.show('w')() end,
    --     on_key_up = function() jg.hide()() end,
    -- },
    -- ----------------------------------------------------------------------------

}


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    for _, v in ipairs(keys) do
        local key_up = v.on_key_up or nil

        hs.hotkey.bind(v.mods, v.key, v.action, key_up)
    end
end

return M
