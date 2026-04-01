--         _
--   _   _(_)
--  | | | | |
--  | |_| | |
--   \__,_|_|
-- =============================================================================

return {

    -- BARBAR
    ----------------------------------------------------------------------------
    {
        "romgrk/barbar.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = function()
            -- Restore tab order via session file if present
            if vim.tbl_contains(vim.v.argv, "-S") then
                return "SessionLoadPost"
            else
                return "VeryLazy"
            end
        end,
        keys = require("conf.ui.barbar").keys,
        config = require("conf.ui.barbar").config,
    },

    -- CATPPUCCIN
    ----------------------------------------------------------------------------
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = require("conf.ui.catppuccin").config,
    },

    -- LUALINE
    ----------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "UiEnter",
        config = require("conf.ui.lualine").config,
    },
}
