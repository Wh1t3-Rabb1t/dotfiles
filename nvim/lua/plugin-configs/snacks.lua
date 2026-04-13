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
    bigfile = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    words = { enabled = false },  -- Default off, toggle on/off via keybindings

    -- Enabled
    explorer = { enabled = true },
    notifier = { enabled = true },
    statuscolumn = { enabled = true },
    git = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },

    -- WINDOW STYLES
    -- (doc: "https://github.com/folke/snacks.nvim/blob/main/docs/styles.md")
    styles = {
        input = {
            -- Escape cancels popup rather than entering normal mode
            keys = { i_esc = { "<Esc>", "cancel", mode = "i", expr = true } }
        }
    },

    -- PICKER CONFIG
    -- (source: "snacks.nvim/lua/snacks/picker/config/defaults.lua")
    picker = {
        prompt = " ",
        finder = "explorer",
        focus = "input",    -- (input,list)
        auto_close = true,  -- 'true' is required to prevent window hanging on select
        jump = { close = true },

        sources = {
            keymaps = {
                -- Disable preview for the 'keymaps' picker
                layout = { preview = { enabled = false } },
            },
            explorer = {
                -- Set explorer only to the right side panel
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
                    ["<A-r>"]         = { "toggle_regex",        mode = { "i", "n" } },
                    ["<A-/>"]         = { "toggle_help_input",   mode = { "i", "n" } },

                    -- Insert only
                    ["<C-c>"]  = { "cancel",  mode = "i" },
                    ["<A-BS>"] = { "<c-s-w>", mode = "i", expr = true, desc = "delete word" },
                }
            },

            -- Result list window
            list = {
                keys = {
                    ["i"]         = "list_up",
                    ["k"]         = "list_down",
                    ["d"]         = "list_down",
                    ["t"]         = "explorer_close",  -- Collapse dir
                    ["l"]         = "confirm",
                    ["T"]         = "explorer_close_all",
                    ["I"]         = "toggle_ignored",
                    ["H"]         = "toggle_hidden",
                    [","]         = "explorer_up",     -- "cd" into parent dir
                    ["."]         = "explorer_focus",  -- "cd" into dir
                    ["n"]         = "explorer_add",
                    ["R"]         = "explorer_del",
                    ["r"]         = "explorer_rename",
                    ["x"]         = { "explorer_yank", mode = { "n", "x" } },
                    ["c"]         = "explorer_copy",
                    ["v"]         = "explorer_paste",
                    ["P"]         = "toggle_preview",
                    ["m"]         = "explorer_move",
                    ["/"]         = "focus_input",
                    ["<Leader>g"] = "picker_grep",
                }
            }
        }
    }
}

 -- KEYS
 --------------------------------------------------------------------------------
