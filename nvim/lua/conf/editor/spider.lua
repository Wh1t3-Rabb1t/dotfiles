--             _     _
--   ___ _ __ (_) __| | ___ _ __
--  / __| '_ \| |/ _` |/ _ \ '__|
--  \__ \ |_) | | (_| |  __/ |
--  |___/ .__/|_|\__,_|\___|_|
-- =====|_|=====================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        mode = { "n", "v", "o" },
        "o",
        "<cmd>lua require('spider').motion('w')<CR>",
        desc = " Forward word"
    },
    {
        mode = { "n", "v", "o" },
        "u",
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = " Backward word"
    },
    {
        mode = { "n", "v", "o" },
        "O",
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = " Forward word end"
    },
    {
        mode = { "n", "v", "o" },
        "U",
        "<cmd>lua require('spider').motion('ge')<CR>",
        desc = " Backward word end"
    }
}

return M
