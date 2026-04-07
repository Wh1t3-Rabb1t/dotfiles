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
    { "Q", desc = " Start Recording" },
    { "q", desc = " Play Recording" },
}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    require("recorder").setup({
        mapping = {
            startStopRecording = "Q",
            playMacro = "q",
        },
        -- clear = true,  -- Clears all macros-slots on startup
        -- performanceOpts = {
        --     countThreshold = 100,
        --     lazyredraw = true,         -- Enable lazyredraw (see `:h lazyredraw`)
        --     noSystemClipboard = true,  -- Remove `+`/`*` from clipboard option
        --     autocmdEventsIgnore = {    -- Temporarily ignore these autocmd events
        --         "TextChangedI",
        --         "TextChanged",
        --         "InsertLeave",
        --         "InsertEnter",
        --         "InsertCharPre",
        --     }
        -- }
    })
end

return M
