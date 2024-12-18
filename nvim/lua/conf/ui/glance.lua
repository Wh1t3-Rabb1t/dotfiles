--         _
--    __ _| | __ _ _ __   ___ ___
--   / _` | |/ _` | '_ \ / __/ _ \
--  | (_| | | (_| | | | | (_|  __/
--   \__, |_|\__,_|_| |_|\___\___|
-- ==|___/======================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "glance")
    if not status_ok then return end

    -- Setup
    local icons = require("util.icons").glance
    local actions = require("glance").actions
    require("glance").setup({
        height = 18,  -- Height of the window
        zindex = 45,

        -- By default glance will open preview "embedded" within your active window
        -- when `detached` is enabled, glance will render above all existing windows
        -- and won't be restiricted by the width of your active window.
        detached = true,

        -- Configure preview window options
        preview_win_opts = {
            cursorline = true,
            number = true,
            wrap = false,
        },
        border = {
            enable = false,  -- (only horizontal borders allowed)
            top_char = "―",
            bottom_char = "―",
        },
        list = {
            position = "left",   -- Position of the list window 'left'|'right'
            width = 0.33,        -- 33% width relative to the active window, min 0.1, max 0.5
        },
        theme = {
            enable = true,  -- Generate colors based on your current colorscheme
            mode = "auto",  -- 'brighten'|'darken'|'auto', 'auto' will adjust to colorscheme
        },
        mappings = {
            list = {
                ["k"] = actions.next,
                ["i"] = actions.previous,
                ["<Down>"] = actions.next,
                ["<Up>"] = actions.previous,
                ["l"] = actions.open_fold,
                ["t"] = actions.close_fold,
                ["<PageUp>"] = actions.preview_scroll_win(5),
                ["<PageDown>"] = actions.preview_scroll_win(-5),
                ["<Tab>"] = actions.next_location,        -- Goto next match in the list
                ["<S-Tab>"] = actions.previous_location,  -- Goto previous match in the list
                ["v"] = actions.jump_vsplit,
                ["s"] = actions.jump_split,
                ["<CR>"] = actions.jump,
                ["o"] = actions.jump,
                ["<leader>l"] = actions.enter_win("preview"),  -- Focus preview window
                ["q"] = actions.close,
                ["Q"] = actions.close,
                ["<Esc>"] = actions.close,
                ["<C-q>"] = actions.quickfix,
                -- ["t"] = actions.jump_tab,
                -- ['<Esc>'] = false -- disable a mapping
            },
            preview = {
                ["Q"] = actions.close,
                ["<Tab>"] = actions.next_location,
                ["<S-Tab>"] = actions.previous_location,
                ["<leader>l"] = actions.enter_win("list"),  -- Focus list window
            }
        },
        hooks = {},
        folds = {
            fold_closed = icons.fold_closed,
            fold_open = icons.fold_open,
            folded = true,  -- Automatically fold list on startup
        },
        indent_lines = {
            enable = true,
            icon = icons.icon,
        },
        winbar = {
            enable = true,
        },
        use_trouble_qf = false,
    })
end

return M
