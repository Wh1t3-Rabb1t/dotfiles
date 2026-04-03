--                        _
--   ___ _ __   __ _  ___| | _____
--  / __| '_ \ / _` |/ __| |/ / __|
--  \__ \ | | | (_| | (__|   <\__ \
--  |___/_| |_|\__,_|\___|_|\_\___/
-- =============================================================================

local M = {}

-- OPTS
--------------------------------------------------------------------------------
M.opts = {
    -- Disabled
    dashboard = { enabled = false },
    input = { enabled = false },
    bigfile = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    words = { enabled = false },
    scroll = { enabled = false },

    -- Enabled
    explorer = { enabled = true },
    notifier = { enabled = true },
    statuscolumn = { enabled = true },
    git = { enabled = true },

    styles = {
        notification = {
            -- wo = { wrap = true }  -- Wrap notifications
        }
    },

    -- PICKER CONFIG
    -- (source "snacks.nvim/lua/snacks/picker/config/defaults.lua")
    picker = {
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
        focus = "input",    -- input, list
        auto_close = true,  -- 'true' is required to prevent window hanging on select
        jump = { close = false },

        -- To show the explorer to the right, add the below to
        -- your config under `opts.picker.sources.explorer`
        -- layout = { layout = { position = "right" } },
        layout = { preview = true },  -- layout = { preset = "sidebar", preview = false },

        -- Set explorer only to the right side panel
        sources = {
            explorer = {
                layout = { layout = { position = "right" } },
            }
        },
        formatters = {
            file = { filename_only = true },
            severity = { pos = "right" },
        },
        matcher = { sort_empty = false, fuzzy = false },
        win = {
            -- Input window
            input = {
                -- To close the picker on ESC instead of going to normal mode,
                -- add the following keymap to your config.
                -- ["<Esc>"] = { "close", mode = { "n", "i" } },
                keys = {
                    -- TODO: find a good mapping for these ...
                    ["<A-h>"]         = { "toggle_hidden",       mode = { "i", "n" } },
                    ["<A-i>"]         = { "toggle_ignored",      mode = { "i", "n" } },
                    -- ...
                    ["<Esc>"]         = { "close",               mode = { "i", "n" } },
                    ["<Tab>"]         = { "cycle_win",           mode = { "i", "n" } },
                    ["<CR>"]          = { "confirm",             mode = { "i", "n" } },
                    ["<Up>"]          = { "list_up",             mode = { "i", "n" } },
                    ["<Down>"]        = { "list_down",           mode = { "i", "n" } },
                    ["<S-Up>"]        = { "select_and_prev",     mode = { "i", "n" } },
                    ["<S-Down>"]      = { "select_and_next",     mode = { "i", "n" } },
                    ["<A-a>"]         = { "select_all",          mode = { "i", "n" } },
                    ["<Page-Up>"]     = { "list_scroll_up",      mode = { "i", "n" } },
                    ["<Page-Down>"]   = { "list_scroll_down",    mode = { "i", "n" } },
                    ["<S-Page-Up>"]   = { "preview_scroll_up",   mode = { "i", "n" } },
                    ["<S-Page-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    ["<A-f>"]         = { "qflist",              mode = { "i", "n" } },
                    ["<A-p>"]         = { "toggle_preview",      mode = { "i", "n" } },
                    ["<A-/>"]         = { "toggle_help_input",   mode = { "i", "n" } },
                    ["<A-r>"]         = { "toggle_regex",        mode = { "i", "n" } },
                    ["<A-/>"]         = { "toggle_help_input",   mode = { "i", "n" } },

                    -- Insert only
                    ["<C-c>"]  = { "cancel",  mode = "i" },
                    ["<A-BS>"] = { "<c-s-w>", mode = "i", expr = true, desc = "delete word" },

                    -- Unset default bindings
                    ["<A-m>"] = false,       -- { "toggle_maximize", mode = { "i", "n" } },
                    ["<C-q>"] = false,       -- { "qflist", mode = { "i", "n" } },
                    ["<C-s>"] = false,       -- { "edit_split", mode = { "i", "n" } },
                    ["<C-v>"] = false,       -- { "edit_vsplit", mode = { "i", "n" } },
                    ["<C-b>"] = false,       -- { "preview_scroll_up", mode = { "i", "n" } },
                    ["<C-f>"] = false,       -- { "preview_scroll_down", mode = { "i", "n" } },
                    ["<C-u>"] = false,       -- { "list_scroll_up", mode = { "i", "n" } },
                    ["<C-d>"] = false,       -- { "list_scroll_down", mode = { "i", "n" } },
                    ["<C-Down>"] = false,    -- { "history_forward", mode = { "i", "n" } },
                    ["<C-Up>"] = false,      -- { "history_back", mode = { "i", "n" } },
                    ["<S-CR>"] = false,      -- { { "pick_win", "jump" }, mode = { "n", "i" } },
                    ["<C-t>"] = false,       -- { "tab", mode = { "n", "i" } },
                    ["<C-k>"] = false,       -- { "list_up", mode = { "i", "n" } },
                    ["<C-p>"] = false,       -- { "list_up", mode = { "i", "n" } },
                    ["<C-j>"] = false,       -- { "list_down", mode = { "i", "n" } },
                    ["<C-n>"] = false,       -- { "list_down", mode = { "i", "n" } },
                    ["<C-w>"] = false,       -- { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                    ["<C-r>#"] = false,      -- { "insert_alt", mode = "i" },
                    ["<C-r>%"] = false,      -- { "insert_filename", mode = "i" },
                    ["<C-r><C-a>"] = false,  -- { "insert_cWORD", mode = "i" },
                    ["<C-r><C-f>"] = false,  -- { "insert_file", mode = "i" },
                    ["<C-r><C-l>"] = false,  -- { "insert_line", mode = "i" },
                    ["<C-r><C-p>"] = false,  -- { "insert_file_full", mode = "i" },
                    ["<C-r><C-w>"] = false,  -- { "insert_cword", mode = "i" },
                    ["<C-w>H"] = false,      -- "layout_left",
                    ["<C-w>J"] = false,      -- "layout_bottom",
                    ["<C-w>K"] = false,      -- "layout_top",
                    ["<C-w>L"] = false,      -- "layout_right",
                    ["q"] = false,           -- "cancel",
                },
                b = {
                    minipairs_disable = true,
                }
            },

            -- Result list window
            list = {
                keys = {
                    ["i"] = "list_up",
                    ["k"] = "list_down",
                    ["t"] = "explorer_close",  -- Collapse dir
                    ["l"] = "confirm",
                    ["T"] = "explorer_close_all",
                    ["I"] = "toggle_ignored",
                    ["H"] = "toggle_hidden",
                    [","] = "explorer_up",     -- "cd" into parent dir
                    ["."] = "explorer_focus",  -- "cd" into dir
                    ["n"] = "explorer_add",
                    ["R"] = "explorer_del",
                    ["r"] = "explorer_rename",
                    ["x"] = { "explorer_yank", mode = { "n", "x" } },
                    ["c"] = "explorer_copy",
                    ["v"] = "explorer_paste",
                    ["P"] = "toggle_preview",
                    ["m"] = "explorer_move",
                    ["/"] = "focus_input",
                    ["<Leader>g"] = "picker_grep",

                    -- Unset default bindings
                    ["<Leader>/"] = false,  -- "picker_grep",
                    ["<C-c>"] = false,      -- "tcd",
                    ["<C-t>"] = false,      -- "terminal",
                    ["u"] = false,          -- "explorer_update",
                    ["o"] = false,          -- "explorer_open", -- open with system application
                    ["]g"] = false,         -- "explorer_git_next",
                    ["[g"] = false,         -- "explorer_git_prev",
                    ["]d"] = false,         -- "explorer_diagnostic_next",
                    ["[d"] = false,         -- "explorer_diagnostic_prev",
                    ["]w"] = false,         -- "explorer_warn_next",
                    ["[w"] = false,         -- "explorer_warn_prev",
                    ["]e"] = false,         -- "explorer_error_next",
                    ["[e"] = false,         -- "explorer_error_prev",
                }
            }
        },

        -- Preview window
        preview = {
            keys = {
                ["<Esc>"] = "cancel",
                ["q"] = "cancel",
                ["/"] = "focus_input",
                ["<A-w>"] = "cycle_win",
            }
        }
    },

    -- INDENT CONFIG
    -- (source "snacks.nvim/lua/snacks/indent.lua")
    indent = {
        indent = {
            priority = 1,
            enabled = true,        -- Enable indent guides
            only_scope = false,    -- Only show indent guides of the scope
            only_current = false,  -- Only show indent guides in the current window
            hl = "SnacksIndent",   ---@type string|string[] hl groups for indent guides
        },

        -- Animate scopes. Enabled by default for Neovim >= 0.10
        -- Works on older versions but has to trigger redraws during animation.
        --   * out: animate outwards from the cursor
        --   * up: animate upwards from the cursor
        --   * down: animate downwards from the cursor
        --   * up_down: animate up or down based on the cursor position
        animate = {
            enabled = vim.fn.has("nvim-0.10") == 1,
            style = "out",
            easing = "linear",
            duration = {
                step = 20,    -- ms per step
                total = 500,  -- Maximum duration
            }
        },

        scope = {
            enabled = true,            -- Enable highlighting the current scope
            priority = 200,
            char = "│",
            underline = false,         -- Underline the start of the scope
            only_current = false,      -- Only show scope in the current window
            hl = "SnacksIndentScope",  ---@type string|string[] hl group for scopes
        },

        chunk = {
            -- When enabled, scopes will be rendered as chunks, except for the
            -- top-level scope which will be rendered as a scope.
            enabled = false,
            only_current = false,      -- Only show chunk scopes in the current window
            priority = 200,
            hl = "SnacksIndentChunk",  ---@type string|string[] hl group for chunk scopes
            char = {
                corner_top = "┌",
                corner_bottom = "└",
                horizontal = "─",
                vertical = "│",
                arrow = ">",
            }
        }
    }
}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },

    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },

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
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },  -- resume previous picker state
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },


    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },

    -- bugged
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },

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
                }
            })
        end
    }
}

-- INIT
--------------------------------------------------------------------------------
M.init = function()
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
        end
    })
end

return M
