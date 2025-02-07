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
    local options = { noremap = true, silent = true }

    -- Silent is detrimental to cmd line bindings
    if mode == "c" then options.silent = false end

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end


-- ADD SELECTION TO REGISTER STACK
--------------------------------------------------------------------------------
function M.shift_up_register_stack()
    local contents = {}

    -- ASCII values for 'a' (97) to 'z' (122)
    for i = 97, 122 do
        local reg = string.char(i)
        local selection = vim.fn.getreg(reg)

        -- Cache registers
        if selection ~= "" then
            contents[reg] = selection
        else
            break
        end
    end

    -- Start from 'y' (ASCII 121) to 'a' (ASCII 97) in reverse order
    for i = 121, 97, -1 do
        local reg_current = string.char(i)
        local reg_next = string.char(i + 1)

        -- Shift the contents up by one index
        if contents[reg_current] then
            vim.fn.setreg(reg_next, contents[reg_current])
        end
    end
end


-- CLEANUP REGISTERS
--------------------------------------------------------------------------------
function M.cleanup_registers()
    -- Alphabetical
    for char = 97, 122 do
        vim.fn.setreg(string.char(char), {})
    end

    -- Numbered
    for num = 0, 9 do
        vim.fn.setreg(tostring(num), {})
    end

    -- Save to shada
    vim.cmd.wshada({ bang = true })
end


-- CLEANUP MARKS
--------------------------------------------------------------------------------
function M.cleanup_marks()
    vim.cmd.delm({ bang = true })
    vim.cmd.delm("A-Z0-9")
    vim.cmd.delm('"<>')
    vim.cmd.wshada({ bang = true })
end


-- SYNC GRAPPLE TAG AND BARBAR TAB INDEXES
--------------------------------------------------------------------------------
-- 󰣈 󰣈 󰣈 󰣈 Lumberjack hack attack!
function M.sync_grapple_and_barbar_indexes()
    local grapple_tags = require("grapple").statusline()
    if not grapple_tags then return end

    -- Remove all Barbar pins
    local state = require("barbar.state")
    for _, buf in ipairs(state.buffers) do
        local data = state.get_buffer_data(buf)
        data.pinned = false
    end

    -- Match the final integer only (single digit at the end)
    local tag_count = tonumber(grapple_tags:match("(%d)%s*$"))
    if not tag_count then return end

    -- Pin each Grapple tagged buffer in ascending order
    for i = 1, tag_count do
        require("grapple").select({ index = i })
        vim.cmd("BufferPin")
    end
end

return M
