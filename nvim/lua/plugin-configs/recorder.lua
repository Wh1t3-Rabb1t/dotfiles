--                              _
--   _ __ ___  ___ ___  _ __ __| | ___ _ __
--  | '__/ _ \/ __/ _ \| '__/ _` |/ _ \ '__|
--  | | |  __/ (_| (_) | | | (_| |  __/ |
--  |_|  \___|\___\___/|_|  \__,_|\___|_|
-- =============================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    -- These must match the keys in the mapping config below
    { "M", desc = " Start Recording" },
    { "m", desc = " Play Recording" },
}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    require("recorder").setup({
        mapping = {
            startStopRecording = "M",
            playMacro = "m",
        },

        clear = true,  -- Clears all macros-slots on startup
        lessNotifications = false,
        useNerdfontIcons = true,

        -- Performance optimizations for macros with high count. When `playMacro` is
        -- triggered with a count higher than the threshold, nvim-recorder
        -- temporarily changes changes some settings for the duration of the macro.
        performanceOpts = {
            countThreshold = 100,
            lazyredraw = true,          -- Enable lazyredraw (see `:h lazyredraw`)
            noSystemClipboard = false,  -- Don't remove `+`/`*` from clipboard option
            autocmdEventsIgnore = {     -- Temporarily ignore these autocmd events
                "TextChangedI",
                "TextChanged",
                "InsertLeave",
                "InsertEnter",
                "InsertCharPre",
            }
        }

    })
end

return M
