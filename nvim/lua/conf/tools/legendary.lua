--   _                           _
--  | | ___  __ _  ___ _ __   __| | __ _ _ __ _   _
--  | |/ _ \/ _` |/ _ \ '_ \ / _` |/ _` | '__| | | |
--  | |  __/ (_| |  __/ | | | (_| | (_| | |  | |_| |
--  |_|\___|\__, |\___|_| |_|\__,_|\__,_|_|   \__, |
-- =========|___/=============================|___/=============================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    prompt = "LGD  ",
    col_separator_char = "│",
    command = "",
    fn = "󰡱",
    itemgroup = "",
}


-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        mode = { "n", "v" },
        "p",
        function()
            require("legendary").find({
                itemgroup = "Commands & Functions"
            })
        end,
        desc = "LGD cmds & funcs"
    },
    {
        mode = { "n", "v" },
        "P",
        function()
            require("legendary").find({
                filters = { require("legendary.filters").current_mode() }
            })
        end,
        desc = "LGD kb"
    },
    {
        mode = { "n", "v" },
        "<Leader>p",
        "<cmd>LegendaryRepeat<CR>",
        desc = "LGD repeat cmd"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "legendary")
    if not status_ok then return end

    -- Setup
    local util = require("util.utils")
    local win = require("util.window")
    require("legendary").setup({
        keymaps = {

            -- Logging in cwd
            --------------------------------------------------------------------
            {
                mode = { "n" },
                "gl",
                function()
                    -- Check if log_generate.zsh exists and is executable
                    if vim.fn.filereadable("./log_generate.zsh") == 0 then
                        vim.notify("Error: 'log_generate.zsh' not found", vim.log.levels.ERROR)
                        return
                    elseif vim.fn.executable("./log_generate.zsh") == 0 then
                        vim.notify("Error: 'log_generate.zsh' is not executable", vim.log.levels.ERROR)
                        return
                    end

                    -- Create log file if not present
                    if vim.fn.filereadable("./log.zsh") == 0 then
                        vim.fn.writefile({}, "./log.zsh")
                    end

                    vim.cmd("silent !./log_generate.zsh")
                end,
                desc = " Write to log file in cwd"
            },

            -- Spelling
            --------------------------------------------------------------------
            {
                mode = { "n" },
                "gs",
                "]s",
                desc = " Go to next MISSPELLED word"
            },
            {
                mode = { "n" },
                "zg",
                "zg",
                desc = " Mark MISSPELLED word as correctly spelled"
            },

            -- Folds
            --------------------------------------------------------------------
            {
                mode = { "v" },
                "zf",
                "zf",
                desc = " FOLD selection"
            },
            {
                mode = { "n" },
                "za",
                "za",
                desc = " Toggle FOLD under cursor"
            },
            {
                mode = { "n" },
                "zR",
                "zR",
                desc = " Open all FOLDS"
            },
            {
                mode = { "n" },
                "zM",
                "zM",
                desc = " Close all FOLDS"
            },
            {
                mode = { "n" },
                "zd",
                "zD",
                desc = " Delete FOLD under cursor"
            },

            -- Misc
            --------------------------------------------------------------------
            {
                mode = { "v" },
                "=+",
                "g<C-a>gv",
                desc = " Increment numbers sequentially"
            },
            {
                mode = { "v" },
                "=-",
                "g<C-x>gv",
                desc = " Decrement numbers sequentially"
            },
            {
                mode = { "n" },
                "ga",
                "ga",
                desc = " Ascii value of char in decimal, hex, and octal"
            },
            {
                mode = { "n" },
                "g8",
                "g8",
                desc = " Byte sequence for char under cursor in hex (utf-8)"
            }
        },

        -- Can also be a function that returns the list
        commands = {},
        autocmds = {},
        funcs = {},

        -- Initial item groups to bind, note that item groups can also
        -- be under keymaps, commands, autocmds, or funcs;
        -- can also be a function that returns the list.
        itemgroups = {
            {
                itemgroup = 'Commands & Functions',
                description = 'Cmds & Funcs',
                icon = '',
                commands = {

                    -- Fidget
                    --------------------------------------------------------------------
                    {
                        "<cmd>Fidget clear<CR>",
                        desc = " CLEAR active notifications"
                    },
                    {
                        "<cmd>Fidget clear_history<CR>",
                        desc = " CLEAR notifications history"
                    },
                    {
                        "<cmd>Fidget history<CR>",
                        desc = " SHOW notifications history"
                    },
                    {
                        "<cmd>Fidget lsp_suppress<CR>",
                        desc = " SUPPRESS LSP progress notifications"
                    },
                    {
                        "<cmd>Fidget suppress<CR>",
                        desc = " SUPPRESS notification window"
                    },

                    -- Glance
                    --------------------------------------------------------------------
                    {
                        "<cmd>Glance references<CR>",
                        desc = " Glance LSP references"
                    },
                    {
                        "<cmd>Glance definitions<CR>",
                        desc = " Glance LSP definitions"
                    },
                    {
                        "<cmd>Glance type_definitions<CR>",
                        desc = " Glance LSP type definitions"
                    },
                    {
                        "<cmd>Glance implementations<CR>",
                        desc = " Glance LSP implementations"
                    },

                    -- Highlight colors
                    --------------------------------------------------------------------
                    {
                        "<cmd>HighlightColors On<CR>",
                        desc = " Color highlights ON"
                    },
                    {
                        "<cmd>HighlightColors Off<CR>",
                        desc = " Color highlights OFF"
                    },

                    -- Splits layout
                    --------------------------------------------------------------------
                    {
                        "<cmd>windo wincmd H<CR>",
                        desc = " Set splits layout to VERTICAL"
                    },
                    {
                        "<cmd>windo wincmd K<CR>",
                        desc = " Set splits layout to HORIZONTAL"
                    },

                    -- Highlight cursor column
                    --------------------------------------------------------------------
                    {
                        "<cmd>set colorcolumn=80<CR>",
                        desc = " Set highlight at 80th column"
                    },
                    {
                        '<cmd>set colorcolumn=""<CR>',
                        desc = " Disable highlight at 80th column"
                    },

                    -- Misc
                    --------------------------------------------------------------------
                    {
                        "<cmd>bo checkhealth<CR>",
                        desc = "󰓙 Checkhealth"
                    },
                    {
                        "<cmd>bo checkhealth lspconfig<CR>",
                        desc = "󰓙 LSP info"
                    },
                    {
                        "<cmd>LintInfo<CR>",
                        desc = "󰓙 Lint info"
                    },
                    {
                        "<cmd>Lazy<CR>",
                        desc = "󰒲 Lazy UI"
                    },
                    {
                        "<cmd>Mason<CR>",
                        desc = " Mason UI"
                    },
                    {
                        "<cmd>ConformInfo<CR>",
                        desc = " Conform info"
                    },
                    {
                        "<cmd>Format<CR>",
                        desc = " Format buffer"
                    },
                    {
                        "<cmd>ClearNeoComposer<CR>",
                        desc = " Clear NeoComposer macros"
                    },
                    {
                        "<cmd>RenderMarkdown toggle<CR>",
                        desc = " Toggle markdown rendering"
                    },
                    {
                        "<cmd>LegendaryFrecencyReset<CR>",
                        desc = " Reset Legendary frecency cache"
                    }

                },
                funcs = {

                    -- Options toggling
                    --------------------------------------------------------------------
                    {
                        function()
                            vim.opt.cursorcolumn = not vim.opt.cursorcolumn._value
                        end,
                        desc = " Toggle cursor column highlight"
                    },
                    {
                        function() vim.opt.wrap = not vim.opt.wrap._value end,
                        desc = " Toggle line WRAP"
                    },
                    {
                        function() vim.opt.spell = not vim.opt.spell._value end,
                        desc = " Toggle incorrect spelling highlights"
                    },
                    {
                        function()
                            local fc_state = vim.opt.foldclose._value
                            if fc_state == "all" then
                                vim.opt.foldclose = ""
                            else
                                vim.opt.foldclose = "all"
                            end
                        end,
                        desc = " Toggle FOLDS auto closing when UNFOCUSED"
                    },

                    -- Misc
                    --------------------------------------------------------------------
                    {
                        function()
                            win.cleanup_windows()
                            vim.cmd("Mksession!")
                            print("Session saved: " .. os.date())
                        end,
                        desc = " Session save"
                    },
                    {
                        function()
                            vim.o.cmdheight = vim.o.cmdheight + 10
                            vim.cmd("redraw!")
                        end,
                        desc = " Enlarge command line window"
                    },
                    {
                        function() util.cleanup_alphabetical_registers() end,
                        desc = " Clear alphabetical register stack"
                    },
                    {
                        function() util.cleanup_numeric_registers() end,
                        desc = " Clear numeric register stack"
                    }
                }
            }
        },

        -- Default opts to merge with the `opts` table
        default_opts = {
            keymaps = {
                silent = true,
                noremap = true,
            },
            commands = {},  -- e.g, { args = '?', bang = true }
            autocmds = {},  -- e.g, { buf = 0, once = true }
        },

        -- Customize prompt
        select_prompt = icons.prompt,

        -- Character to use to separate columns in the UI
        col_separator_char = icons.col_separator_char,
        default_item_formatter = nil,

        -- Customize icons used by the default item formatter
        icons = {
            keymap = nil,
            command = icons.command,
            fn = icons.fn,
            itemgroup = icons.itemgroup,
        },

        include_builtin = false,         -- Include builtins by default
        include_legendary_cmds = false,  -- Include legendary.nvim commands

        -- Sorting options
        sort = {
            most_recent_first = true,
            user_items_first = true,  -- Sort user-defined items before built-in items
            item_type_bias = nil,     -- Must be: 'keymap', 'command', 'autocmd', 'group', nil.
            frecency = {              -- NOTE: THIS TAKES PRECEDENCE OVER OTHER SORT OPTIONS!
                db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
                max_timestamps = 10,  -- Max timestamps for a single item
            }
        },

        -- Auto register keymaps that are defined by lazy with 'keys'
        lazy_nvim = {
            auto_register = true
        },

        -- Which extensions to load; no extensions are loaded by default
        extensions = {
            lazy_nvim = true,
            nvim_tree = false,
            smart_splits = false,
            op_nvim = false,
            diffview = false,
        },

        -- Temp buffer (scratchpad)
        scratchpad = {
            view = "float",
            results_view = "float",  -- How to show results of evaluated Lua code
            float_border = "rounded",
            keep_contents = false,   -- Restore scratchpad contents from cache
        },

        -- Directory used for caches
        cache_path = string.format("%s/legendary/", vim.fn.stdpath("cache")),
        log_level = "info",  -- Use `vim.log.levels`
    })
end

return M
