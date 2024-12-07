--   _
--  | | __ _ _ __   __ _
--  | |/ _` | '_ \ / _` |
--  | | (_| | | | | (_| |
--  |_|\__,_|_| |_|\__, |
-- ================|___/========================================================

return {

    -- GARBAGE DAY
    ----------------------------------------------------------------------------
    {
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
        opts = {
            notifications = true,
            aggressive_mode = false,
        }
    },

    -- LINT
    ----------------------------------------------------------------------------
    {
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPre",
            "BufNewFile",
            "InsertLeave",
        },
        config = require("conf.lang.lint").config,
    },

    -- MASON
    ----------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                config = require("conf.lang.mason_tool_installer").config,
            }
        },
        config = require("conf.lang.mason").config,
    },

    -- MASON LSP CONFIG
    ----------------------------------------------------------------------------
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufEnter",
        config = true,
    },

    -- NVIM LSP CONFIG
    ----------------------------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        event = "BufEnter",
        config = require("conf.lang.nvim_lspconfig").config,
    },

    -- TREESITTER
    ----------------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = "RRethy/nvim-treesitter-textsubjects",
        event = "UiEnter",
        build = ":TSUpdate",
        config = require("conf.lang.treesitter").config,
    }
}
