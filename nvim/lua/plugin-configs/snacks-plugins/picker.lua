
-- Source "snacks.nvim/lua/snacks/picker/config/defaults.lua"

return {
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
    focus = "input",
    -- focus = "list",
    auto_close = true,  -- 'ture' is required to prevent window hanging on select
    jump = { close = false },
    layout = { preview = true },
    -- layout = { preset = "sidebar", preview = false },
    -- to show the explorer to the right, add the below to
    -- your config under `opts.picker.sources.explorer`
    -- layout = { layout = { position = "right" } },

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
            keys = {
                -- to close the picker on ESC instead of going to normal mode,
                -- add the following keymap to your config
                -- ["/"] = "toggle_focus",
                -- ["<Esc>"] = "cancel",
                -- ["<Esc>"] = { "toggle_focus", mode = { "i" } },
                ["<Esc>"] = { "close", mode = { "n", "i" } },
                ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
                ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
                ["<C-c>"] = { "cancel", mode = "i" },
                ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                ["<CR>"] = { "confirm", mode = { "n", "i" } },
                ["<Down>"] = { "list_down", mode = { "i", "n" } },
                ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
                ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
                ["<Up>"] = { "list_up", mode = { "i", "n" } },
                ["<a-d>"] = { "inspect", mode = { "n", "i" } },
                ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
                ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
                ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
                ["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
                ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
                ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
                ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
                ["<c-a>"] = { "select_all", mode = { "n", "i" } },
                ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
                ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
                ["<c-j>"] = { "list_down", mode = { "i", "n" } },
                ["<c-k>"] = { "list_up", mode = { "i", "n" } },
                ["<c-n>"] = { "list_down", mode = { "i", "n" } },
                ["<c-p>"] = { "list_up", mode = { "i", "n" } },
                ["<c-q>"] = { "qflist", mode = { "i", "n" } },
                ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
                ["<c-t>"] = { "tab", mode = { "n", "i" } },
                ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
                ["<c-r>#"] = { "insert_alt", mode = "i" },
                ["<c-r>%"] = { "insert_filename", mode = "i" },
                ["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
                ["<c-r><c-f>"] = { "insert_file", mode = "i" },
                ["<c-r><c-l>"] = { "insert_line", mode = "i" },
                ["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
                ["<c-r><c-w>"] = { "insert_cword", mode = "i" },
                ["<c-w>H"] = "layout_left",
                ["<c-w>J"] = "layout_bottom",
                ["<c-w>K"] = "layout_top",
                ["<c-w>L"] = "layout_right",
                ["?"] = "toggle_help_input",
                ["G"] = "list_bottom",
                ["gg"] = "list_top",
                ["j"] = "list_down",
                ["k"] = "list_up",
                ["q"] = "cancel",
            },
            b = {
                minipairs_disable = true,
            },
        },

        -- Result list window
        list = {
            keys = {
                ["i"] = "list_up",
                ["k"] = "list_down",
                ["/"] = "focus_input",


                -- ["<Esc>"] = "focus_list",
                -- ["<Esc>"] = "cancel",


                [","] = "explorer_up",
                ["."] = "explorer_focus",
                ["l"] = "confirm",
                ["t"] = "explorer_close", -- close directory
                ["n"] = "explorer_add",
                ["R"] = "explorer_del",
                ["r"] = "explorer_rename",
                ["x"] = "explorer_copy",
                ["m"] = "explorer_move",
                ["P"] = "toggle_preview",
                ["c"] = { "explorer_yank", mode = { "n", "x" } },
                ["v"] = "explorer_paste",
                ["I"] = "toggle_ignored",
                ["H"] = "toggle_hidden",
                ["T"] = "explorer_close_all",

                ["u"] = "explorer_update",
                ["<c-c>"] = "tcd",
                ["<leader>/"] = "picker_grep",
                ["<c-t>"] = "terminal",

                -- ["o"] = "explorer_open", -- open with system application
                -- ["]g"] = "explorer_git_next",
                -- ["[g"] = "explorer_git_prev",
                -- ["]d"] = "explorer_diagnostic_next",
                -- ["[d"] = "explorer_diagnostic_prev",
                -- ["]w"] = "explorer_warn_next",
                -- ["[w"] = "explorer_warn_prev",
                -- ["]e"] = "explorer_error_next",
                -- ["[e"] = "explorer_error_prev",
            },
        },
    },

    -- preview window
    preview = {
        keys = {
            ["<Esc>"] = "cancel",
            ["q"] = "cancel",
            ["i"] = "focus_input",
            ["<a-w>"] = "cycle_win",
        },
    },
}
