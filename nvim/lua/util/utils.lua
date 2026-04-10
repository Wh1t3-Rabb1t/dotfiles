--         _   _ _
--   _   _| |_(_) |___
--  | | | | __| | / __|
--  | |_| | |_| | \__ \
--   \__,_|\__|_|_|___/
-- =============================================================================

local M = {}

-- REMAP KEYS
--------------------------------------------------------------------------------
function M.map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true, nowait = true }

    -- Silent is detrimental to cmd line bindings
    if mode == "c" then
        options.silent = false
    end

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end


-- WINDOW COUNT
--------------------------------------------------------------------------------
function M.open_win_count()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local visible_wins = 0

    for _, win in ipairs(wins) do
        local config = vim.api.nvim_win_get_config(win)

        -- Ignore floating and other non-normal windows
        if not config.relative or config.relative == '' then
            visible_wins = visible_wins + 1
        end
    end

    return visible_wins
end


-- CLEANUP WINDOWS
--------------------------------------------------------------------------------
function M.cleanup_windows()
    local excluded_ft = { "checkhealth" }

    -- Close unwanted buffers if open
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local ft = vim.bo[bufnr].filetype

        if vim.tbl_contains(excluded_ft, ft) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end
end


-- CLEANUP MARKS
--------------------------------------------------------------------------------
function M.cleanup_marks()
    vim.cmd.delm("A-Z0-9")
    vim.cmd.delm('"<>')
    vim.cmd.wshada({ bang = true })
end

return M
