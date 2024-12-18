--   _            __
--  | |__   __ _ / _|
--  | '_ \ / _` | |_
--  | |_) | (_| |  _|
--  |_.__/ \__, |_|
-- ===========|_|===============================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
M.config = function()
    local status_ok = pcall(require, "bqf")
    if not status_ok then return end

    -- Setup
    require("bqf").setup({
        auto_enable = true,
        magic_window = true,
        auto_resize_height = false,

        func_map = {
            open = "<CR>",        -- Open item under cursor
            openc = "",           -- Open and close quickfix
            drop = "",            -- Open with drop (plugin)
            tabdrop = "",         -- Open with tabdrop (plugin)
            tab = "",             -- Open in a new tab
            tabb = "",            -- Open in a new tab but stay in quickfix
            tabc = "",            -- Open in a new tab and leave quickfix
            split = "",           -- Open in horizontal split
            vsplit = "",          -- Open in vertical split
            prevfile = "",        -- Goto prev file under cursor in quickfix
            nextfile = "",        -- Goto next file under cursor in quickfix
            prevhist = "",        -- Goto prev history entry in quickfix
            nexthist = "",        -- Goto next history entry in quickfix
            lastleave = "",       -- Goto last selected item in quickfix
            stoggleup = "",       -- Toggle sign and move cursor up
            stoggledown = "",     -- Toggle sign and move cursor down
            stogglevm = "",       -- Toggle multiple signs in visual mode
            stogglebuf = "",      -- Toggle signs for buffer under cursor
            sclear = "",          -- Clear signs in quickfix list
            pscrollup = "",       -- Scroll up half page in preview window
            pscrolldown = "",     -- Scroll down half page in preview window
            pscrollrorig = "",    -- Scroll original position in preview window
            ptogglemode = "",     -- Toggle preview window normal / max size
            ptoggleitem = "",     -- Toggle preview for a quickfix list item
            ptoggleauto = "",     -- Toggle auto preview when cursor moves
            filter = "",          -- Create new list for signed items
            filterr = "",         -- Create new list for non-signed items
            fzffilter = "Y",  -- Enter fzf mode
        },

        preview = {
            auto_preview = true,
            show_title = true,
            delay_syntax = 50,
            wrap = false,
            should_preview_cb = function(bufnr)
                local ret = true
                local filename = vim.api.nvim_buf_get_name(bufnr)
                local fsize = vim.fn.getfsize(filename)

                -- File size greater than 100k can't be previewed automatically
                if fsize > 100 * 1024 then
                    ret = false
                end

                return ret
            end
        }
    })
end

return M
