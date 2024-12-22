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
        desc = "Jump forward by word"
    },
    {
        mode = { "n", "v", "o" },
        "u",
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = "Jump backward by word"
    },
    {
        mode = { "n", "v", "o" },
        "O",
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = "Jump forward to word end"
    },
    {
        mode = { "n", "v", "o" },
        "U",
        "<cmd>lua require('spider').motion('ge')<CR>",
        desc = "Jump backward to word end"
    }
}

return M