M.keys = {
    -- Prime binding real estate
    -- --------------------------
    -- Leader: v k m u p _ -
    -- g: t l i m n o u

    -- Top Pickers & Explorer
    { desc = " File Explorer",   "<Leader>e",       function() Snacks.explorer() end },
    { desc = " Keymaps",         "gk",              function() Snacks.picker.keymaps() end },
    { desc = " Marks (pins)",    "gp",              function() Snacks.picker.marks() end },
    { desc = " Command History", "g;",              function() Snacks.picker.command_history() end },
    { desc = " Search History",  "g/",              function() Snacks.picker.search_history() end },
    { desc = " Buffers",         "<Leader>b",       function() Snacks.picker.buffers() end },
    { desc = " Find Files",      "<Leader>f",       function() Snacks.picker.files() end },
    { desc = " Registers",       "<Leader>r",       function() Snacks.picker.registers() end },
    { desc = " Undo History",    "<Leader>y",       function() Snacks.picker.undo() end },
    { desc = " Resume",          "<Leader><Space>", function() Snacks.picker.resume() end },

    -- Grep
    { desc = " Grep",           "<Leader>g", function() Snacks.picker.grep() end },
    { desc = " Grep Selection", "<Leader>g", function() Snacks.picker.grep_word() end, mode = { "x" } },
    { desc = " Grep Workspace", "<Leader>a", function() Snacks.picker.grep_buffers() end },

    -- Git
    { desc = " Git Branches",     "<Leader>ib", function() Snacks.picker.git_branches() end },
    { desc = " Git Log",          "<Leader>il", function() Snacks.picker.git_log() end },
    { desc = " Git Log L[i]ne",   "<Leader>ii", function() Snacks.picker.git_log_line() end },
    { desc = " Git Status",       "<Leader>is", function() Snacks.picker.git_status() end },
    { desc = " Git S[t]ash",      "<Leader>it", function() Snacks.picker.git_stash() end },
    { desc = " Git Diff (Hunks)", "<Leader>id", function() Snacks.picker.git_diff() end },
    { desc = " Git Log File",     "<Leader>if", function() Snacks.picker.git_log_file() end },
    { desc = " Git B[r]owse",     "<Leader>ir", function() Snacks.gitbrowse() end, mode = { "n", "v" } },

    -- Search
    { desc = " Buffer Lines",         "<Leader>sl", function() Snacks.picker.lines() end },
    { desc = " Icons",                "<Leader>si", function() Snacks.picker.icons() end },
    { desc = " Jumps",                "<Leader>sj", function() Snacks.picker.jumps() end },
    { desc = " Commands",             "<Leader>sc", function() Snacks.picker.commands() end },
    { desc = " Color[s]chemes",       "<Leader>ss", function() Snacks.picker.colorschemes() end },
    { desc = " Help Pages",           "<Leader>sh", function() Snacks.picker.help() end },
    { desc = " Man Pages",            "<Leader>sm", function() Snacks.picker.man() end },
    { desc = " Quickfix List",        "<Leader>sq", function() Snacks.picker.qflist() end },
    { desc = " Highlights",           "<Leader>sH", function() Snacks.picker.highlights() end },
    { desc = " Autocmds",             "<Leader>sa", function() Snacks.picker.autocmds() end },
    { desc = " Diagnostics",          "<Leader>sd", function() Snacks.picker.diagnostics() end },
    { desc = " B[u]ffer Diagnostics", "<Leader>su", function() Snacks.picker.diagnostics_buffer() end },
    { desc = " Search Plugin Specs",  "<Leader>sp", function() Snacks.picker.lazy() end },

    -- LSP
    { desc = " LSP Symbols",                "<Leader>ls", function() Snacks.picker.lsp_symbols() end },
    { desc = " LSP Workspace Symbols",      "<Leader>lw", function() Snacks.picker.lsp_workspace_symbols() end },
    { desc = " LSP References",             "<Leader>lr", function() Snacks.picker.lsp_references() end, nowait = true },
    { desc = " LSP Goto Definition",        "<Leader>ld", function() Snacks.picker.lsp_definitions() end },
    { desc = " LSP Goto D[e]claration",     "<Leader>le", function() Snacks.picker.lsp_declarations() end },
    { desc = " LSP Goto I[m]plementation",  "<Leader>lm", function() Snacks.picker.lsp_implementations() end },
    { desc = " LSP Goto T[y]pe Definition", "<Leader>ly", function() Snacks.picker.lsp_type_definitions() end },
    { desc = " LSP Calls Incoming",         "<Leader>li", function() Snacks.picker.lsp_incoming_calls() end },
    { desc = " LSP Calls Outgoing",         "<Leader>lo", function() Snacks.picker.lsp_outgoing_calls() end },
    {
        desc = " Word reference highlights toggle",
        "<Leader>;r",
        function()
            if Snacks.words.is_enabled() then
                Snacks.words.disable()
                vim.notify("Snacks lsp words: OFF")
            else
                Snacks.words.enable()
                vim.notify("Snacks lsp words: ON")
            end
        end
    },

    -- Other
    { desc = " Notification History",      "<Leader>n", function() Snacks.notifier.show_history() end },
    { desc = " Dismiss All Notifications", "<Leader>N", function() Snacks.notifier.hide() end },
    {
        desc = " Neovim News",
        "<Leader>sN",
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
    local status_ok = pcall(require, "snacks")
    if not status_ok then return end

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
