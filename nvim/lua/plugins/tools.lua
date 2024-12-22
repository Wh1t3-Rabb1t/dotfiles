--   _              _
--  | |_ ___   ___ | |___
--  | __/ _ \ / _ \| / __|
--  | || (_) | (_) | \__ \
--   \__\___/ \___/|_|___/
-- =============================================================================

return {

    -- BQF
    ----------------------------------------------------------------------------
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        dependencies = "junegunn/fzf",
        config = require("conf.tools.bqf").config,
    },

    -- CONFORM
    ----------------------------------------------------------------------------
    {
        "stevearc/conform.nvim",
        cmd = {
            "Format",
            "Conform",
            "ConformInfo",
        },
        config = require("conf.tools.conform").config,
    },

    -- FZF LUA
    ----------------------------------------------------------------------------
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = require("conf.tools.fzf_lua").keys,
        config = require("conf.tools.fzf_lua").config,
    },

    -- GRAPPLE
    ----------------------------------------------------------------------------
    {
        "cbochs/grapple.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = { scope = "git" },  -- Also try out "git_branch"
        cmd = "Grapple",
        keys = require("conf.tools.grapple").keys,
        config = require("conf.tools.grapple").config,
    },

    -- LEGENDARY
    ----------------------------------------------------------------------------
    {
        "mrjones2014/legendary.nvim",
        dependencies = {
            "kkharji/sqlite.lua",  -- sqlite is required for frecency sorting
            "ibhagwan/fzf-lua",
        },
        event = "UiEnter",
        keys = require("conf.tools.legendary").keys,
        config = require("conf.tools.legendary").config,
    },

    -- QUICKER
    ----------------------------------------------------------------------------
    {
        "stevearc/quicker.nvim",
        ft = "qf",
        config = require("conf.tools.quicker").config,
    },

    -- RENDER MARKDOWN
    ----------------------------------------------------------------------------
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = "markdown",
        config = require("conf.tools.render_markdown").config,
    },

    -- RIP SUBSTITUTE
    ----------------------------------------------------------------------------
    {
        "chrisgrieser/nvim-rip-substitute",
        cmd = "RipSubstitute",
        keys = require("conf.tools.rip_substitute").keys,
        config = require("conf.tools.rip_substitute").config,
    }
}
