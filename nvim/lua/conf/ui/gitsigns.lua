--         _ _       _
--    __ _(_) |_ ___(_) __ _ _ __  ___
--   / _` | | __/ __| |/ _` | '_ \/ __|
--  | (_| | | |_\__ \ | (_| | | | \__ \
--   \__, |_|\__|___/_|\__, |_| |_|___/
-- ==|___/=============|___/====================================================

local M = {}

-- KEYS
--------------------------------------------------------------------
M.keys = {
    {
        mode = { "n" },
        "gr",
        "<cmd>Gitsigns refresh<CR>",
        desc = " Gitsigns refresh"
    },
    {
        mode = { "n" },
        "ghl",
        "<cmd>Gitsigns toggle_numhl<CR>",
        desc = " Gitsigns toggle number line highlights"
    },
    {
        mode = { "n" },
        "ghi",
        "<cmd>Gitsigns toggle_linehl<CR>",
        desc = " Gitsigns toggle inline bg highlights"
    },
    {
        mode = { "n" },
        "gP",
        "<cmd>Gitsigns diffthis<CR>",
        desc = " Gitsigns show diff"
    },
    {
        mode = { "n" },
        "gp",
        "<cmd>Gits preview_hunk<CR>",
        desc = " Gitsigns preview hunk in popup"
    },
    {
        mode = { "n" },
        "gk",
        "<cmd>Gitsigns next_hunk<CR>",
        desc = " Gitsigns go to next hunk"
    },
    {
        mode = { "n" },
        "gi",
        "<cmd>Gitsigns prev_hunk<CR>",
        desc = " Gitsigns go to previous hunk"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "gitsigns")
    if not status_ok then return end

    -- Setup
    require("gitsigns").setup({
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },

        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl = false,      -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false,     -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false,  -- Toggle with `:Gitsigns toggle_word_diff`

        watch_gitdir = {
            follow_files = true
        },

        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false,  -- Toggle with `:Gitsigns toggle_current_line_blame`

        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",   -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
        },

        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,   -- Use default
        max_file_length = 40000,  -- Disable if file is longer than this (in lines)

        -- Options passed to nvim_open_win
        preview_config = {
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        }
    })
end

return M
