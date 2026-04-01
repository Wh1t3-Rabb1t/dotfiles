--   _
--  | | __ _ _ __   __ _
--  | |/ _` | '_ \ / _` |
--  | | (_| | | | | (_| |
--  |_|\__,_|_| |_|\__, |
-- ================|___/========================================================

return {

    -- MASON
    ----------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        event = "BufEnter",
        opts = {},
        -- config = require("conf.lang.mason").config,
    },

    -- TREESITTER
    ----------------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        event = "UiEnter",
        build = ":TSUpdate",
        -- config = require("conf.lang.treesitter").config,
    },
}
