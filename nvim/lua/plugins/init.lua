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
        version = "^1.0.0",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = require("plugin-configs.barbar").event,
        keys = require("plugin-configs.barbar").keys,
        config = require("plugin-configs.barbar").config,
    },

    -- CATPPUCCIN
    ----------------------------------------------------------------------------
    {
        "catppuccin/nvim",
        version = "^2.0.0",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = require("plugin-configs.catppuccin").config,
    },

    -- CMP
    ----------------------------------------------------------------------------
    {
        "hrsh7th/nvim-cmp",
        version = "^0.0.0",
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
                -- Snippet engine
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",  -- Friendly snippets
                    "hrsh7th/cmp-nvim-lua",          -- Nvim lua api
                }
            },
            {
                -- Command line completion
                "hrsh7th/cmp-cmdline",
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
        version = "^0.0.0",
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
        version = "^2.0.0",
        cmd = "Mason",
        config = require("plugin-configs.mason").config,
    },

    -- RECORDER
    ----------------------------------------------------------------------------
    {
        "chrisgrieser/nvim-recorder",
        keys = require("plugin-configs.recorder").keys,
        config = require("plugin-configs.recorder").config,
    },

    -- RIP SUBSTITUTE
    ----------------------------------------------------------------------------
    {
        "chrisgrieser/nvim-rip-substitute",
        cmd = "RipSubstitute",
        keys = require("plugin-configs.rip_substitute").keys,
        config = require("plugin-configs.rip_substitute").config,
    },

    -- SNACKS
    ----------------------------------------------------------------------------
    {
        "folke/snacks.nvim",
        version = "^2.0.0",
        priority = 1000,
        lazy = false,
        opts = require("plugin-configs.snacks").opts,
        keys = require("plugin-configs.snacks").keys,
        init = require("plugin-configs.snacks").init,
    },

    -- SURROUND
    ----------------------------------------------------------------------------
    {
        "kylechui/nvim-surround",
        version = "^4.0.0",
        keys = require("plugin-configs.surround").keys,
        config = require("plugin-configs.surround").config,
    },

    -- TREESITTER
    ----------------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        event = "UiEnter",
        build = ":TSUpdate",
    },
}
