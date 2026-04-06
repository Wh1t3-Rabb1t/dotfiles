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
    indent = { enabled = true },

    -- PICKER CONFIG
    -- (source "snacks.nvim/lua/snacks/picker/config/defaults.lua")
    picker = {
        prompt = " ",
        finder = "explorer",
        focus = "input",    -- (input|list)
        auto_close = true,  -- 'true' is required to prevent window hanging on select
        jump = { close = true },

        sources = {
            -- Disable preview and tweak matcher settings for 'keymaps' picker
            keymaps = {
                layout = { preview = { enabled = false } },
                matcher = {
                    smartcase = false,   -- Disable smartcase
                    ignorecase = false,  -- Disable ignorecase
                }
            },
            -- Set explorer only to the right side panel
            explorer = {
                layout = { layout = { position = "right" } },
            }
        },

        matcher = {
            fuzzy = true,       -- Use fuzzy matching
            smartcase = true,   -- Use smartcase
            ignorecase = true,  -- Use ignorecase
        },

        win = {
            -- Input window
            input = {
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
                    ["<A-m>"]      = false,  -- { "toggle_maximize", mode = { "i", "n" } },
                    ["<C-q>"]      = false,  -- { "qflist", mode = { "i", "n" } },
                    ["<C-s>"]      = false,  -- { "edit_split", mode = { "i", "n" } },
                    ["<C-v>"]      = false,  -- { "edit_vsplit", mode = { "i", "n" } },
                    ["<C-b>"]      = false,  -- { "preview_scroll_up", mode = { "i", "n" } },
                    ["<C-f>"]      = false,  -- { "preview_scroll_down", mode = { "i", "n" } },
                    ["<C-u>"]      = false,  -- { "list_scroll_up", mode = { "i", "n" } },
                    ["<C-d>"]      = false,  -- { "list_scroll_down", mode = { "i", "n" } },
                    ["<C-Down>"]   = false,  -- { "history_forward", mode = { "i", "n" } },
                    ["<C-Up>"]     = false,  -- { "history_back", mode = { "i", "n" } },
                    ["<S-CR>"]     = false,  -- { { "pick_win", "jump" }, mode = { "n", "i" } },
                    ["<C-t>"]      = false,  -- { "tab", mode = { "n", "i" } },
                    ["<C-k>"]      = false,  -- { "list_up", mode = { "i", "n" } },
                    ["<C-p>"]      = false,  -- { "list_up", mode = { "i", "n" } },
                    ["<C-j>"]      = false,  -- { "list_down", mode = { "i", "n" } },
                    ["<C-n>"]      = false,  -- { "list_down", mode = { "i", "n" } },
                    ["<C-w>"]      = false,  -- { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                    ["<C-r>#"]     = false,  -- { "insert_alt", mode = "i" },
                    ["<C-r>%"]     = false,  -- { "insert_filename", mode = "i" },
                    ["<C-r><C-a>"] = false,  -- { "insert_cWORD", mode = "i" },
                    ["<C-r><C-f>"] = false,  -- { "insert_file", mode = "i" },
                    ["<C-r><C-l>"] = false,  -- { "insert_line", mode = "i" },
                    ["<C-r><C-p>"] = false,  -- { "insert_file_full", mode = "i" },
                    ["<C-r><C-w>"] = false,  -- { "insert_cword", mode = "i" },
                    ["<C-w>H"]     = false,  -- "layout_left",
                    ["<C-w>J"]     = false,  -- "layout_bottom",
                    ["<C-w>K"]     = false,  -- "layout_top",
                    ["<C-w>L"]     = false,  -- "layout_right",
                    ["q"]          = false,  -- "cancel",
                }
            },

            -- Result list window
            list = {
                keys = {
                    ["i"]     = "list_up",
                    ["k"]     = "list_down",
                    ["t"]     = "explorer_close",  -- Collapse dir
                    ["l"]     = "confirm",
                    ["T"]     = "explorer_close_all",
                    ["I"]     = "toggle_ignored",
                    ["H"]     = "toggle_hidden",
                    [","]     = "explorer_up",     -- "cd" into parent dir
                    ["."]     = "explorer_focus",  -- "cd" into dir
                    ["n"]     = "explorer_add",
                    ["R"]     = "explorer_del",
                    ["r"]     = "explorer_rename",
                    ["x"]     = { "explorer_yank", mode = { "n", "x" } },
                    ["c"]     = "explorer_copy",
                    ["v"]     = "explorer_paste",
                    ["P"]     = "toggle_preview",
                    ["m"]     = "explorer_move",
                    ["/"]     = "focus_input",
                    ["<A-g>"] = "picker_grep",

                    -- Unset default bindings
                    ["<Leader>/"] = false,  -- "picker_grep",
                    ["<C-c>"]     = false,  -- "tcd",
                    ["<C-t>"]     = false,  -- "terminal",
                    ["u"]         = false,  -- "explorer_update",
                    ["o"]         = false,  -- "explorer_open",  -- Open with system application
                    ["]g"]        = false,  -- "explorer_git_next",
                    ["[g"]        = false,  -- "explorer_git_prev",
                    ["]d"]        = false,  -- "explorer_diagnostic_next",
                    ["[d"]        = false,  -- "explorer_diagnostic_prev",
                    ["]w"]        = false,  -- "explorer_warn_next",
                    ["[w"]        = false,  -- "explorer_warn_prev",
                    ["]e"]        = false,  -- "explorer_error_next",
                    ["[e"]        = false,  -- "explorer_error_prev",
                }
            }
        }
    }
}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    -- Top Pickers & Explorer
    { "<Leader>e", function() Snacks.explorer() end, desc = " File Explorer" },
    { "<Leader>f", function() Snacks.picker.files() end, desc = " Find Files" },
    { "<Leader>k", function() Snacks.picker.keymaps() end, desc = " Keymaps" },
    -- { "g", function() Snacks.picker.keymaps() end, desc = " Keymaps" },
    { "<Leader>r", function() Snacks.picker.registers() end, desc = " Registers" },
    { "<A-g>", function() Snacks.picker.grep() end, desc = " Grep" },
    { "<A-'>", function() Snacks.picker.buffers() end, desc = " Buffers" },
    { "<A-f>", function() Snacks.picker.lines() end, desc = " Buffer Lines" },

    -- git
    { "<Leader>gb", function() Snacks.picker.git_branches() end, desc = " Git Branches" },
    { "<Leader>gl", function() Snacks.picker.git_log() end, desc = " Git Log" },
    { "<Leader>gL", function() Snacks.picker.git_log_line() end, desc = " Git Log Line" },
    { "<Leader>gs", function() Snacks.picker.git_status() end, desc = " Git Status" },
    { "<Leader>gS", function() Snacks.picker.git_stash() end, desc = " Git Stash" },
    { "<Leader>gd", function() Snacks.picker.git_diff() end, desc = " Git Diff (Hunks)" },
    { "<Leader>gf", function() Snacks.picker.git_log_file() end, desc = " Git Log File" },

    -- Grep
    { "<Leader>sB", function() Snacks.picker.grep_buffers() end, desc = " Grep Open Buffers" },
    { "<Leader>sg", function() Snacks.picker.grep() end, desc = " Grep" },
    { "<Leader>sw", function() Snacks.picker.grep_word() end, desc = " Visual selection or word", mode = { "n", "x" } },

    -- search
    { "<Leader>su", function() Snacks.picker.undo() end, desc = " Undo History" },
    { "<Leader>uC", function() Snacks.picker.colorschemes() end, desc = " Colorschemes" },
    { "<Leader>si", function() Snacks.picker.icons() end, desc = " Icons" },
    { "<Leader>sj", function() Snacks.picker.jumps() end, desc = " Jumps" },
    { "<Leader>sR", function() Snacks.picker.resume() end, desc = " Resume" },  -- Resume previous picker state




    { "<Leader>sc", function() Snacks.picker.commands() end, desc = " Commands" },
    { "<Leader>sm", function() Snacks.picker.marks() end, desc = " Marks" },
    { "<Leader>sq", function() Snacks.picker.qflist() end, desc = " Quickfix List" },
    { "<Leader>sC", function() Snacks.picker.command_history() end, desc = " Command History" },
    { '<Leader>s/', function() Snacks.picker.search_history() end, desc = " Search History" },
    { "<Leader>sh", function() Snacks.picker.help() end, desc = " Help Pages" },
    { "<Leader>sH", function() Snacks.picker.highlights() end, desc = " Highlights" },
    { "<Leader>sa", function() Snacks.picker.autocmds() end, desc = " Autocmds" },
    { "<Leader>sd", function() Snacks.picker.diagnostics() end, desc = " Diagnostics" },
    { "<Leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = " Buffer Diagnostics" },
    { "<Leader>sM", function() Snacks.picker.man() end, desc = " Man Pages" },
    { "<Leader>sp", function() Snacks.picker.lazy() end, desc = " Search for Plugin Spec" },

    -- LSP
    { "<Leader>ss", function() Snacks.picker.lsp_symbols() end, desc = " LSP Symbols" },
    { "<Leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = " LSP Workspace Symbols" },

    -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },

    -- Other
    { "<Leader>z",  function() Snacks.zen.zoom() end, desc = " Toggle Zoom" },
    { "<Leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<Leader>gB", function() Snacks.gitbrowse() end, desc = " Git Browse", mode = { "n", "v" } },
    { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
        "<Leader>N",
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
