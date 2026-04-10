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


-- CLEANUP MARKS
--------------------------------------------------------------------------------
function M.cleanup_marks()
    vim.cmd.delm("A-Z0-9")
    vim.cmd.delm('"<>')
    vim.cmd.wshada({ bang = true })
end

return M
