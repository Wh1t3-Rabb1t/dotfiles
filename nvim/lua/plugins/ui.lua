--         _
--   _   _(_)
--  | | | | |
--  | |_| | |
--   \__,_|_|
-- =============================================================================

return {

    -- AERIAL
    ----------------------------------------------------------------------------
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "AerialOpen",
        init = require("conf.ui.aerial").init,
        config = require("conf.ui.aerial").config,
    },

    -- BARBAR
    ----------------------------------------------------------------------------
    {
        "romgrk/barbar.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = function()  -- Restore tab order via session file if present
            if vim.tbl_contains(vim.v.argv, "-S") then
                return "SessionLoadPost"
            else
                return "VeryLazy"
            end
        end,
        init = require("conf.ui.barbar").init,
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

    -- DROPBAR
    ----------------------------------------------------------------------------
    {
        "Bekaboo/dropbar.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        keys = require("conf.ui.dropbar").keys,
        config = require("conf.ui.dropbar").config,
    },

    -- FIDGET
    ----------------------------------------------------------------------------
    {
        "j-hui/fidget.nvim",
        event = "UiEnter",
        config = require("conf.ui.fidget").config,
    },

    -- GITSIGNS
    ----------------------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        event = "UiEnter",
        config = require("conf.ui.gitsigns").config,
    },

    -- GLANCE
    ----------------------------------------------------------------------------
    {
        "dnlhc/glance.nvim",
        cmd = "Glance",
        config = require("conf.ui.glance").config,
    },

    -- HIGHLIGHT COLORS
    ----------------------------------------------------------------------------
    {
        "brenoprata10/nvim-highlight-colors",
        cmd = "HighlightColors",
        config = require("conf.ui.highlight_colors").config,
    },

    -- IBL
    ----------------------------------------------------------------------------
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "UiEnter",
        config = require("conf.ui.ibl").config,
    },

    -- LUALINE
    ----------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "UiEnter",
        config = require("conf.ui.lualine").config,
    },

    -- NEOTREE
    ----------------------------------------------------------------------------
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = require("conf.ui.neotree").keys,
        config = require("conf.ui.neotree").config,
    },

    -- STCURSORWORD
    ----------------------------------------------------------------------------
    {
        "sontungexpt/stcursorword",
        cmd = "Cursorword toggle",
        config = require("conf.ui.stcursorword").config,
    }
}
