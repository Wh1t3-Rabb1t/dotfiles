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


    -- DIAL
    ----------------------------------------------------------------------------
    {
        "monaqa/dial.nvim",
        keys = require("conf.editor.dial").keys,
        config = require("conf.editor.dial").config,
    },

    -- SNACKS
    ----------------------------------------------------------------------------
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = require("conf.editor.snacks").opts,
        keys = require("conf.editor.snacks").keys,

        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end

                    -- Override print to use snacks for `:=` command
                    if vim.fn.has("nvim-0.11") == 1 then
                        vim._print = function(_, ...)
                            dd(...)
                        end
                    else
                        vim.print = _G.dd
                    end

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
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
}
