--         _             _         _       _ _
--   _ __ | |_   _  __ _(_)_ __   (_)_ __ (_) |_
--  | '_ \| | | | |/ _` | | '_ \  | | '_ \| | __|
--  | |_) | | |_| | (_| | | | | | | | | | | | |_
--  | .__/|_|\__,_|\__, |_|_| |_| |_|_| |_|_|\__|
-- =|_|============|___/========================================================

return {

    -- AUTOPAIRS
    ----------------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        dependencies = "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = require("plugin-configs.autopairs").config,
    },

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
        keys = require("plugin-configs.barbar").keys,
        config = require("plugin-configs.barbar").config,
    },

    -- CATPPUCCIN
    ----------------------------------------------------------------------------
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = require("plugin-configs.catppuccin").config,
    },

    -- CMP
    ----------------------------------------------------------------------------
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",                    -- Text in buffer
            "hrsh7th/cmp-path",                      -- File system paths
            "lukas-reineke/cmp-rg",                  -- Rg files in cwd
            "f3fora/cmp-spell",                      -- Spelling suggestions
            "hrsh7th/cmp-nvim-lsp",                  -- LSP completions
            "hrsh7th/cmp-nvim-lsp-signature-help",   -- LSP signatures
            "onsails/lspkind.nvim",                  -- vs-code like pictograms
            "saadparwaiz1/cmp_luasnip",              -- Luasnip cmp source
            {
                "L3MON4D3/LuaSnip",                  -- Snippet engine
                dependencies = {
                    "rafamadriz/friendly-snippets",  -- Friendly snippets
                    "hrsh7th/cmp-nvim-lua",          -- Nvim lua api
                }
            },
            {
                "hrsh7th/cmp-cmdline",               -- Command line completion
                keys = require("plugin-configs.cmp").cmd_line_keys,
                config = require("plugin-configs.cmp").cmd_line_config,
            }
        },
        config = require("plugin-configs.cmp").config,
    },

    -- DIAL
    ----------------------------------------------------------------------------
    {
        "monaqa/dial.nvim",
        keys = require("plugin-configs.dial").keys,
        config = require("plugin-configs.dial").config,
    },

    -- LUALINE
    ----------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "UiEnter",
        config = require("plugin-configs.lualine").config,
    },

    -- MASON
    ----------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        lazy = false,  -- Can't lazy load or lsp won't autostart (nvim v0.12)
        config = require("plugin-configs.mason").config,
    },

    -- RECORDER
    ----------------------------------------------------------------------------
    {
        "chrisgrieser/nvim-recorder",
        keys = require("plugin-configs.recorder").keys,
        config = require("plugin-configs.recorder").config,
    },

    -- SNACKS
    ----------------------------------------------------------------------------
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = require("plugin-configs.snacks").opts,
        keys = require("plugin-configs.snacks").keys,
        init = require("plugin-configs.snacks").init,
    },

    -- SPIDER
    ----------------------------------------------------------------------------
    {
        "chrisgrieser/nvim-spider",
        keys = require("plugin-configs.spider").keys,
        config = true,
    },

    -- SURROUND
    ----------------------------------------------------------------------------
    {
        "kylechui/nvim-surround",
        version = "*",  -- Use for stability. Use 'main' branch for latest features
        keys = require("plugin-configs.surround").keys,
        config = require("plugin-configs.surround").config,
    },

    -- TRAILBLAZER
    ----------------------------------------------------------------------------
    {
        "LeonHeidelbach/trailblazer.nvim",
        keys = require("plugin-configs.trailblazer").keys,
        config = require("plugin-configs.trailblazer").config,
    },

    -- TREESITTER
    ----------------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        event = "UiEnter",
        build = ":TSUpdate",
    },

    -- WHICH KEY
    ----------------------------------------------------------------------------
    -- {
    --     "folke/which-key.nvim",
    --     enabled = false,
    --     event = "VeryLazy",
    --     opts = {},
    -- }

}
