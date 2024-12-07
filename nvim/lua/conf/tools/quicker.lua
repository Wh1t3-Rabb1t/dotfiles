--               _      _
--    __ _ _   _(_) ___| | _____ _ __
--   / _` | | | | |/ __| |/ / _ \ '__|
--  | (_| | |_| | | (__|   <  __/ |
--   \__, |\__,_|_|\___|_|\_\___|_|
-- =====|_|=====================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "quicker")
    if not status_ok then return end

    -- Setup
    local icons = require("util.icons").quicker
    require("quicker").setup({
        -- Local options to set for quickfix
        opts = {
            buflisted = false,
            number = false,
            relativenumber = false,
            signcolumn = "auto",
            winfixheight = true,
            wrap = false,
        },

        -- Set to false to disable the default options in `opts`
        use_default_opts = true,

        -- Keymaps to set for the quickfix buffer
        keys = {
            -- {
            --     ">",
            --     "<cmd>lua require('quicker').expand()<CR>",
            --     desc = "Expand quickfix content"
            -- },
        },

        -- Callback function to run any custom logic or keymaps for the quickfix buffer
        on_qf = function(bufnr) end,
        edit = {
            -- Enable editing the quickfix like a normal buffer
            enabled = true,

            -- Set to true to write buffers after applying edits.
            -- Set to "unmodified" to only write unmodified buffers.
            autosave = "unmodified",
        },

        -- Keep the cursor to the right of the filename and lnum columns
        constrain_cursor = true,
        highlight = {
            -- Use treesitter highlighting
            treesitter = true,

            -- Use LSP semantic token highlighting
            lsp = true,

            -- Load referenced buffers for more accurate highlights (may be slow)
            load_buffers = false,
        },

        -- Map of quickfix item type to icon
        type_icons = {
            E = icons.E,
            W = icons.W,
            I = icons.I,
            N = icons.N,
            H = icons.H,
        },

        -- Border characters
        borders = {
            vert = icons.vert,

            -- Strong headers separate results from different files
            strong_header = icons.strong_header,
            strong_cross = icons.strong_cross,
            strong_end = icons.strong_end,

            -- Soft headers separate results within the same file
            soft_header = icons.soft_header,
            soft_cross = icons.soft_cross,
            soft_end = icons.soft_end,
        },

        -- Trim the leading whitespace from results
        trim_leading_whitespace = true,

        -- Maximum width of the filename column
        max_filename_width = function()
            return math.floor(math.min(95, vim.o.columns / 2))
        end,

        -- How far the header should extend to the right
        header_length = function(type, start_col)
            return vim.o.columns - start_col
        end
    })
end

return M
