--            _ _ _
--    ___  __| (_) |_ ___  _ __
--   / _ \/ _` | | __/ _ \| '__|
--  |  __/ (_| | | || (_) | |
--   \___|\__,_|_|\__\___/|_|
-- =============================================================================

return {

    -- AUTOPAIRS
    ----------------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        dependencies = "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = require("conf.editor.autopairs").config,
    },

    -- COMMENT
    ----------------------------------------------------------------------------
    {
        "numToStr/Comment.nvim",
        keys = require("conf.editor.comment").keys,
        opts = require("conf.editor.comment").opts,
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
                keys = require("conf.editor.cmp").cmd_line_keys,
                config = require("conf.editor.cmp").cmd_line_config,
            }
        },
        config = require("conf.editor.cmp").config,
    },

    -- DIAL
    ----------------------------------------------------------------------------
    {
        "monaqa/dial.nvim",
        init = require("conf.editor.dial").init,
        config = require("conf.editor.dial").config,
    },

    -- HOP
    ----------------------------------------------------------------------------
    {
        "smoka7/hop.nvim",
        version = "*",
        keys = require("conf.editor.hop").keys,
        config = require("conf.editor.hop").config,
    },

    -- NEOCOMPOSER
    ----------------------------------------------------------------------------
    {
        "ecthelionvi/NeoComposer.nvim",
        dependencies = "kkharji/sqlite.lua",
        cmd = "ClearNeoComposer",  -- Allow Legendary to call if not loaded
        keys = require("conf.editor.neocomposer").keys,
        config = require("conf.editor.neocomposer").config,
    },

    -- SPIDER
    ----------------------------------------------------------------------------
    {
        "chrisgrieser/nvim-spider",
        keys = require("conf.editor.spider").keys,
        config = true,
    },

    -- SURROUND
    ----------------------------------------------------------------------------
    {
        "kylechui/nvim-surround",
        version = "*",  -- Use for stability. Use 'main' branch for latest features
        keys = require("conf.editor.surround").keys,
        config = require("conf.editor.surround").config,
    },

    -- TRAILBLAZER
    ----------------------------------------------------------------------------
    {
        "LeonHeidelbach/trailblazer.nvim",
        keys = require("conf.editor.trailblazer").keys,
        config = require("conf.editor.trailblazer").config,
    }
}
