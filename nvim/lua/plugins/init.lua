return {

    -- AUTOPAIRS
    ----------------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        dependencies = "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = require("plugin-configs.autopairs").config,
    },

    -- DIAL
    ----------------------------------------------------------------------------
    {
        "monaqa/dial.nvim",
        keys = require("plugin-configs.dial").keys,
        config = require("plugin-configs.dial").config,
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
    },


    -- SNACKS
    ----------------------------------------------------------------------------
    {
        "folke/snacks.nvim",

        enabled = true,

        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = false },
            dashboard = { enabled = false },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = false },
            notifier = {
                enabled = false,
                timeout = 3000,
            },
            picker = {
                enabled = true,

                finder = "explorer",
                sort = { fields = { "sort" } },
                supports_live = true,
                tree = true,
                watch = true,
                diagnostics = true,
                diagnostics_open = false,
                git_status = true,
                git_status_open = false,
                git_untracked = true,
                follow_file = true,
                focus = "list",
                auto_close = false,
                jump = { close = false },
                layout = { preset = "sidebar", preview = false, layout = { position = "right" } },
                -- to show the explorer to the right, add the below to
                -- your config under `opts.picker.sources.explorer`
                -- layout = { layout = { position = "right" } },
                formatters = {
                    file = { filename_only = true },
                    severity = { pos = "right" },
                },
                matcher = { sort_empty = false, fuzzy = false },
                win = {
                    list = {
                        keys = {
                            ["<BS>"] = "explorer_up",
                            ["l"] = "confirm",
                            ["h"] = "explorer_close", -- close directory
                            ["a"] = "explorer_add",
                            ["d"] = "explorer_del",
                            ["r"] = "explorer_rename",
                            ["c"] = "explorer_copy",
                            ["m"] = "explorer_move",
                            ["o"] = "explorer_open", -- open with system application
                            ["Q"] = "toggle_preview",
                            ["y"] = { "explorer_yank", mode = { "n", "x" } },
                            ["P"] = "explorer_paste",
                            ["u"] = "explorer_update",
                            ["<c-c>"] = "tcd",
                            ["<leader>/"] = "picker_grep",
                            ["<c-t>"] = "terminal",
                            ["."] = "explorer_focus",
                            ["I"] = "toggle_ignored",
                            ["H"] = "toggle_hidden",
                            ["Z"] = "explorer_close_all",
                            ["]g"] = "explorer_git_next",
                            ["[g"] = "explorer_git_prev",
                            ["]d"] = "explorer_diagnostic_next",
                            ["[d"] = "explorer_diagnostic_prev",
                            ["]w"] = "explorer_warn_next",
                            ["[w"] = "explorer_warn_prev",
                            ["]e"] = "explorer_error_next",
                            ["[e"] = "explorer_error_prev",
                        },
                    },
                },

            },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- Wrap notifications
                }
            }
        },

        keys = {
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

            { "<A-Right>", function() Snacks.explorer() end, desc = "File Explorer" },

            -- find
            { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
            { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
            { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
            { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
            -- git
            { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
            { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
            { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
            { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
            { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
            -- gh
            { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
            { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
            { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
            { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
            -- Grep
            { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
            { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
            -- search
            { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
            { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
            { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
            { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
            { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
            { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
            { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
            { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
            { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
            { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
            { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
            { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
            { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
            { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
            { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
            { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
            { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
            { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
            { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

            -- LSP
            -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
            -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
            -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
            { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

            -- Other
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
            { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
            { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
            { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
            { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
            { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
            { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
            { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
            { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
            {
                "<leader>N",
                desc = "Neovim News",
                function()
                    Snacks.win({
                        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                        width = 0.6,
                        height = 0.6,
                        wo = {
                            spell = false,
                            wrap = false,
                            signcolumn = "yes",
                            statuscolumn = " ",
                            conceallevel = 3,
                        },
                    })
                end,
            }
        },

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
    }

}
